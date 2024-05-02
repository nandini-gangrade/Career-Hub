-- Task 1: SQL script to initialize the CareerHub database
CREATE DATABASE CareerHUB
USE CareerHub
  
-- Task 2: Tables created successfully with appropriate constraints
-- Create tables
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY IDENTITY(1,1),
    CompanyName VARCHAR(255),
    Location VARCHAR(255)
);

CREATE TABLE Jobs (
    JobID INT PRIMARY KEY IDENTITY(1,1),
    CompanyID INT,
    JobTitle VARCHAR(255),
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL(10, 2),
    JobType VARCHAR(50),
    PostedDate DATE
);

CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Resume TEXT
);

CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY IDENTITY(1,1),
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATE,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);

-- Task 3. Define appropriate primary keys, foreign keys, and constraints. 

-- Primary Keys
ALTER TABLE Companies ADD CONSTRAINT PK_Companies PRIMARY KEY (CompanyID);
ALTER TABLE Jobs ADD CONSTRAINT PK_Jobs PRIMARY KEY (JobID);
ALTER TABLE Applicants ADD CONSTRAINT PK_Applicants PRIMARY KEY (ApplicantID);
ALTER TABLE Applications ADD CONSTRAINT PK_Applications PRIMARY KEY (ApplicationID);

-- Foreign Keys
ALTER TABLE Jobs ADD CONSTRAINT FK_CompanyID FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID);
ALTER TABLE Applications ADD CONSTRAINT FK_JobID FOREIGN KEY (JobID) REFERENCES Jobs(JobID);
ALTER TABLE Applications ADD CONSTRAINT FK_ApplicantID FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID);

-- Constraints
ALTER TABLE Jobs ADD CONSTRAINT CHK_SalaryNonNegative CHECK (Salary >= 0);
-- Add more constraints as needed


-- Insert data
INSERT INTO Companies (CompanyName, Location) VALUES
('Tech Innovations', 'San Francisco'),
('Data Driven Inc', 'New York'),
('GreenTech Solutions', 'Austin'),
('CodeCrafters', 'Boston'),
('HexaWare Technologies', 'Chennai');

INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(1, 'Frontend Developer', 'Develop user-facing features', 'San Francisco', 75000, 'Full-time', '2023-01-10'),
(2, 'Data Analyst', 'Interpret data models', 'New York', 68000, 'Full-time', '2023-02-20'),
(3, 'Environmental Engineer', 'Develop environmental solutions', 'Austin', 85000, 'Full-time', '2023-03-15'),
(1, 'Backend Developer', 'Handle server-side logic', 'Remote', 77000, 'Full-time', '2023-04-05'),
(4, 'Software Engineer', 'Develop and test software systems', 'Boston', 90000, 'Full-time', '2023-01-18'),
(5, 'HR Coordinator', 'Manage hiring processes', 'Chennai', 45000, 'Contract', '2023-04-25'),
(2, 'Senior Data Analyst', 'Lead data strategies', 'New York', 95000, 'Full-time', '2023-01-22');

INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', 'Experienced web developer with 5 years of experience.'),
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', 'Data enthusiast with 3 years of experience in data analysis.'),
('Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012', 'Environmental engineer with 4 years of field experience.'),
('Bob', 'Brown', 'bob.brown@example.com', '456-789-0123', 'Seasoned software engineer with 8 years of experience.');

INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter) VALUES
(1, 1, '2023-04-01', 'I am excited to apply for the Frontend Developer position.'),
(2, 2, '2023-04-02', 'I am interested in the Data Analyst position.'),
(3, 3, '2023-04-03', 'I am eager to bring my expertise to your team as an Environmental Engineer.'),
(4, 4, '2023-04-04', 'I am applying for the Backend Developer role to leverage my skills.'),
(5, 1, '2023-04-05', 'I am also interested in the Software Engineer position at CodeCrafters.');

-- Task 4: Ensure the script handles potential errors, such as if the database or tables already exist.
SELECT * FROM Companies;
SELECT * FROM Jobs;
SELECT * FROM Applicants;
SELECT * FROM Applications;

-- Task 5: Query to count the number of applications received for each job listing
SELECT J.JobTitle AS 'Job Title', ISNULL(COUNT(A.ApplicationID), 0) AS 'Application Count'
FROM Jobs J
LEFT JOIN Applications A ON J.JobID = A.JobID
GROUP BY J.JobTitle;

-- Task 6: Query to retrieve job listings within a specified salary range
DECLARE @MinSalary DECIMAL(10, 2) = 60000;
DECLARE @MaxSalary DECIMAL(10, 2) = 80000;

SELECT J.JobTitle, C.CompanyName, J.JobLocation, J.Salary
FROM Jobs J
INNER JOIN Companies C ON J.CompanyID = C.CompanyID
WHERE J.Salary BETWEEN @MinSalary AND @MaxSalary;

