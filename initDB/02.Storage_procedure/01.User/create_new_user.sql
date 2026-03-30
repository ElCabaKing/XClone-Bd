CREATE OR ALTER PROCEDURE CreateNewUser
    @Username NVARCHAR(50),
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(255),
    @FirstName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50) = NULL,
    @ProfilePictureUrl NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM [user] WHERE username = @Username)
    BEGIN
        SELECT 0 AS Success, 'Username already exists' AS Message
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [user] WHERE email = @Email)
    BEGIN
        SELECT 0 AS Success, 'Email already exists' AS Message
        RETURN;
    END

    INSERT INTO [user]
    (
        username,
        email,
        password_hash,
        first_name,
        last_name,
        profile_picture_url
    )
    VALUES
    (
        @Username,
        @Email,
        @PasswordHash,
        @FirstName,
        @LastName,
        @ProfilePictureUrl
    );

    SELECT 1 AS Success, 'User created successfully' AS Message
END
GO