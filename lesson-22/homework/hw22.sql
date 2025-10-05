use homework22

---Oson
--1-task
SELECT 
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS RunningTotal
FROM sales_data;

--2-task
SELECT 
    product_category,
    COUNT(*) AS OrderCount
FROM sales_data
GROUP BY product_category;

--3-task
SELECT 
    product_category,
    MAX(total_amount) AS MaxAmount
FROM sales_data
GROUP BY product_category;
--4-task
SELECT 
    product_category,
    MIN(unit_price) AS MinPrice
FROM sales_data
GROUP BY product_category;

--5-task'
SELECT 
    order_date,
    AVG(total_amount) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS MovingAvg
FROM sales_data;

--6-task
SELECT 
    region,
    SUM(total_amount) AS TotalSales
FROM sales_data
GROUP BY region;

--7-task
SELECT 
    customer_id,
    customer_name,
    SUM(total_amount) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS SpendRank
FROM sales_data
GROUP BY customer_id, customer_name;

--8-task
SELECT 
    customer_id,
    order_date,
    total_amount,
    total_amount - LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS DiffFromPrev
FROM sales_data;

--9-task
SELECT *
FROM (
    SELECT 
        product_category,
        product_name,
        unit_price,
        RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS PriceRank
    FROM sales_data
) t
WHERE PriceRank <= 3;

--10-task
SELECT 
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date) AS CumulativeSum
FROM sales_data;


---O'rta
--11-task
SELECT 
    product_category,
    order_date,
    SUM(total_amount) OVER (PARTITION BY product_category ORDER BY order_date) AS CumulativeRevenue
FROM sales_data;

--12-task
SELECT 
    ID,
    SUM(ID) OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS SumPreValues
FROM (VALUES (1), (2), (3), (4), (5)) AS T(ID);

--13-task
SELECT 
    Value,
    SUM(Value) OVER (ORDER BY Value ROWS UNBOUNDED PRECEDING) AS [Sum of Previous]
FROM OneColumn;

--14-task
SELECT 
    customer_id,
    customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;

--15-task
SELECT 
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS TotalSpent
FROM sales_data
GROUP BY customer_id, customer_name, region
HAVING SUM(total_amount) > AVG(SUM(total_amount)) OVER (PARTITION BY region);

--16-task
SELECT 
    customer_id,
    customer_name,
    region,
    SUM(total_amount) AS TotalSpent,
    DENSE_RANK() OVER (PARTITION BY region ORDER BY SUM(total_amount) DESC) AS RegionRank
FROM sales_data
GROUP BY customer_id, customer_name, region;

--17-task
SELECT 
    customer_id,
    order_date,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS CumulativeSales
FROM sales_data;

--18-task
SELECT 
    FORMAT(order_date, 'yyyy-MM') AS Month,
    SUM(total_amount) AS TotalSales,
    LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) AS PrevMonthSales,
    (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM'))) * 100.0 / 
     LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) AS GrowthRate
FROM sales_data
GROUP BY FORMAT(order_date, 'yyyy-MM');

--19-task
SELECT 
    customer_id,
    order_date,
    total_amount
FROM (
    SELECT *,
        LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS PrevAmount
    FROM sales_data
) t
WHERE total_amount > PrevAmount;


---Qiyin
--20-task
SELECT *
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data);

--21-task
SELECT 
    Id, 
    Grp, 
    Val1, 
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData;

--22-task
SELECT 
    ID,
    SUM(Cost) AS Cost,
    SUM(DISTINCT Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

--23-task
SELECT 
    LAG(SeatNumber, 1, 0) OVER (ORDER BY SeatNumber) + 1 AS GapStart,
    SeatNumber - 1 AS GapEnd
FROM (
    SELECT SeatNumber, 
           LAG(SeatNumber) OVER (ORDER BY SeatNumber) AS PrevSeat
    FROM Seats
) t
WHERE SeatNumber - PrevSeat > 1;
