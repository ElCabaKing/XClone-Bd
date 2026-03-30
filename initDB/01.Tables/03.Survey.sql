CREATE TABLE survey (
    id INT PRIMARY KEY IDENTITY(1,1),
    question NVARCHAR(MAX) NOT NULL,
    options NVARCHAR(MAX) NOT NULL,
    post_id INT NOT NULL,
    created_at DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (post_id) REFERENCES post(id) ON DELETE CASCADE,
    CONSTRAINT check_json_options CHECK (ISJSON(options) = 1)
);