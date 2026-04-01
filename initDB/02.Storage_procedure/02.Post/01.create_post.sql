CREATE PROCEDURE CreatePost
    @UserId INT,
    @Content NVARCHAR(MAX),
    @MediaUrl NVARCHAR(255) = NULL,
    @MediaType NVARCHAR(50) = NULL,
    @IsSensitive BIT = 0,
    @ReplyTo INT = NULL,
    @RepostOf INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Validar que el usuario existe y está activo
    IF NOT EXISTS (SELECT 1 FROM [user] WHERE id = @UserId)
    BEGIN
        SELECT 0 AS Success, 'User not found' AS Message
        RETURN;
    END

    DECLARE @UserIsActive BIT;
    SELECT @UserIsActive = is_active FROM [user] WHERE id = @UserId;
    
    IF @UserIsActive = 0
    BEGIN
        SELECT 0 AS Success, 'User is not active' AS Message
        RETURN;
    END

    -- Validar que el contenido no es nulo o vacío
    IF @Content IS NULL OR @Content = ''
    BEGIN
        SELECT 0 AS Success, 'Content cannot be empty' AS Message
        RETURN;
    END

    BEGIN TRY
        INSERT INTO post (user_id, content, media_url, media_type, is_sensitive, reply_to, repost_of)
        VALUES (@UserId, @Content, @MediaUrl, @MediaType, @IsSensitive, @ReplyTo, @RepostOf);

        DECLARE @NewPostId INT = SCOPE_IDENTITY();

        SELECT 1 AS Success, 'Post created successfully' AS Message, @NewPostId AS PostId

    END TRY
    BEGIN CATCH
        SELECT 0 AS Success, ERROR_MESSAGE() AS Message
    END CATCH
END
GO
