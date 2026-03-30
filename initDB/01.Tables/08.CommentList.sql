CREATE TABLE comment_list (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    media_url NVARCHAR(MAX),
    media_type NVARCHAR(50),
    comment_to INT,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE NO ACTION,
    FOREIGN KEY (comment_to) REFERENCES comment_list(id) ON DELETE NO ACTION
);