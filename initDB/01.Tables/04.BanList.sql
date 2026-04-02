CREATE TABLE ban_list (
    id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
    user_id UNIQUEIDENTIFIER NOT NULL,
    banned_by UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, banned_by),
    CONSTRAINT ck_ban_different_users CHECK (user_id != banned_by),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (banned_by) REFERENCES [user](id) ON DELETE NO ACTION
);