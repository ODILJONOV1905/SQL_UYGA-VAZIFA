use homework23

---Puzzle
--1-puzzle
SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPrefixedWithZero
FROM Dates;

--20-puzzle
SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVals) AS TotalOfMaxVals
FROM (
    SELECT Id, rID, MAX(Vals) AS MaxVals
    FROM MyTabel
    GROUP BY Id, rID
) t
GROUP BY rID;

--3-puzzle
SELECT 
    Id,
    Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10;

--4-puzzle
SELECT 
    ID,
    Item,
    Vals
FROM TestMaximum t
WHERE Vals = (
    SELECT MAX(Vals)
    FROM TestMaximum
    WHERE ID = t.ID
);

--5-puzzle
SELECT 
    Id,
    SUM(MaxVals) AS SumofMax
FROM (
    SELECT Id, DetailedNumber, MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) t
GROUP BY Id;

--6-puzzle
SELECT 
    Id,
    a,
    b,
    CASE 
        WHEN a - b = 0 THEN ''
        ELSE CAST(a - b AS VARCHAR(20))
    END AS OUTPUT
FROM TheZeroPuzzle;

---sales

--7-task
SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales;

--8-task
SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

--9-task
SELECT COUNT(*) AS TotalTransactions
FROM Sales;

--10-task
SELECT MAX(QuantitySold) AS HighestUnitsSold
FROM Sales;

--11-task
SELECT 
    Category,
    SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;

--12-task
SELECT 
    Region,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

--13-task
SELECT TOP 1
    Product,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

--14-task
SELECT 
    SaleDate,
    SUM(QuantitySold * UnitPrice) AS DailyRevenue,
    SUM(SUM(QuantitySold * UnitPrice)) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
GROUP BY SaleDate
ORDER BY SaleDate;

--15-task
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    SUM(QuantitySold * UnitPrice) * 100.0 / SUM(SUM(QuantitySold * UnitPrice)) OVER () AS PercentageOfTotal
FROM Sales
GROUP BY Category;

--16-task
SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    SUM(QuantitySold * UnitPrice) * 100.0 / SUM(SUM(QuantitySold * UnitPrice)) OVER () AS PercentageOfTotal
FROM Sales
GROUP BY Category;

--17-task
SELECT 
    s.SaleID,
    s.Product,
    s.QuantitySold,
    s.UnitPrice,
    s.SaleDate,
    c.CustomerName,
    c.Region
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID;

--18-task
SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.CustomerID IS NULL;

--19-task
SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName;

--20-task
SELECT TOP 1
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

--21-task

SELECT 
    c.CustomerName,
    SUM(s.QuantitySold) AS TotalUnits
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerName;

--22-task
SELECT DISTINCT p.ProductName
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

--23-task
SELECT TOP 1 *
FROM Products
ORDER BY SellingPrice DESC;


--24-task

SELECT 
    p.ProductName,
    p.Category,
    p.SellingPrice
FROM Products p
WHERE p.SellingPrice > (
    SELECT AVG(SellingPrice)
    FROM Products
    WHERE Category = p.Category
);


