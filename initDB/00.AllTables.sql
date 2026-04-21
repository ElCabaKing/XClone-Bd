-- user_status y role
CREATE TABLE user_status (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

CREATE TABLE role (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

INSERT INTO user_status (id, name, description) VALUES
(1, 'active', 'User is active and can interact with the platform'),
(2, 'inactive', 'User is inactive (cannot interact)');
GO

INSERT INTO role (id, name, description) VALUES
(1, 'admin', 'User has administrative privileges'),
(2, 'common_user', 'User has standard privileges'),
(3, 'verified_user', 'User has verified their identity');
GO

-- user
CREATE TABLE [user] (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    username NVARCHAR(255) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    status_id TINYINT NULL DEFAULT 1,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    profile_picture_url NVARCHAR(255) NULL,
    CONSTRAINT FK_User_Status FOREIGN KEY (status_id) REFERENCES user_status(id)
);
GO

CREATE TABLE role_user (
    user_id UNIQUEIDENTIFIER NOT NULL,
    role_id TINYINT NOT NULL,
    PRIMARY KEY (user_id, role_id),
    CONSTRAINT FK_Role_User_User FOREIGN KEY (user_id) REFERENCES [user](id),
    CONSTRAINT FK_Role_User_Role FOREIGN KEY (role_id) REFERENCES role(id)
);
GO

-- post
CREATE TABLE post (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    media_url NVARCHAR(255) NULL,
    media_type NVARCHAR(50) NULL,
    is_sensitive BIT DEFAULT 0,
    is_outstanding BIT DEFAULT 0,
    reply_to UNIQUEIDENTIFIER NULL,
    repost_of UNIQUEIDENTIFIER NULL,
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (reply_to) REFERENCES post(id) ON DELETE NO ACTION,
    FOREIGN KEY (repost_of) REFERENCES post(id) ON DELETE NO ACTION
);
GO

-- survey
CREATE TABLE survey (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    question NVARCHAR(MAX) NOT NULL,
    options NVARCHAR(MAX) NOT NULL,
    post_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE,
    CONSTRAINT check_json_options CHECK (ISJSON(options) = 1)
);
GO

-- ban_list
CREATE TABLE ban_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    banned_by UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, banned_by),
    CONSTRAINT ck_ban_different_users CHECK (user_id != banned_by),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (banned_by) REFERENCES [user](id) ON DELETE NO ACTION
);
GO

-- mute_list
CREATE TABLE mute_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    muted_by UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, muted_by),
    CONSTRAINT ck_mute_different_users CHECK (user_id != muted_by),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (muted_by) REFERENCES [user](id) ON DELETE NO ACTION
);
GO

-- follow_list
CREATE TABLE follow_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    follower_id UNIQUEIDENTIFIER NOT NULL,
    following_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (follower_id, following_id),
    CONSTRAINT ck_follow_different_users CHECK (follower_id != following_id),
    FOREIGN KEY (follower_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES [user](id) ON DELETE NO ACTION
);
GO

-- like_list
CREATE TABLE like_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    post_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE NO ACTION
);
GO

-- comment_list
CREATE TABLE comment_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    post_id UNIQUEIDENTIFIER NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    media_url NVARCHAR(MAX),
    media_type NVARCHAR(50),
    comment_to UNIQUEIDENTIFIER NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE NO ACTION,
    FOREIGN KEY (comment_to) REFERENCES comment_list(id) ON DELETE NO ACTION
);
GO

-- comment_like_list
CREATE TABLE comment_like_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    comment_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, comment_id),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE NO ACTION,
    FOREIGN KEY (comment_id) REFERENCES comment_list(id) ON DELETE CASCADE
);
GO

