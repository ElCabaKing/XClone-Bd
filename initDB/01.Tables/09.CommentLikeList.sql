CREATE TABLE comment_like_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    comment_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, comment_id),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE NO ACTION,
    FOREIGN KEY (comment_id) REFERENCES comment_list(id) ON DELETE CASCADE
);