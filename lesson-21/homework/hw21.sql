use homework21

---1-task
SELECT *,
       ROW_NUMBER() OVER (ORDER BY SaleDate, SaleID) AS RowNum
FROM ProductSales;
---2-task
SELECT ProductName,
       SUM(Quantity) AS TotalQuantity,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankByQuantity
FROM ProductSales
GROUP BY ProductName
ORDER BY TotalQuantity DESC;

---3-task
;WITH cte AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC, SaleDate) AS rn
  FROM ProductSales
)
SELECT *
FROM cte
WHERE rn = 1;

---4-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS NextSaleAmount
FROM ProductSales
ORDER BY SaleDate;
---5-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS PrevSaleAmount
FROM ProductSales
ORDER BY SaleDate;

---6-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS PrevSaleAmount
FROM ProductSales
WHERE SaleAmount > LAG(SaleAmount) OVER (ORDER BY SaleDate, SaleID)
ORDER BY SaleDate;

---7-task

SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) AS DiffFromPrev
FROM ProductSales
ORDER BY ProductName, SaleDate;

---8-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS NextSaleAmount,
       CASE 
         WHEN SaleAmount = 0 THEN NULL
         ELSE (LEAD(SaleAmount) OVER (ORDER BY SaleDate, SaleID) - SaleAmount) * 100.0 / SaleAmount
       END AS PercentChangeToNext
FROM ProductSales
ORDER BY SaleDate;

---9-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       CASE 
         WHEN LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) = 0 
         THEN NULL
         ELSE CAST(SaleAmount AS DECIMAL(18,6)) / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID)
       END AS RatioToPrev
FROM ProductSales
ORDER BY ProductName, SaleDate;

---10-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID
                                                  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
       AS DiffFromFirst
FROM ProductSales
ORDER BY ProductName, SaleDate;

---11-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(CASE WHEN SaleAmount <= LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) THEN 1 ELSE 0 END)
         OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID ROWS UNBOUNDED PRECEDING) AS NonIncreaseCountUpToRow
FROM ProductSales
WHERE 
  -- NonIncreaseCountUpToRow = 0 bo'lganlar — ya'ni boshlangichdan shu qatorgacha hech qachon non-increase bo'lmagan
  SUM(CASE WHEN SaleAmount <= LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID) THEN 1 ELSE 0 END)
    OVER (PARTITION BY ProductName ORDER BY SaleDate, SaleID ROWS UNBOUNDED PRECEDING) = 0
ORDER BY ProductName, SaleDate;

---12-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SUM(SaleAmount) OVER (ORDER BY SaleDate, SaleID ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM ProductSales
ORDER BY SaleDate;

---13-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       AVG(SaleAmount) OVER (ORDER BY SaleDate, SaleID ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg_Last3
FROM ProductSales
ORDER BY SaleDate;

---14-task
SELECT SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - AVG(SaleAmount) OVER () AS DiffFromOverallAvg
FROM ProductSales
ORDER BY SaleDate;

---15-task
;WITH ranked AS (
  SELECT *,
         DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
  FROM Employees1
)
SELECT r.*
FROM ranked r
JOIN (
  SELECT SalaryRank
  FROM ranked
  GROUP BY SalaryRank
  HAVING COUNT(*) > 1
) dup ON r.SalaryRank = dup.SalaryRank
ORDER BY r.SalaryRank, r.Salary DESC;

---16-task
SELECT EmployeeID, Name, Department, Salary, HireDate
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC, HireDate) AS rn
  FROM Employees1
) t
WHERE rn <= 2
ORDER BY Department, rn;

---17-task
SELECT EmployeeID, Name, Department, Salary, HireDate
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC, HireDate) AS rn
  FROM Employees1
) t
WHERE rn = 1
ORDER BY Department;
---18-task
SELECT EmployeeID, Name, Department, Salary, HireDate,
       SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS UNBOUNDED PRECEDING) AS DeptRunningTotal
FROM Employees1
ORDER BY Department, HireDate;

---19-task
SELECT DISTINCT Department,
       SUM(Salary) OVER (PARTITION BY Department) AS TotalSalaryByDepartment
FROM Employees1;

---20-task
SELECT DISTINCT Department,
       AVG(Salary) OVER (PARTITION BY Department) AS AvgSalaryByDepartment
FROM Employees1;

---21-task
SELECT EmployeeID, Name, Department, Salary, HireDate,
       Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees1
ORDER BY Department, Salary DESC;

---22-task
SELECT EmployeeID, Name, Department, Salary, HireDate,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg_3Employees
FROM Employees1
ORDER BY HireDate;

---23-task
SELECT EmployeeID, Name, Department, Salary, HireDate,
       AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg_3Employees
FROM Employees1
ORDER BY HireDate;

