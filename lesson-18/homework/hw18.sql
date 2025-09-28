use homework18

--2-task
SELECT 
    Sales.ProductID,
    SUM(Sales.Quantity) AS TotalQuantity,
    SUM(Sales.Quantity * Products.Price) AS TotalRevenue
INTO #MonthlySales
FROM Sales
JOIN Products ON Sales.ProductID = Products.ProductID
WHERE MONTH(Sales.SaleDate) = MONTH(GETDATE())
  AND YEAR(Sales.SaleDate) = YEAR(GETDATE())
GROUP BY Sales.ProductID;

SELECT * FROM #MonthlySales;

--2-task
CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    Products.ProductID,
    Products.ProductName,
    Products.Category,
    ISNULL(SUM(Sales.Quantity),0) AS TotalQuantitySold
FROM Products
LEFT JOIN Sales ON Products.ProductID = Sales.ProductID
GROUP BY Products.ProductID, Products.ProductName, Products.Category;

--3-task

CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(18,2);

    SELECT @Revenue = SUM(Sales.Quantity * Products.Price)
    FROM Sales
    JOIN Products ON Sales.ProductID = Products.ProductID
    WHERE Sales.ProductID = @ProductID;

    RETURN ISNULL(@Revenue,0);
END;

--4-task

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        Products.ProductName,
        SUM(Sales.Quantity) AS TotalQuantity,
        SUM(Sales.Quantity * Products.Price) AS TotalRevenue
    FROM Products
    LEFT JOIN Sales ON Products.ProductID = Sales.ProductID
    WHERE Products.Category = @Category
    GROUP BY Products.ProductName
);

--5-task

CREATE FUNCTION dbo.fn_IsPrime(@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    IF @Number < 2 RETURN 'No';

    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
            RETURN 'No';
        SET @i = @i + 1;
    END
    RETURN 'Yes';
END;

--6-task

CREATE FUNCTION fn_GetNumbersBetween(@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start;
    WHILE @i <= @End
    BEGIN
        INSERT INTO @Numbers VALUES (@i);
        SET @i = @i + 1;
    END
    RETURN;
END;


--7-task

CREATE FUNCTION getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = Salary
    FROM (
        SELECT DISTINCT Salary,
               DENSE_RANK() OVER (ORDER BY Salary DESC) AS RankPosition
        FROM Employee
    ) AS RankedSalaries
    WHERE RankPosition = @N;

    RETURN @Result;
END;

--8-task

SELECT TOP 1 UserID AS id, COUNT(*) AS num
FROM (
    SELECT requester_id AS UserID, accepter_id AS FriendID FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS UserID, requester_id AS FriendID FROM RequestAccepted
) AS AllFriends
GROUP BY UserID
ORDER BY COUNT(*) DESC;


--9-task
CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    Customers.customer_id,
    Customers.name,
    COUNT(Orders.order_id) AS total_orders,
    ISNULL(SUM(Orders.amount),0) AS total_amount,
    MAX(Orders.order_date) AS last_order_date
FROM Customers
LEFT JOIN Orders ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id, Customers.name;

--10-task

WITH Filled AS
(
    SELECT 
        RowNumber,
        TestCase,
        MAX(TestCase) OVER (ORDER BY RowNumber 
                            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Workflow
    FROM Gaps
)
SELECT RowNumber, Workflow
FROM Filled
ORDER BY RowNumber;

