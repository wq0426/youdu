-- 联系人单向可见:A 添加 B 后,只有 A 的联系人列表出现 B;
-- B 的列表不出现 A,除非 B 也添加了 A(回加)。
--
-- friend_added = 被加方(friend_id 一方)是否也把发起方(user_id 一方)加为联系人。
-- 联系人列表查询规则:
--   我发起的关系(user_id = 我):approved 即可见;
--   对方发起的关系(friend_id = 我):还需 friend_added = true 才对我可见。
--
-- 服务启动时由 db.go 轻量自迁移自动执行(以列不存在为一次性执行的判断条件),
-- 本文件仅作留档/手工执行备用。
--
-- ⚠️ 存量关系一次性置 true:历史数据是双向可见语义,老用户的联系人不能凭空消失。
-- 该 UPDATE 只能跟随加列执行一次,重复执行会把之后新产生的单向关系错误升级为双向。

ALTER TABLE user_relations ADD COLUMN IF NOT EXISTS friend_added BOOLEAN NOT NULL DEFAULT false;
UPDATE user_relations SET friend_added = true;
