CREATE TABLE mute_list (
    id UNIQUEIDENTIFIER PRIMARY KEY,
    user_id UNIQUEIDENTIFIER NOT NULL,
    muted_by UNIQUEIDENTIFIER NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, muted_by),
    CONSTRAINT ck_mute_different_users CHECK (user_id != muted_by),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (muted_by) REFERENCES [user](id) ON DELETE NO ACTION
);