import './env'; // 必须第一个导入

import express from 'express';
import cors from 'cors';
import { initDatabase } from './config/database';
import authRoutes from './routes/auth';
import userRoutes from './routes/users';
import messageRoutes from './routes/messages';
import inviteCodeRoutes from './routes/inviteCodes';
import adminRoutes from './routes/admins';

const app = express();
const PORT = process.env.PORT || 3001;
// 🔒 默认只监听本机回环：管理后台不直接暴露公网，
// 外部访问应经 Nginx 反代（或 SSH 隧道）。需要监听所有网卡时在 .env 设 HOST=0.0.0.0
const HOST = process.env.HOST || '127.0.0.1';

app.use(cors());
app.use(express.json());

// 路由（同时支持 /api 和 /admin/api）
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/invite-codes', inviteCodeRoutes);
app.use('/api/admins', adminRoutes);
app.use('/admin/api/auth', authRoutes);
app.use('/admin/api/users', userRoutes);
app.use('/admin/api/messages', messageRoutes);
app.use('/admin/api/invite-codes', inviteCodeRoutes);
app.use('/admin/api/admins', adminRoutes);

// 静态文件（前端）
app.use('/admin', express.static('public'));
app.use(express.static('public'));

// 错误处理
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err);
  res.status(500).json({ error: '服务器内部错误' });
});

const start = async () => {
  await initDatabase();
  app.listen(Number(PORT), HOST, () => {
    console.log(`Admin server running on http://${HOST}:${PORT}`);
  });
};

start();
