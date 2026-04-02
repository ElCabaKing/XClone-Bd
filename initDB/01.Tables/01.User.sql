CREATE TABLE user_status (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);

INSERT INTO user_status (id, name, description) VALUES
(1, 'active', 'User is active and can interact with the platform'),
(2, 'inactive', 'User is inactive (cannot interact)');


CREATE TABLE [user] (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    username NVARCHAR(255) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    is_verified BIT NOT NULL DEFAULT 0,
    status_id TINYINT NOT NULL DEFAULT 1,
    first_name NVARCHAR(255) NOT NULL,
    last_name NVARCHAR(255) NOT NULL,
    profile_picture_url NVARCHAR(255) NULL,
    CONSTRAINT FK_User_Status FOREIGN KEY (status_id) REFERENCES user_status(id)
);