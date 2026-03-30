CREATE PROCEDURE GetUser
    @UserId INT
AS
BEGIN   
    SET NOCOUNT ON; 
    SELECT 
        id,
        username,
        email,
        password_hash,
        first_name,
        last_name,
        profile_picture_url,
        is_verified,
        is_active,
        created_at
    FROM [user]
    WHERE id = @UserId;
END
GO  