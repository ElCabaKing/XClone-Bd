CREATE TABLE chat_participants (
    chat_id INT,
    user_id INT,
    PRIMARY KEY (chat_id, user_id),

    FOREIGN KEY (chat_id) REFERENCES chat_room(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES [user](id) ON DELETE CASCADE
);