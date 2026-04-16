

CREATE TABLE [email_templates] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [subject] NVARCHAR(255) NOT NULL,
    [body] NVARCHAR(MAX) NOT NULL,
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
    [updated_at] DATETIME NOT NULL DEFAULT GETDATE()
);

INSERT INTO [email_templates] ([name], [subject], [body]) VALUES
('Welcome Email', 'Welcome to Our Service!', 'Dear {{first_name}},\n\nThank you for signing up for our service. We are excited to have you on board!\n\nBest regards,\nThe Team'),
('Password Reset', 'Password Reset Request', 'Dear {{first_name}},\n\nWe received a request to reset your password. Please click the link below to reset your password:\n\n{{reset_link}}\n\nIf you did not request a password reset, please ignore this email.\n\nBest regards,\nThe Team');