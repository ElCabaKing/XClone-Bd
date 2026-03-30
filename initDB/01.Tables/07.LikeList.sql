CREATE TABLE like_list (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE NO ACTION
);