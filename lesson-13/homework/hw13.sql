use homework13
---oson

SELECT CAST(EMPLOYEE_ID AS VARCHAR) + '-' + FIRST_NAME + ' ' + LAST_NAME AS EmployeeInfo
FROM Employees;

UPDATE Employees
SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999');

SELECT FIRST_NAME AS [Employee Name], LEN(FIRST_NAME) AS [Name Length]
FROM Employees
WHERE LEFT(FIRST_NAME,1) IN ('A','J','M')
ORDER BY FIRST_NAME;

SELECT MANAGER_ID, SUM(SALARY) AS TotalSalary
FROM Employees
GROUP BY MANAGER_ID;

SELECT Year1,
       (SELECT MAX(v) FROM (VALUES(Max1), (Max2), (Max3)) AS Value(v)) AS MaxValue
FROM TestMax;

SELECT *
FROM Cinema
WHERE MovieID % 2 = 1 AND Description <> 'boring';

SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

SELECT COALESCE(Column1, Column2, Column3, Column4) AS FirstNonNull
FROM Person;

---orta
SELECT 
    PARSENAME(REPLACE(FullName,' ','.'),3) AS FirstName,
    PARSENAME(REPLACE(FullName,' ','.'),2) AS MiddleName,
    PARSENAME(REPLACE(FullName,' ','.'),1) AS LastName
FROM Students;

SELECT o.*
FROM Orders o
WHERE o.DeliveryState = 'TX'
AND o.CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE DeliveryState = 'CA'
);

SELECT STRING_AGG(String, ' ') AS ConcatenatedString
FROM DMLTable
ORDER BY SequenceNumber;

SELECT *
FROM Employees
WHERE (LEN(FIRST_NAME + LAST_NAME) - LEN(REPLACE(LOWER(FIRST_NAME + LAST_NAME),'a',''))) >= 3;

SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS TotalEmployees,
    100.0 * SUM(CASE WHEN DATEDIFF(YEAR,HIRE_DATE,GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*) AS PercentOver3Years
FROM Employees
GROUP BY DEPARTMENT_ID;

---qiyin

SELECT StudentID, FullName, Grade,
       SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningSum
FROM Students;

SELECT s1.StudentName, s1.Birthday
FROM Student s1
JOIN Student s2 ON s1.Birthday = s2.Birthday AND s1.StudentName <> s2.StudentName
ORDER BY s1.Birthday;

SELECT PlayerA, PlayerB, SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY PlayerA, PlayerB;

DECLARE @str VARCHAR(50) = 'tf56sd#%OqH';

SELECT
    (SELECT STRING_AGG(value,'') FROM STRING_SPLIT(@str,'') WHERE value LIKE '[A-Z]') AS Uppercase,
    (SELECT STRING_AGG(value,'') FROM STRING_SPLIT(@str,'') WHERE value LIKE '[a-z]') AS Lowercase,
    (SELECT STRING_AGG(value,'') FROM STRING_SPLIT(@str,'') WHERE value LIKE '[0-9]') AS Numbers,
    (SELECT STRING_AGG(value,'') FROM STRING_SPLIT(@str,'') WHERE value NOT LIKE '[A-Za-z0-9]') AS OtherChars;