-- hashtags
CREATE TABLE hashtags (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    name NVARCHAR(255) NOT NULL UNIQUE,
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- hashtag_post
CREATE TABLE hashtag_post (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    hashtag_id UNIQUEIDENTIFIER NOT NULL,
    post_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (hashtag_id, post_id),
    FOREIGN KEY (hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE
);
GO

-- chat_room
CREATE TABLE chat_room (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    created_at DATETIME2 DEFAULT GETDATE()
);
GO

-- chat_participants
CREATE TABLE chat_participants (
    chat_id UNIQUEIDENTIFIER,
    user_id UNIQUEIDENTIFIER,
    PRIMARY KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES chat_room(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE
);
GO

-- messages
CREATE TABLE messages (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    chat_room_id UNIQUEIDENTIFIER NOT NULL,
    sender_id UNIQUEIDENTIFIER NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    is_read BIT DEFAULT 0,
    FOREIGN KEY (chat_room_id) REFERENCES chat_room(id) ON DELETE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES [user](id) ON DELETE CASCADE
);
GO

-- notifications
CREATE TABLE notifications (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    type NVARCHAR(50) NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    is_read BIT DEFAULT 0,
    path NVARCHAR(255) NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE
);
GO

-- email_templates
CREATE TABLE [email_templates] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [subject] NVARCHAR(255) NOT NULL,
    [body] NVARCHAR(MAX) NOT NULL,
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
    [updated_at] DATETIME NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO [email_templates] ([name], [subject], [body]) VALUES
('Welcome Email', 'Welcome to Our Service!', '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #f5f5f5; padding: 20px; border-radius: 8px;"><div style="background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"><p style="color: #333333; font-size: 16px; margin-bottom: 20px;">Dear {{first_name}},</p><p style="color: #555555; font-size: 14px; line-height: 1.6; margin-bottom: 20px;">Thank you for signing up for our service. We are excited to have you on board!</p><p style="color: #333333; font-size: 14px; margin-top: 30px; margin-bottom: 10px;">Best regards,</p><p style="color: #1a73e8; font-weight: bold; font-size: 14px;">The Team</p></div></div>'),
('Password Reset', 'Password Reset Request', '<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="margin:0;padding:0;background-color:#eef2f7;"><tr><td align="center" style="padding:32px 16px;"><table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="max-width:620px;background:#ffffff;border:1px solid #d9e2ec;border-radius:14px;overflow:hidden;"><tr><td style="background:linear-gradient(135deg,#0b5bd3 0%,#0f8a9d 100%);padding:28px 32px;"><p style="margin:0;color:#ffffff;font-size:13px;letter-spacing:0.4px;font-weight:700;text-transform:uppercase;">Security Notice</p><h1 style="margin:8px 0 0 0;color:#ffffff;font-size:24px;line-height:1.3;font-family:Segoe UI,Arial,sans-serif;">Password reset requested</h1></td></tr><tr><td style="padding:30px 32px 12px 32px;font-family:Segoe UI,Arial,sans-serif;color:#243b53;"><p style="margin:0 0 16px 0;font-size:16px;line-height:1.6;">Hello {{first_name}},</p><p style="margin:0 0 18px 0;font-size:15px;line-height:1.7;color:#486581;">We received a request to reset your password. Use the button below to choose a new password. For your security, this link should expire soon.</p><table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:8px 0 20px 0;"><tr><td align="center" style="border-radius:8px;background-color:#0b5bd3;"><a href="{{reset_link}}" style="display:inline-block;padding:14px 28px;font-family:Segoe UI,Arial,sans-serif;font-size:15px;font-weight:700;color:#ffffff;text-decoration:none;border-radius:8px;">Reset Password</a></td></tr></table><p style="margin:0 0 14px 0;font-size:13px;line-height:1.7;color:#627d98;">If the button does not work, copy and paste this URL into your browser:</p><p style="margin:0 0 20px 0;font-size:12px;line-height:1.6;word-break:break-all;"><a href="{{reset_link}}" style="color:#0b5bd3;text-decoration:underline;">{{reset_link}}</a></p><div style="background:#f0f4f8;border-radius:10px;padding:14px 16px;margin:0 0 20px 0;"><p style="margin:0;font-size:12px;line-height:1.7;color:#334e68;">If you did not request a password reset, you can safely ignore this email. Your current password will remain unchanged.</p></div><p style="margin:0 0 4px 0;font-size:14px;color:#243b53;">Regards,</p><p style="margin:0;font-size:14px;font-weight:700;color:#102a43;">XClone Team</p></td></tr><tr><td style="padding:16px 32px 26px 32px;border-top:1px solid #e6edf3;font-family:Segoe UI,Arial,sans-serif;"><p style="margin:0;font-size:11px;line-height:1.6;color:#829ab1;">This is an automated security message. Please do not reply directly to this email.</p></td></tr></table></td></tr></table>');
GO

-- User Table Indexes
CREATE INDEX idx_user_status_id ON [user](status_id);
CREATE INDEX idx_user_created_at ON [user](created_at);

-- Role User Table Indexes
CREATE INDEX idx_role_user_role_id ON role_user(role_id);

-- Post Table Indexes
CREATE INDEX idx_post_user_id ON post(user_id);
CREATE INDEX idx_post_created_at ON post(created_at DESC);
CREATE INDEX idx_post_reply_to ON post(reply_to);
CREATE INDEX idx_post_repost_of ON post(repost_of);
CREATE INDEX idx_post_user_created ON post(user_id, created_at DESC);

-- Survey Table Indexes
CREATE INDEX idx_survey_post_id ON survey(post_id);

-- Ban List Indexes
CREATE INDEX idx_ban_list_user_id ON ban_list(user_id);
CREATE INDEX idx_ban_list_banned_by ON ban_list(banned_by);

-- Mute List Indexes
CREATE INDEX idx_mute_list_user_id ON mute_list(user_id);
CREATE INDEX idx_mute_list_muted_by ON mute_list(muted_by);

-- Follow List Indexes
CREATE INDEX idx_follow_list_follower_id ON follow_list(follower_id);
CREATE INDEX idx_follow_list_following_id ON follow_list(following_id);

-- Like List Indexes
CREATE INDEX idx_like_list_user_id ON like_list(user_id);
CREATE INDEX idx_like_list_post_id ON like_list(post_id);

-- Comment List Indexes
CREATE INDEX idx_comment_list_user_id ON comment_list(user_id);
CREATE INDEX idx_comment_list_post_id ON comment_list(post_id);
CREATE INDEX idx_comment_list_comment_to ON comment_list(comment_to);
CREATE INDEX idx_comment_list_post_user ON comment_list(post_id, user_id);

-- Comment Like List Indexes
CREATE INDEX idx_comment_like_list_user_id ON comment_like_list(user_id);
CREATE INDEX idx_comment_like_list_comment_id ON comment_like_list(comment_id);

-- Hashtags Indexes
CREATE INDEX idx_hashtags_name ON hashtags(name);

-- Hashtag Post Indexes
CREATE INDEX idx_hashtag_post_hashtag_id ON hashtag_post(hashtag_id);
CREATE INDEX idx_hashtag_post_post_id ON hashtag_post(post_id);

-- Chat Participants Indexes
CREATE INDEX idx_chat_participants_user_id ON chat_participants(user_id);

-- Messages Indexes
CREATE INDEX idx_messages_chat_room_id ON messages(chat_room_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_is_read ON messages(is_read);
CREATE INDEX idx_messages_chat_created ON messages(chat_room_id, created_at DESC);

-- Notifications Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

