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
    role_id TINYINT NOT NULL DEFAULT 2,
    status_id TINYINT NOT NULL DEFAULT 1,
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

-- token
CREATE TABLE [token] (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    refresh_token NVARCHAR(255) NOT NULL UNIQUE,
    expires_at DATETIME2 NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Token_User FOREIGN KEY (user_id) REFERENCES [user](id)
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
('Welcome Email', 'Welcome to Our Service!', 'Dear {{first_name}},\n\nThank you for signing up for our service. We are excited to have you on board!\n\nBest regards,\nThe Team'),
('Password Reset', 'Password Reset Request', 'Dear {{first_name}},\n\nWe received a request to reset your password. Please click the link below to reset your password:\n\n{{reset_link}}\n\nIf you did not request a password reset, please ignore this email.\n\nBest regards,\nThe Team');
GO
