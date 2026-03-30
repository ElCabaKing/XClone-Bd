CREATE PROCEDURE DeactivateUser
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM [user] WHERE id = @UserId)
    BEGIN
        SELECT 0 AS Success, 'User not found' AS Message
        RETURN;
    END
    UPDATE [user]
    SET is_active = 0
    WHERE id = @UserId;
    SELECT 1 AS Success, 'User deactivated successfully' AS Message
END
GO