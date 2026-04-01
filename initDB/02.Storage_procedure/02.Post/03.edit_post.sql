CREATE PROCEDURE EditPost
    @PostId INT,
    @UserId INT,
    @Content NVARCHAR(MAX) = NULL,
    @MediaUrl NVARCHAR(255) = NULL,
    @MediaType NVARCHAR(50) = NULL,
    @IsSensitive BIT = NULL
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

    -- Validar que el usuario está activo
    DECLARE @UserIsActive BIT;
    SELECT @UserIsActive = is_active FROM [user] WHERE id = @UserId;
    
    IF @UserIsActive = 0
    BEGIN
        SELECT 0 AS Success, 'User is not active' AS Message
        RETURN;
    END

    BEGIN TRANSACTION;

    BEGIN TRY
        UPDATE post
        SET 
            content = COALESCE(@Content, content),
            media_url = COALESCE(@MediaUrl, media_url),
            media_type = COALESCE(@MediaType, media_type),
            is_sensitive = COALESCE(@IsSensitive, is_sensitive)
        WHERE id = @PostId;

        COMMIT TRANSACTION;

        SELECT 1 AS Success, 'Post updated successfully' AS Message

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SELECT 0 AS Success, ERROR_MESSAGE() AS Message
    END CATCH

END
GO
