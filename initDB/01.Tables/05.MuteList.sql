CREATE TABLE mute_list (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    muted_by INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    UNIQUE (user_id, muted_by),
    CONSTRAINT ck_mute_different_users CHECK (user_id != muted_by),
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE,
    FOREIGN KEY (muted_by) REFERENCES [user](id) ON DELETE NO ACTION
);