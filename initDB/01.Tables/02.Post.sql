CREATE TABLE post (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    media_url NVARCHAR(255) NULL,
    media_type NVARCHAR(50) NULL,
    is_sensitive BIT DEFAULT 0,
    is_outstanding BIT DEFAULT 0,
    reply_to INT NULL,
    repost_of INT NULL,

    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,

    FOREIGN KEY (reply_to) 
        REFERENCES post(id) 
        ON DELETE NO ACTION,

    FOREIGN KEY (repost_of) 
        REFERENCES post(id) 
        ON DELETE NO ACTION
);