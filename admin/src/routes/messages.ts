import { Router, Response } from 'express';
import { pool } from '../config/database';
import { AuthRequest, authMiddleware } from '../middleware/auth';

const router = Router();
router.use(authMiddleware);

// 获取所有用户列表（用于筛选下拉框）
router.get('/users', async (_req: AuthRequest, res: Response) => {
  const result = await pool.query(`
    SELECT id, username, full_name FROM users ORDER BY username
  `);
  res.json({ data: result.rows });
});

// 获取所有群组列表（用于筛选下拉框）
router.get('/groups', async (_req: AuthRequest, res: Response) => {
  const result = await pool.query(`
    SELECT id, name FROM groups WHERE deleted_at IS NULL ORDER BY name
  `);
  res.json({ data: result.rows });
});

// 通用筛选条件构建（单聊/群聊消息平铺列表共用）
const buildMsgFilters = (query: any, alias: string) => {
  const conds: string[] = [];
  const params: any[] = [];
  const add = (sql: string, value: any) => {
    params.push(value);
    conds.push(sql.replace('?', `$${params.length}`));
  };

  if (query.keyword) add(`${alias}.content ILIKE ?`, `%${query.keyword}%`);
  if (query.sender_id) add(`${alias}.sender_id = ?`, parseInt(query.sender_id));
  if (query.status) add(`${alias}.status = ?`, query.status);
  if (query.message_type) {
    // "call" 表示所有通话类消息（call_ended / call_rejected 等）
    if (query.message_type === 'call') add(`${alias}.message_type LIKE ?`, 'call%');
    else add(`${alias}.message_type = ?`, query.message_type);
  }
  if (query.start_date) add(`${alias}.created_at >= ?`, (query.start_date as string).replace('T', ' '));
  if (query.end_date) add(`${alias}.created_at <= ?`, (query.end_date as string).replace('T', ' '));

  return { conds, params, add };
};

const parsePaging = (query: any) => {
  const page = Math.max(parseInt(query.page) || 1, 1);
  const limit = Math.min(Math.max(parseInt(query.limit) || 20, 1), 200);
  return { page, limit, offset: (page - 1) * limit };
};

// 单聊消息列表（平铺所有用户的聊天记录，支持筛选 + 分页）
router.get('/private', async (req: AuthRequest, res: Response) => {
  const { page, limit, offset } = parsePaging(req.query);
  const { conds, params, add } = buildMsgFilters(req.query, 'm');

  if (req.query.receiver_id) add('m.receiver_id = ?', parseInt(req.query.receiver_id as string));
  // user_id: 该用户参与的所有单聊（发送或接收）
  if (req.query.user_id) {
    params.push(parseInt(req.query.user_id as string));
    conds.push(`(m.sender_id = $${params.length} OR m.receiver_id = $${params.length})`);
  }

  const where = conds.length ? `WHERE ${conds.join(' AND ')}` : '';
  const result = await pool.query(`
    SELECT m.id, m.sender_id, m.sender_name, m.receiver_id, m.receiver_name,
           su.username AS sender_username, su.full_name AS sender_fullname,
           ru.username AS receiver_username, ru.full_name AS receiver_fullname,
           m.content, m.message_type, m.file_name, m.voice_duration, m.call_type,
           m.quoted_message_content, m.status, m.is_read, m.created_at
    FROM synced_messages m
    LEFT JOIN users su ON su.id = m.sender_id
    LEFT JOIN users ru ON ru.id = m.receiver_id
    ${where}
    ORDER BY m.created_at DESC, m.id DESC
    LIMIT $${params.length + 1} OFFSET $${params.length + 2}
  `, [...params, limit, offset]);

  const countResult = await pool.query(`SELECT COUNT(*) FROM synced_messages m ${where}`, params);
  const total = parseInt(countResult.rows[0].count);
  res.json({ data: result.rows, total, page, limit, totalPages: Math.ceil(total / limit) });
});

// 群聊消息列表（平铺所有群组的聊天记录，支持筛选 + 分页）
router.get('/group-list', async (req: AuthRequest, res: Response) => {
  const { page, limit, offset } = parsePaging(req.query);
  const { conds, params } = buildMsgFilters(req.query, 'gm');

  if (req.query.group_id) {
    params.push(parseInt(req.query.group_id as string));
    conds.push(`gm.group_id = $${params.length}`);
  }

  const where = conds.length ? `WHERE ${conds.join(' AND ')}` : '';
  const result = await pool.query(`
    SELECT gm.id, gm.group_id, g.name AS group_name, gm.sender_id, gm.sender_name,
           gm.sender_full_name, gm.sender_nickname, gm.content, gm.message_type,
           gm.file_name, gm.voice_duration, gm.call_type, gm.quoted_message_content,
           gm.status, gm.created_at
    FROM synced_group_messages gm
    LEFT JOIN groups g ON g.id = gm.group_id
    ${where}
    ORDER BY gm.created_at DESC, gm.id DESC
    LIMIT $${params.length + 1} OFFSET $${params.length + 2}
  `, [...params, limit, offset]);

  const countResult = await pool.query(`
    SELECT COUNT(*) FROM synced_group_messages gm LEFT JOIN groups g ON g.id = gm.group_id ${where}
  `, params);
  const total = parseInt(countResult.rows[0].count);
  res.json({ data: result.rows, total, page, limit, totalPages: Math.ceil(total / limit) });
});

