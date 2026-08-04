CREATE TABLE requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NOT NULL

);

SELECT * from requests;
ALTER TABLE requests
ADD COLUMN username VARCHAR(100) NOT NULL AFTER request_id,
ADD COLUMN Department VARCHAR(100) NOT NULL AFTER Description;
use mydb;
DROP TABLE requests;
CREATE TABLE requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Department VARCHAR(100) NOT NULL
);