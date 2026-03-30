CREATE OR ALTER PROCEDURE EditUser
    @UserId INT,
    @Email NVARCHAR(255) = NULL,
    @PasswordHash NVARCHAR(255) = NULL,
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @ProfilePictureUrl NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserIsActive BIT; 

    IF NOT EXISTS (SELECT 1 FROM [user] WHERE id = @UserId)
    BEGIN
        SELECT 0 AS Success, 'User not found' AS Message
        RETURN;
    END

    SELECT @UserIsActive = is_active 
    FROM [user] 
    WHERE id = @UserId;

    IF @UserIsActive = 0
    BEGIN
        SELECT 0 AS Success, 'Cannot edit an inactive user' AS Message
        RETURN;
    END

    BEGIN TRANSACTION;

    BEGIN TRY

        UPDATE [user]
        SET 
            email = COALESCE(@Email, email),
            password_hash = COALESCE(@PasswordHash, password_hash),
            first_name = COALESCE(@FirstName, first_name),
            last_name = COALESCE(@LastName, last_name),
            profile_picture_url = COALESCE(@ProfilePictureUrl, profile_picture_url)
        WHERE id = @UserId;

        COMMIT TRANSACTION;

        SELECT 1 AS Success, 'User updated successfully' AS Message

    END TRY
    BEGIN CATCH

        ROLLBACK TRANSACTION;

        SELECT 0 AS Success, ERROR_MESSAGE() AS Message

    END CATCH

END
GO