// 获取所有会话列表
router.get('/conversations', async (req: AuthRequest, res: Response) => {
  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 20;
  const offset = (page - 1) * limit;
  
  const chatType = req.query.chat_type as string;
  const senderId = req.query.sender_id as string;
  const receiverId = req.query.receiver_id as string;
  const groupId = req.query.group_id as string;
  const startDate = req.query.start_date as string;
  const endDate = req.query.end_date as string;

  if (chatType === 'group') {
    let whereClause = "WHERE gm.status = 'normal'";
    const params: any[] = [];
    let paramIndex = 1;

    if (senderId) {
      whereClause += ` AND gm.sender_id = $${paramIndex}`;
      params.push(parseInt(senderId));
      paramIndex++;
    }
    if (groupId) {
      whereClause += ` AND gm.group_id = $${paramIndex}`;
      params.push(parseInt(groupId));
      paramIndex++;
    }
    if (startDate) {
      whereClause += ` AND gm.created_at >= $${paramIndex}`;
      params.push(startDate.replace('T', ' '));
      paramIndex++;
    }
    if (endDate) {
      whereClause += ` AND gm.created_at <= $${paramIndex}`;
      params.push(endDate.replace('T', ' '));
      paramIndex++;
    }

    const result = await pool.query(`
      WITH conversations AS (
        SELECT DISTINCT ON (gm.group_id)
          gm.id, gm.group_id, gm.sender_id, gm.sender_name, g.name as group_name, 
          gm.content, gm.message_type, gm.created_at, 'group' as chat_type
        FROM group_messages gm
        JOIN groups g ON g.id = gm.group_id
        ${whereClause}
        ORDER BY gm.group_id, gm.created_at DESC
      )
      SELECT * FROM conversations ORDER BY created_at DESC LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `, [...params, limit, offset]);

    const countResult = await pool.query(`
      SELECT COUNT(DISTINCT gm.group_id) as count
      FROM group_messages gm
      JOIN groups g ON g.id = gm.group_id
      ${whereClause}
    `, params);

    const total = parseInt(countResult.rows[0].count);
    res.json({ data: result.rows, total, page, limit, totalPages: Math.ceil(total / limit) });
  } else if (chatType === 'private') {
    let whereClause = "WHERE status = 'normal'";
    const params: any[] = [];
    let paramIndex = 1;

    if (senderId) {
      whereClause += ` AND sender_id = $${paramIndex}`;
      params.push(parseInt(senderId));
      paramIndex++;
    }
    if (receiverId) {
      whereClause += ` AND receiver_id = $${paramIndex}`;
      params.push(parseInt(receiverId));
      paramIndex++;
    }
    if (startDate) {
      whereClause += ` AND created_at >= $${paramIndex}`;
      params.push(startDate.replace('T', ' '));
      paramIndex++;
    }
    if (endDate) {
      whereClause += ` AND created_at <= $${paramIndex}`;
      params.push(endDate.replace('T', ' '));
      paramIndex++;
    }

    const result = await pool.query(`
      WITH conversations AS (
        SELECT DISTINCT ON (LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id))
          id, sender_id, receiver_id, sender_name, receiver_name, content, message_type, created_at, 'private' as chat_type
        FROM messages
        ${whereClause}
        ORDER BY LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id), created_at DESC
      )
      SELECT * FROM conversations ORDER BY created_at DESC LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `, [...params, limit, offset]);

    const countResult = await pool.query(`
      SELECT COUNT(DISTINCT (LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id))) as count
      FROM messages ${whereClause}
    `, params);

    const total = parseInt(countResult.rows[0].count);
    res.json({ data: result.rows, total, page, limit, totalPages: Math.ceil(total / limit) });
  } else {
    let privateWhere = "WHERE status = 'normal'";
    let groupWhere = "WHERE gm.status = 'normal'";
    const privateParams: any[] = [];
    const groupParams: any[] = [];
    let privateParamIndex = 1;
    let groupParamIndex = 1;

    if (senderId) {
      privateWhere += ` AND sender_id = $${privateParamIndex}`;
      privateParams.push(parseInt(senderId));
      privateParamIndex++;
      groupWhere += ` AND gm.sender_id = $${groupParamIndex}`;
      groupParams.push(parseInt(senderId));
      groupParamIndex++;
    }
    if (receiverId) {
      privateWhere += ` AND receiver_id = $${privateParamIndex}`;
      privateParams.push(parseInt(receiverId));
      privateParamIndex++;
    }
    if (startDate) {
      privateWhere += ` AND created_at >= $${privateParamIndex}`;
      privateParams.push(startDate.replace('T', ' '));
      privateParamIndex++;
      groupWhere += ` AND gm.created_at >= $${groupParamIndex}`;
      groupParams.push(startDate.replace('T', ' '));
      groupParamIndex++;
    }
    if (endDate) {
      privateWhere += ` AND created_at <= $${privateParamIndex}`;
      privateParams.push(endDate.replace('T', ' '));
      privateParamIndex++;
      groupWhere += ` AND gm.created_at <= $${groupParamIndex}`;
      groupParams.push(endDate.replace('T', ' '));
      groupParamIndex++;
    }

    const privateResult = await pool.query(`
      WITH conversations AS (
        SELECT DISTINCT ON (LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id))
          id, sender_id, receiver_id, sender_name, receiver_name, content, message_type, created_at, 'private' as chat_type, NULL::integer as group_id, NULL as group_name
        FROM messages
        ${privateWhere}
        ORDER BY LEAST(sender_id, receiver_id), GREATEST(sender_id, receiver_id), created_at DESC
      )
      SELECT * FROM conversations
    `, privateParams);

    const groupResult = await pool.query(`
      WITH conversations AS (
        SELECT DISTINCT ON (gm.group_id)
          gm.id, gm.sender_id, NULL::integer as receiver_id, gm.sender_name, NULL as receiver_name, 
          gm.content, gm.message_type, gm.created_at, 'group' as chat_type, gm.group_id, g.name as group_name
        FROM group_messages gm
        JOIN groups g ON g.id = gm.group_id
        ${groupWhere}
        ORDER BY gm.group_id, gm.created_at DESC
      )
      SELECT * FROM conversations
    `, groupParams);

    const allConversations = [...privateResult.rows, ...groupResult.rows]
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
    
    const total = allConversations.length;
    const paginatedData = allConversations.slice(offset, offset + limit);

    res.json({ data: paginatedData, total, page, limit, totalPages: Math.ceil(total / limit) });
  }
});


