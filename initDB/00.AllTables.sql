-- user_status y user_role
CREATE TABLE user_status (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

CREATE TABLE user_role (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);
GO

INSERT INTO user_status (id, name, description) VALUES
(1, 'active', 'User is active and can interact with the platform'),
(2, 'inactive', 'User is inactive (cannot interact)');
GO

INSERT INTO user_role (id, name, description) VALUES
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
    role_id TINYINT NULL DEFAULT 2,
    status_id TINYINT NULL DEFAULT 1,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    profile_picture_url NVARCHAR(255) NULL,
    CONSTRAINT FK_User_Role FOREIGN KEY (role_id) REFERENCES user_role(id),
    CONSTRAINT FK_User_Status FOREIGN KEY (status_id) REFERENCES user_status(id)
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
('Password Reset', 'Password Reset Request', '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #f5f5f5; padding: 20px; border-radius: 8px;"><div style="background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"><p style="color: #333333; font-size: 16px; margin-bottom: 20px;">Dear {{first_name}},</p><p style="color: #555555; font-size: 14px; line-height: 1.6; margin-bottom: 20px;">We received a request to reset your password. Please click the link below to reset your password:</p><div style="margin: 30px 0; text-align: center;"><a href="{{reset_link}}" style="background-color: #1a73e8; color: #ffffff; padding: 12px 30px; text-decoration: none; border-radius: 4px; display: inline-block; font-weight: bold;">Reset Password</a></div><p style="color: #999999; font-size: 12px; margin-top: 30px;">If you did not request a password reset, please ignore this email.</p><p style="color: #333333; font-size: 14px; margin-top: 30px; margin-bottom: 10px;">Best regards,</p><p style="color: #1a73e8; font-weight: bold; font-size: 14px;">The Team</p></div></div>');
GO

-- User Table Indexes
CREATE INDEX idx_user_role_id ON [user](role_id);
CREATE INDEX idx_user_status_id ON [user](status_id);
CREATE INDEX idx_user_created_at ON [user](created_at);

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