-- Task 7: Query to retrieve job application history for a specific applicant
DECLARE @ApplicantID INT = 1; -- Specify the ApplicantID here

SELECT J.JobTitle, C.CompanyName, A.ApplicationDate
FROM Applications A
INNER JOIN Jobs J ON A.JobID = J.JobID
INNER JOIN Companies C ON J.CompanyID = C.CompanyID
WHERE A.ApplicantID = @ApplicantID;

-- Task 8: Query to calculate and display the average salary offered by all companies
SELECT AVG(Salary) AS 'Average Salary'
FROM Jobs
WHERE Salary > 0;

-- Task 9: Query to identify the company that has posted the most job listings
SELECT TOP 1 C.CompanyName, COUNT(J.JobID) AS 'Job Count'
FROM Companies C
LEFT JOIN Jobs J ON C.CompanyID = J.CompanyID
GROUP BY C.CompanyName
ORDER BY COUNT(J.JobID) DESC;

-- Task 10: Query to find applicants who have applied for positions in companies located in a specific city and have at least 3 years of experience
DECLARE @City VARCHAR(255) = 'Chennai';

SELECT DISTINCT A.FirstName, A.LastName
FROM Applicants A
INNER JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
INNER JOIN Jobs J ON Ap.JobID = J.JobID
INNER JOIN Companies C ON J.CompanyID = C.CompanyID
WHERE C.Location = @City
AND A.Resume LIKE '%3 years of experience%'

-- Task 11: Query to retrieve a list of distinct job titles with salaries between $60,000 and $80,000
SELECT DISTINCT JobTitle, Salary
FROM Jobs
WHERE Salary BETWEEN 60000 AND 80000;

-- Task 12: Query to find the jobs that have not received any applications
SELECT JobID, JobTitle
FROM Jobs
WHERE JobID NOT IN (SELECT DISTINCT JobID FROM Applications);

-- Task 13: Query to retrieve a list of job applicants along with the companies and positions they have applied for
SELECT A.FirstName, A.LastName, C.CompanyName, J.JobTitle
FROM Applicants A
INNER JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
INNER JOIN Jobs J ON Ap.JobID = J.JobID
INNER JOIN Companies C ON J.CompanyID = C.CompanyID;

-- Task 14: Query to retrieve a list of companies along with the count of jobs they have posted
SELECT C.CompanyName, ISNULL(COUNT(J.JobID), 0) AS 'Job Count'
FROM Companies C
LEFT JOIN Jobs J ON C.CompanyID = J.CompanyID
GROUP BY C.CompanyName;

-- Task 15: Query to list all applicants along with the companies and positions they have applied for, including those who have not applied
SELECT A.FirstName, A.LastName, ISNULL(C.CompanyName, 'Not Applied') AS 'Company Name', ISNULL(J.JobTitle, 'Not Applied') AS 'Job Title'
FROM Applicants A
LEFT JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
LEFT JOIN Jobs J ON Ap.JobID = J.JobID
LEFT JOIN Companies C ON J.CompanyID = C.CompanyID;

-- Task 16: Query to find companies that have posted jobs with a salary higher than the average salary of all jobs
DECLARE @AverageSalary DECIMAL(10, 2);
SELECT @AverageSalary = AVG(Salary)
FROM Jobs
WHERE Salary > 0;

SELECT C.CompanyName
FROM Companies C
INNER JOIN Jobs J ON C.CompanyID = J.CompanyID
WHERE J.Salary > @AverageSalary;

-- Task 17: Query to display a list of applicants with their names and a concatenated string of their city and state
SELECT A.FirstName, A.LastName, C.Location + ', ' + C.State AS 'City and State'
FROM Applicants A
INNER JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
INNER JOIN Jobs J ON Ap.JobID = J.JobID
INNER JOIN Companies C ON J.CompanyID = C.CompanyID;

-- Task 18: Query to retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'
SELECT JobID, JobTitle
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

-- Task 19: Query to retrieve a list of applicants and the jobs they have
SELECT A.FirstName, A.LastName, ISNULL(C.CompanyName, 'Not Applied') AS 'Company Name', ISNULL(J.JobTitle, 'Not Applied') AS 'Job Title'
FROM Applicants A
FULL OUTER JOIN Applications Ap ON A.ApplicantID = Ap.ApplicantID
FULL OUTER JOIN Jobs J ON Ap.JobID = J.JobID
FULL OUTER JOIN Companies C ON J.CompanyID = C.CompanyID;

-- Task 20: List all combinations of applicants and companies where the company is in a specific city and the applicant has more than 2 years of experience
SELECT c.CompanyName,
CONCAT(a.FirstName, ' ', a.LastName) AS ApplicantName
FROM  Companies c
JOIN Jobs j ON j.CompanyID = c.CompanyID
JOIN Applications app ON j.JobID = app.JobID
JOIN Applicants a ON app.ApplicantID = a.ApplicantID
WHERE 
c.Location = 'austin'
AND a.Resume LIKE '%[2-9] years%';

