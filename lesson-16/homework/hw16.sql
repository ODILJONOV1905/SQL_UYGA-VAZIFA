use homework16

---oson
WITH Numbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM Numbers
    WHERE Number < 1000
)
SELECT Number
FROM Numbers
OPTION (MAXRECURSION 0);

--2-task
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, EmployeeSales.TotalSales
FROM Employees
JOIN (
    SELECT Sales.EmployeeID, SUM(Sales.SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY Sales.EmployeeID
) EmployeeSales ON Employees.EmployeeID = EmployeeSales.EmployeeID;

--3-task 
WITH AverageSalary AS (
    SELECT AVG(Employees.Salary) AS AvgSalary
    FROM Employees
)
SELECT AvgSalary
FROM AverageSalary;

--4-task
SELECT Products.ProductID, Products.ProductName, ProductMaxSales.MaxSale
FROM Products
JOIN (
    SELECT Sales.ProductID, MAX(Sales.SalesAmount) AS MaxSale
    FROM Sales
    GROUP BY Sales.ProductID
) ProductMaxSales ON Products.ProductID = ProductMaxSales.ProductID;

--5-task
WITH DoubledNumbers AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number * 2
    FROM DoubledNumbers
    WHERE Number * 2 < 1000000
)
SELECT Number
FROM DoubledNumbers
OPTION (MAXRECURSION 0);

--6-task

WITH EmployeeSalesCount AS (
    SELECT Sales.EmployeeID, COUNT(*) AS SalesCount
    FROM Sales
    GROUP BY Sales.EmployeeID
)
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, EmployeeSalesCount.SalesCount
FROM Employees
JOIN EmployeeSalesCount ON Employees.EmployeeID = EmployeeSalesCount.EmployeeID
WHERE EmployeeSalesCount.SalesCount > 5;

