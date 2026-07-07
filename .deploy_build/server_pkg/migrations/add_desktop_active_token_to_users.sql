-- Add desktop_active_token field for QR-code login on PC client
-- Mobile keeps active_token; PC gets its own desktop_active_token so that
-- phone and PC can stay logged in at the same time (WeChat-style QR login)

ALTER TABLE users ADD COLUMN IF NOT EXISTS desktop_active_token TEXT;

-- Record desktop token update time
ALTER TABLE users ADD COLUMN IF NOT EXISTS desktop_token_updated_at TIMESTAMP WITH TIME ZONE;

COMMENT ON COLUMN users.desktop_active_token IS 'Current valid login token of the desktop (PC) client, issued via QR-code login';
COMMENT ON COLUMN users.desktop_token_updated_at IS 'Desktop token update timestamp';