// 获取两个用户之间的聊天记录
router.get('/chat/:user1/:user2', async (req: AuthRequest, res: Response) => {
  const { user1, user2 } = req.params;
  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 50;
  const offset = (page - 1) * limit;

  const result = await pool.query(`
    SELECT id, sender_id, receiver_id, sender_name, receiver_name, sender_avatar, receiver_avatar,
           content, message_type, file_name, quoted_message_id, quoted_message_content, 
           call_type, voice_duration, status, is_read, created_at
    FROM messages
    WHERE ((sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1))
    ORDER BY created_at DESC LIMIT $3 OFFSET $4
  `, [user1, user2, limit, offset]);

  const countResult = await pool.query(`
    SELECT COUNT(*) FROM messages
    WHERE ((sender_id = $1 AND receiver_id = $2) OR (sender_id = $2 AND receiver_id = $1))
  `, [user1, user2]);

  const total = parseInt(countResult.rows[0].count);
  res.json({ data: result.rows.reverse(), total, page, limit, totalPages: Math.ceil(total / limit) });
});

// 获取群组聊天记录
router.get('/group/:groupId', async (req: AuthRequest, res: Response) => {
  const { groupId } = req.params;
  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 50;
  const offset = (page - 1) * limit;

  const result = await pool.query(`
    SELECT id, group_id, sender_id, sender_name, sender_avatar,
           content, message_type, file_name, quoted_message_id, quoted_message_content, 
           voice_duration, status, created_at
    FROM group_messages
    WHERE group_id = $1
    ORDER BY created_at DESC LIMIT $2 OFFSET $3
  `, [groupId, limit, offset]);

  const countResult = await pool.query(`
    SELECT COUNT(*) FROM group_messages WHERE group_id = $1
  `, [groupId]);

  const total = parseInt(countResult.rows[0].count);
  res.json({ data: result.rows.reverse(), total, page, limit, totalPages: Math.ceil(total / limit) });
});

// 搜索消息
router.get('/search', async (req: AuthRequest, res: Response) => {
  const keyword = req.query.keyword as string || '';
  const userId = req.query.user_id as string;
  const page = parseInt(req.query.page as string) || 1;
  const limit = parseInt(req.query.limit as string) || 20;
  const offset = (page - 1) * limit;

  let whereClause = "WHERE status = 'normal'";
  const params: any[] = [];
  let paramIndex = 1;

  if (keyword) {
    whereClause += ` AND content ILIKE $${paramIndex}`;
    params.push(`%${keyword}%`);
    paramIndex++;
  }

  if (userId) {
    whereClause += ` AND (sender_id = $${paramIndex} OR receiver_id = $${paramIndex})`;
    params.push(userId);
    paramIndex++;
  }

  params.push(limit, offset);
  const result = await pool.query(`
    SELECT id, sender_id, receiver_id, sender_name, receiver_name, content, message_type, created_at
    FROM messages ${whereClause}
    ORDER BY created_at DESC LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
  `, params);

  const countParams = params.slice(0, -2);
  const countResult = await pool.query(`SELECT COUNT(*) FROM messages ${whereClause}`, countParams);
  const total = parseInt(countResult.rows[0].count);

  res.json({ data: result.rows, total, page, limit, totalPages: Math.ceil(total / limit) });
});

export default router;
