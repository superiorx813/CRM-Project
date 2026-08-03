CREATE TABLE requests (

    request_id INT PRIMARY KEY AUTO_INCREMENT,

    Title VARCHAR(100) NOT NULL,

    Description VARCHAR(255) NOT NULL

);

INSERT INTO requests (Title, Description) VALUES
('API Integration Issue', 'REST API integration failing due to invalid authentication token response.'),

('Database Connection Timeout', 'Application unable to establish stable connection with MySQL server.'),

('UI Enhancement Request', 'Need responsive dashboard layout improvements for mobile compatibility.'),

('Authentication Module Bug', 'Users experiencing login failures after session timeout expiration.'),

('Performance Optimization Task', 'Application response time significantly delayed during concurrent requests.'),

('Backend Validation Error', 'Form submission bypassing required server-side validation rules.'),

('Cloud Deployment Configuration', 'Production deployment requires environment variable configuration updates.'),

('Microservice Communication Failure', 'Inter-service communication interrupted due to gateway timeout issue.'),

('Security Vulnerability Patch', 'Critical authentication vulnerability identified in user management module.'),

('Data Migration Activity', 'Legacy application records need migration into the new CRM database schema.');
SELECT * from requests;
ALTER TABLE requests
ADD COLUMN username VARCHAR(100) NOT NULL AFTER request_id,
ADD COLUMN Department VARCHAR(100) NOT NULL AFTER Description;