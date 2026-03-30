CREATE TABLE hashtag_post (
    id INT PRIMARY KEY IDENTITY(1,1),
    hashtag_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (hashtag_id, post_id),
    FOREIGN KEY (hashtag_id) REFERENCES hashtags(id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE
);