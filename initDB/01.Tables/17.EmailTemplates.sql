

CREATE TABLE [email_templates] (
    [id] INT IDENTITY(1,1) PRIMARY KEY,
    [name] NVARCHAR(255) NOT NULL,
    [subject] NVARCHAR(255) NOT NULL,
    [body] NVARCHAR(MAX) NOT NULL,
    [created_at] DATETIME NOT NULL DEFAULT GETDATE(),
    [updated_at] DATETIME NOT NULL DEFAULT GETDATE()
);

INSERT INTO [email_templates] ([name], [subject], [body]) VALUES
('Welcome Email', 'Welcome to Our Service!', '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #f5f5f5; padding: 20px; border-radius: 8px;"><div style="background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"><p style="color: #333333; font-size: 16px; margin-bottom: 20px;">Dear {{first_name}},</p><p style="color: #555555; font-size: 14px; line-height: 1.6; margin-bottom: 20px;">Thank you for signing up for our service. We are excited to have you on board!</p><p style="color: #333333; font-size: 14px; margin-top: 30px; margin-bottom: 10px;">Best regards,</p><p style="color: #1a73e8; font-weight: bold; font-size: 14px;">The Team</p></div></div>'),
('Password Reset', 'Password Reset Request', '<div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; background-color: #f5f5f5; padding: 20px; border-radius: 8px;"><div style="background-color: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);"><p style="color: #333333; font-size: 16px; margin-bottom: 20px;">Dear {{first_name}},</p><p style="color: #555555; font-size: 14px; line-height: 1.6; margin-bottom: 20px;">We received a request to reset your password. Please click the link below to reset your password:</p><div style="margin: 30px 0; text-align: center;"><a href="{{reset_link}}" style="background-color: #1a73e8; color: #ffffff; padding: 12px 30px; text-decoration: none; border-radius: 4px; display: inline-block; font-weight: bold;">Reset Password</a></div><p style="color: #999999; font-size: 12px; margin-top: 30px;">If you did not request a password reset, please ignore this email.</p><p style="color: #333333; font-size: 14px; margin-top: 30px; margin-bottom: 10px;">Best regards,</p><p style="color: #1a73e8; font-weight: bold; font-size: 14px;">The Team</p></div></div>');