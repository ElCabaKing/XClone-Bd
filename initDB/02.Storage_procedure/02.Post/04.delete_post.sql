CREATE PROCEDURE DeletePost
    @PostId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el post existe
    IF NOT EXISTS (SELECT 1 FROM post WHERE id = @PostId)
    BEGIN
        SELECT 0 AS Success, 'Post not found' AS Message
        RETURN;
    END

    -- Validar que el usuario es el propietario del post
    IF NOT EXISTS (SELECT 1 FROM post WHERE id = @PostId AND user_id = @UserId)
    BEGIN
        SELECT 0 AS Success, 'You are not the owner of this post' AS Message
        RETURN;
    END

    BEGIN TRY
        DELETE FROM post WHERE id = @PostId;

        SELECT 1 AS Success, 'Post deleted successfully' AS Message

    END TRY
    BEGIN CATCH
        SELECT 0 AS Success, ERROR_MESSAGE() AS Message
    END CATCH

END
GO
