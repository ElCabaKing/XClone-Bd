CREATE PROCEDURE GetPost
    @PostId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM post WHERE id = @PostId)
    BEGIN
        SELECT 0 AS Success, 'Post not found' AS Message
        RETURN;
    END

    SELECT 
        id,
        user_id,
        content,
        created_at,
        media_url,
        media_type,
        is_sensitive,
        is_outstanding,
        reply_to,
        repost_of
    FROM post
    WHERE id = @PostId

END
GO
