-- 添加联系人不再需要对方审核（2026-07）：
-- 1. 新增关系一律直接写入 approved（见 contact_controller.go directAddContact）；
-- 2. 存量的 pending 申请全部直接转为 approved，客户端不再展示"待审核/通过/拒绝"。
-- 该语句已由 db.go 启动自迁移自动执行，此文件仅作记录/手动执行备份。

UPDATE user_relations
SET approval_status = 'approved'
WHERE approval_status = 'pending';
