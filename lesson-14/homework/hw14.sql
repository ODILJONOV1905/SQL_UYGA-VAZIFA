use homework14

---oson 
--1-task 
SELECT 
    LEFT(Name, CHARINDEX(',', Name)-1) AS Name,
    LTRIM(RIGHT(Name, LEN(Name) - CHARINDEX(',', Name))) AS Surname
FROM TestMultipleColumns;

--2-task
SELECT *
FROM TestPercent
WHERE Strs LIKE '%[%]%';

--3-task

SELECT 
    LEFT(Vals, CHARINDEX('.', Vals)-1) AS FirstPart,
    RIGHT(Vals, LEN(Vals) - CHARINDEX('.', Vals)) AS SecondPart
FROM Splitter;

--4-task
SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

---5-task
SELECT texts, LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

---6-task
SELECT e.Name
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary;

--7-task
SELECT 
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 15;

---orta

--1-task
SELECT w1.Id
FROM weather w1
JOIN weather w2 ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature;

--2-task
SELECT player_id, MIN(event_date) AS FirstLoginDate
FROM Activity
GROUP BY player_id;

--3-task
SELECT value AS ThirdItem
FROM STRING_SPLIT((SELECT fruit_list FROM fruits), ',')
ORDER BY (SELECT NULL) -- SQL Server STRING_SPLIT is unordered
OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;

--4-task
SELECT 
    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE,
    CASE 
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS EmploymentStage
FROM Employees;

--5-task
SELECT 
    Id,
    CASE 
        WHEN VALS LIKE '[0-9]%' THEN CAST(LEFT(VALS, PATINDEX('%[^0-9]%', VALS + 'X') - 1) AS INT)
        ELSE NULL
    END AS LeadingInteger
FROM GetIntegers;

---Qiyin
--1-task
SELECT 
    Id,
    STUFF(Vals, 1, 2, SUBSTRING(Vals, 2, 1) + LEFT(Vals,1)) AS Swapped
FROM MultipleVals;

--2-task
DECLARE @str VARCHAR(100) = 'sdgfhsdgfhs@121313131';

WITH CTE AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM CTE WHERE n < LEN(@str)
)
SELECT SUBSTRING(@str, n, 1) AS Character
FROM CTE
OPTION (MAXRECURSION 0);

--3-task
SELECT player_id, device_id, MIN(event_date) AS FirstLogin
FROM Activity
GROUP BY player_id, device_id;

--4-task
SELECT
    Vals,
    CONCAT('', (SELECT STRING_AGG(value, '') FROM STRING_SPLIT(Vals, '') WHERE value LIKE '[0-9]')) AS Integers,
    CONCAT('', (SELECT STRING_AGG(value, '') FROM STRING_SPLIT(Vals, '') WHERE value LIKE '[^0-9]')) AS Characters
FROM (VALUES('rtcfvty34redt')) AS t(Vals);

