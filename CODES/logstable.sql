USE mydb;

CREATE TABLE logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    username VARCHAR(100),
    action_type VARCHAR(50),
    request_id VARCHAR(50),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
use mydb;
select * from logs;
ALTER TABLE logs
MODIFY user_id INT NULL;
ALTER TABLE logs
ADD COLUMN report_type VARCHAR(100) NULL;
desc users;