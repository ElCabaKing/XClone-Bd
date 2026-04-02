CREATE TABLE follow_list (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NewID(),
    follower_id UNIQUEIDENTIFIER NOT NULL,
    following_id UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (follower_id, following_id),
    CONSTRAINT ck_follow_different_users CHECK (follower_id != following_id),
    FOREIGN KEY (follower_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES [user](id) ON DELETE NO ACTION
);