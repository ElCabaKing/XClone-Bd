CREATE TABLE [user] (
    id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(255) NOT NULL UNIQUE,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password_hash NVARCHAR(255) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    is_verified BIT DEFAULT 0,
    is_active BIT DEFAULT 1,
    first_name NVARCHAR(255) NULL,
    last_name NVARCHAR(255) NULL,
    profile_picture_url NVARCHAR(255) NULL
);