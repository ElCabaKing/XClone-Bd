CREATE TABLE user_status (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);

CREATE TABLE user_role (
    id TINYINT PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(255) NULL
);

INSERT INTO user_status (id, name, description) VALUES
(1, 'active', 'User is active and can interact with the platform'),
(2, 'inactive', 'User is inactive (cannot interact)');

INSERT INTO user_role (id, name, description) VALUES
(1, 'admin', 'User has administrative privileges'),
(2, 'common_user', 'User has standard privileges'),
(3, 'verified_user', 'User has verified their identity');


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