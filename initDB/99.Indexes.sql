-- User Table Indexes
CREATE INDEX idx_user_role_id ON [user](role_id);
CREATE INDEX idx_user_status_id ON [user](status_id);
CREATE INDEX idx_user_created_at ON [user](created_at);

-- Post Table Indexes
CREATE INDEX idx_post_user_id ON post(user_id);
CREATE INDEX idx_post_created_at ON post(created_at DESC);
CREATE INDEX idx_post_reply_to ON post(reply_to);
CREATE INDEX idx_post_repost_of ON post(repost_of);
CREATE INDEX idx_post_user_created ON post(user_id, created_at DESC);

-- Survey Table Indexes
CREATE INDEX idx_survey_post_id ON survey(post_id);

-- Ban List Indexes
CREATE INDEX idx_ban_list_user_id ON ban_list(user_id);
CREATE INDEX idx_ban_list_banned_by ON ban_list(banned_by);

-- Mute List Indexes
CREATE INDEX idx_mute_list_user_id ON mute_list(user_id);
CREATE INDEX idx_mute_list_muted_by ON mute_list(muted_by);

-- Follow List Indexes
CREATE INDEX idx_follow_list_follower_id ON follow_list(follower_id);
CREATE INDEX idx_follow_list_following_id ON follow_list(following_id);

-- Like List Indexes
CREATE INDEX idx_like_list_user_id ON like_list(user_id);
CREATE INDEX idx_like_list_post_id ON like_list(post_id);

-- Comment List Indexes
CREATE INDEX idx_comment_list_user_id ON comment_list(user_id);
CREATE INDEX idx_comment_list_post_id ON comment_list(post_id);
CREATE INDEX idx_comment_list_comment_to ON comment_list(comment_to);
CREATE INDEX idx_comment_list_post_user ON comment_list(post_id, user_id);

-- Comment Like List Indexes
CREATE INDEX idx_comment_like_list_user_id ON comment_like_list(user_id);
CREATE INDEX idx_comment_like_list_comment_id ON comment_like_list(comment_id);

-- Hashtags Indexes
CREATE INDEX idx_hashtags_name ON hashtags(name);

-- Hashtag Post Indexes
CREATE INDEX idx_hashtag_post_hashtag_id ON hashtag_post(hashtag_id);
CREATE INDEX idx_hashtag_post_post_id ON hashtag_post(post_id);

-- Chat Participants Indexes
CREATE INDEX idx_chat_participants_user_id ON chat_participants(user_id);

-- Messages Indexes
CREATE INDEX idx_messages_chat_room_id ON messages(chat_room_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_is_read ON messages(is_read);
CREATE INDEX idx_messages_chat_created ON messages(chat_room_id, created_at DESC);

-- Notifications Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- Token Indexes
CREATE INDEX idx_token_user_id ON [token](user_id);