--7-task
WITH ProductTotalSales AS (
    SELECT Sales.ProductID, SUM(Sales.SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY Sales.ProductID
)
SELECT Products.ProductID, Products.ProductName, ProductTotalSales.TotalSales
FROM Products
JOIN ProductTotalSales ON Products.ProductID = ProductTotalSales.ProductID
WHERE ProductTotalSales.TotalSales > 500;

--8-task

WITH AverageSalary AS (
    SELECT AVG(Employees.Salary) AS AvgSalary
    FROM Employees
)
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, Employees.Salary
FROM Employees
WHERE Employees.Salary > (SELECT AvgSalary FROM AverageSalary);

---orta
--1-task
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, EmployeeOrderCount.OrderCount
FROM Employees
JOIN (
    SELECT Sales.EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY Sales.EmployeeID
) EmployeeOrderCount ON Employees.EmployeeID = EmployeeOrderCount.EmployeeID
ORDER BY EmployeeOrderCount.OrderCount DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--2-task

SELECT Products.CategoryID, SUM(Sales.SalesAmount) AS TotalSales
FROM Products
JOIN Sales ON Products.ProductID = Sales.ProductID
GROUP BY Products.CategoryID;

--3-task
WITH FactorialCTE AS (
    SELECT Numbers1.Number, 1 AS Factorial, 1 AS Counter
    FROM Numbers1
    WHERE Numbers1.Number >= 1
    UNION ALL
    SELECT FactorialCTE.Number, FactorialCTE.Factorial * (FactorialCTE.Counter + 1), FactorialCTE.Counter + 1
    FROM FactorialCTE
    WHERE FactorialCTE.Counter + 1 <= FactorialCTE.Number
)
SELECT Number, MAX(Factorial) AS Factorial
FROM FactorialCTE
GROUP BY Number
ORDER BY Number;

--4-task
WITH SplitString AS (
    SELECT Example.Id, SUBSTRING(Example.String, 1, 1) AS Character, 1 AS Position
    FROM Example
    UNION ALL
    SELECT Example.Id, SUBSTRING(Example.String, SplitString.Position + 1, 1), SplitString.Position + 1
    FROM SplitString
    JOIN Example ON SplitString.Id = Example.Id
    WHERE SplitString.Position + 1 <= LEN(Example.String)
)
SELECT Id, Character
FROM SplitString
ORDER BY Id, Position;

--5-task
WITH MonthlySales AS (
    SELECT 
        YEAR(Sales.SaleDate) AS SaleYear,
        MONTH(Sales.SaleDate) AS SaleMonth,
        SUM(Sales.SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(Sales.SaleDate), MONTH(Sales.SaleDate)
)
SELECT 
    CurrentMonth.SaleYear,
    CurrentMonth.SaleMonth,
    CurrentMonth.TotalSales,
    CurrentMonth.TotalSales - ISNULL(PreviousMonth.TotalSales, 0) AS SalesDifference
FROM MonthlySales AS CurrentMonth
LEFT JOIN MonthlySales AS PreviousMonth
    ON CurrentMonth.SaleYear = PreviousMonth.SaleYear 
    AND CurrentMonth.SaleMonth = PreviousMonth.SaleMonth + 1
ORDER BY CurrentMonth.SaleYear, CurrentMonth.SaleMonth;

--6-task
SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, EmployeeQuarterSales.TotalSales, EmployeeQuarterSales.Quarter
FROM Employees
JOIN (
    SELECT Sales.EmployeeID, DATEPART(QUARTER, Sales.SaleDate) AS Quarter, SUM(Sales.SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY Sales.EmployeeID, DATEPART(QUARTER, Sales.SaleDate)
    HAVING SUM(Sales.SalesAmount) > 45000
) EmployeeQuarterSales ON Employees.EmployeeID = EmployeeQuarterSales.EmployeeID
ORDER BY Employees.EmployeeID, EmployeeQuarterSales.Quarter;

---qiyin

--1-task
WITH FibonacciCTE AS (
    SELECT 1 AS Position, 0 AS FibonacciNumber
    UNION ALL
    SELECT 2 AS Position, 1 AS FibonacciNumber
    UNION ALL
    SELECT FibonacciCTE.Position + 1, 
           (SELECT TOP 1 FibonacciNumber FROM FibonacciCTE f2 WHERE f2.Position = FibonacciCTE.Position)
         + (SELECT TOP 1 FibonacciNumber FROM FibonacciCTE f3 WHERE f3.Position = FibonacciCTE.Position - 1)
    FROM FibonacciCTE
    WHERE FibonacciCTE.Position < 20
)
SELECT Position, FibonacciNumber
FROM FibonacciCTE
ORDER BY Position;

--2-task
SELECT FindSameCharacters.Id, FindSameCharacters.Vals
FROM FindSameCharacters
WHERE FindSameCharacters.Vals IS NOT NULL
  AND LEN(FindSameCharacters.Vals) > 1
  AND FindSameCharacters.Vals = REPLICATE(SUBSTRING(FindSameCharacters.Vals, 1, 1), LEN(FindSameCharacters.Vals));

  --3-task
  DECLARE @n INT = 5;

WITH NumberConcat AS (
    SELECT 1 AS Position, CAST(1 AS VARCHAR(10)) AS NumberSequence
    UNION ALL
    SELECT Position + 1, CAST(NumberSequence + CAST(Position + 1 AS VARCHAR(10)) AS VARCHAR(10))
    FROM NumberConcat
    WHERE Position + 1 <= @n
)
SELECT NumberSequence
FROM NumberConcat
ORDER BY Position;

--4-task
DECLARE @MaxDate DATE = (SELECT MAX(Sales.SaleDate) FROM Sales);

SELECT Employees.EmployeeID, Employees.FirstName, Employees.LastName, EmployeeSales.TotalSales
FROM Employees
JOIN (
    SELECT Sales.EmployeeID, SUM(Sales.SalesAmount) AS TotalSales
    FROM Sales
    WHERE Sales.SaleDate >= DATEADD(MONTH, -6, @MaxDate)
    GROUP BY Sales.EmployeeID
) EmployeeSales ON Employees.EmployeeID = EmployeeSales.EmployeeID
WHERE EmployeeSales.TotalSales = (
    SELECT MAX(SUM(Sales.SalesAmount)) 
    FROM Sales
    WHERE Sales.SaleDate >= DATEADD(MONTH, -6, @MaxDate)
    GROUP BY Sales.EmployeeID
);

--5-task
SELECT RemoveDuplicateIntsFromNames.PawanName, 
       REPLACE(
         REPLACE(
           REPLACE(
             REPLACE(
               REPLACE(
                 RemoveDuplicateIntsFromNames.Pawan_slug_name,
                 '1',''
               ),'2',''
             ),'3',''
           ),'4',''
         ),'5',''
       ) AS CleanedString
FROM RemoveDuplicateIntsFromNames;
