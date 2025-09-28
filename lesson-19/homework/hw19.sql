use homework19
---task1
CREATE PROCEDURE GetEmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        Employees.EmployeeID,
        Employees.FirstName + ' ' + Employees.LastName AS FullName,
        Employees.Department,
        Employees.Salary,
        Employees.Salary * DepartmentBonus.BonusPercentage / 100 AS BonusAmount
    FROM Employees
    JOIN DepartmentBonus ON Employees.Department = DepartmentBonus.Department;

    SELECT * FROM #EmployeeBonus;
END;

---task2
CREATE PROCEDURE UpdateSalaryByDepartment
    @Department NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercentage / 100)
    WHERE Department = @Department;

    SELECT * FROM Employees WHERE Department = @Department;
END;

--3task

MERGE INTO Products_Current AS Target
USING Products_New AS Source
ON Target.ProductID = Source.ProductID

WHEN MATCHED THEN
    UPDATE SET 
        Target.ProductName = Source.ProductName,
        Target.Price = Source.Price

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (Source.ProductID, Source.ProductName, Source.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;

---4task
SELECT 
    Tree.id,
    CASE 
        WHEN Tree.p_id IS NULL THEN 'Root'
        WHEN Tree.id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree
ORDER BY Tree.id;

---5task
SELECT 
    Signups.user_id,
    CAST(
        ISNULL(SUM(CASE WHEN Confirmations.action = 'confirmed' THEN 1 ELSE 0 END),0) * 1.0
        /
        NULLIF(COUNT(Confirmations.action),0)
    AS DECIMAL(10,2)) AS confirmation_rate
FROM Signups
LEFT JOIN Confirmations ON Signups.user_id = Confirmations.user_id
GROUP BY Signups.user_id
ORDER BY Signups.user_id;

---6task

SELECT *
FROM employees
WHERE salary = (
    SELECT MIN(salary) FROM employees
);

---7task

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        Products.ProductName,
        SUM(Sales.Quantity) AS TotalQuantitySold,
        SUM(Sales.Quantity * Products.Price) AS TotalSalesAmount,
        MIN(Sales.SaleDate) AS FirstSaleDate,
        MAX(Sales.SaleDate) AS LastSaleDate
    FROM Products
    LEFT JOIN Sales ON Products.ProductID = Sales.ProductID
    WHERE Products.ProductID = @ProductID
    GROUP BY Products.ProductName;
END;

