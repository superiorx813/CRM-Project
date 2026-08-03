CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL
);
USE mydb;
INSERT INTO users (username, password)
VALUES
('mohankorg', 'Mohan@123'),
('sai01', 'Sai@01'),
('shiva02', 'Shiva@02'),
('lokesh', 'Lokesh@02');
SELECT * from users; 
ALTER TABLE users
ADD mail_id VARCHAR(100) UNIQUE
UPDATE users
SET mail_id = 'mohan.kasani.420@gmail.com'
WHERE user_id = 1;
DELETE FROM users
WHERE user_id BETWEEN 5 AND 8;
DELETE FROM users
WHERE user_id =10;
ALTER TABLE users
ADD profile_image VARCHAR(255);
DESCRIBE users;
ALTER TABLE users
ADD COLUMN role VARCHAR(50) NOT NULL,
ADD COLUMN description TEXT;
ALTER TABLE users
ADD name VARCHAR(50);
ALTER TABLE users
ALTER TABLE users
MODIFY role VARCHAR(255) NULL;
use mydb;
ADD mail_id VARCHAR(100)
UPDATE users
SET username = 'mohankorg'
WHERE user_id = 1;
select * from users;
CREATE DATABASE mydb;
