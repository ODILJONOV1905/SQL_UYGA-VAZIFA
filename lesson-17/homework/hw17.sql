use homework17

---1-task

SELECT Region.Region,
       Distributor.Distributor,
       ISNULL(RegionSales.Sales, 0) AS Sales
FROM (SELECT DISTINCT Region FROM #RegionSales) AS Region
CROSS JOIN (SELECT DISTINCT Distributor FROM #RegionSales) AS Distributor
LEFT JOIN #RegionSales AS RegionSales
  ON Region.Region = RegionSales.Region 
 AND Distributor.Distributor = RegionSales.Distributor
ORDER BY Region.Region, Distributor.Distributor;

---2-task

SELECT Employee.name
FROM Employee
JOIN Employee AS Manager
  ON Employee.id = Manager.managerId
GROUP BY Employee.id, Employee.name
HAVING COUNT(Manager.id) >= 5;

---3-task
SELECT Products.product_name,
       SUM(Orders.unit) AS unit
FROM Products
JOIN Orders 
  ON Products.product_id = Orders.product_id
WHERE YEAR(Orders.order_date) = 2020
  AND MONTH(Orders.order_date) = 2
GROUP BY Products.product_name
HAVING SUM(Orders.unit) >= 100;

---4-task

WITH CustomerVendorOrders AS (
  SELECT Orders.CustomerID, 
         Orders.Vendor, 
         SUM(Orders.[Count]) AS total_orders,
         ROW_NUMBER() OVER(PARTITION BY Orders.CustomerID 
                           ORDER BY SUM(Orders.[Count]) DESC) AS row_num
  FROM Orders
  GROUP BY Orders.CustomerID, Orders.Vendor
)
SELECT CustomerVendorOrders.CustomerID, 
       CustomerVendorOrders.Vendor
FROM CustomerVendorOrders
WHERE CustomerVendorOrders.row_num = 1;

---5-task

DECLARE @Check_Prime INT = 91;
DECLARE @Counter INT = 2, @isPrime BIT = 1;

WHILE @Counter <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @Counter = 0
    BEGIN
        SET @isPrime = 0;
        BREAK;
    END
    SET @Counter = @Counter + 1;
END

IF @isPrime = 1 AND @Check_Prime > 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

	---6-task

	WITH LocationSignals AS (
  SELECT Device.Device_id, 
         Device.Locations,
         COUNT(*) AS signal_count
  FROM Device
  GROUP BY Device.Device_id, Device.Locations
),
DeviceSummary AS (
  SELECT LocationSignals.Device_id,
         COUNT(DISTINCT LocationSignals.Locations) AS no_of_location,
         SUM(LocationSignals.signal_count) AS no_of_signals,
         MAX(LocationSignals.signal_count) AS max_signal_count
  FROM LocationSignals
  GROUP BY LocationSignals.Device_id
)
SELECT LocationSignals.Device_id,
       DeviceSummary.no_of_location,
       LocationSignals.Locations AS max_signal_location,
       DeviceSummary.no_of_signals
FROM LocationSignals
JOIN DeviceSummary 
  ON LocationSignals.Device_id = DeviceSummary.Device_id
 AND LocationSignals.signal_count = DeviceSummary.max_signal_count;


 ---7-task
 SELECT Employee.EmpID,
       Employee.EmpName,
       Employee.Salary
FROM Employee
JOIN (
    SELECT DeptID, AVG(Salary) AS avg_salary
    FROM Employee
    GROUP BY DeptID
) AS DepartmentAverage
  ON Employee.DeptID = DepartmentAverage.DeptID
WHERE Employee.Salary > DepartmentAverage.avg_salary;

---8-taask

WITH TicketMatches AS (
  SELECT Tickets.TicketID,
         COUNT(DISTINCT Tickets.Number) AS ticket_numbers,
         SUM(CASE WHEN Numbers.Number IS NOT NULL THEN 1 ELSE 0 END) AS matched_numbers
  FROM Tickets
  LEFT JOIN Numbers
    ON Tickets.Number = Numbers.Number
  GROUP BY Tickets.TicketID
)
SELECT SUM(
           CASE 
             WHEN TicketMatches.matched_numbers = 3 THEN 100
             WHEN TicketMatches.matched_numbers > 0 THEN 10
             ELSE 0
           END
       ) AS total_winnings
FROM TicketMatches;

---9-task
WITH UserSpend AS (
  SELECT Spending.User_id, 
         Spending.Spend_date,
         SUM(CASE WHEN Spending.Platform = 'Mobile' THEN Spending.Amount ELSE 0 END) AS mobile_amount,
         SUM(CASE WHEN Spending.Platform = 'Desktop' THEN Spending.Amount ELSE 0 END) AS desktop_amount
  FROM Spending
  GROUP BY Spending.User_id, Spending.Spend_date
)
SELECT UserSpend.Spend_date,
       'Mobile' AS Platform,
       SUM(UserSpend.mobile_amount) AS Total_Amount,
       COUNT(CASE WHEN UserSpend.mobile_amount > 0 AND UserSpend.desktop_amount = 0 THEN 1 END) AS Total_users
FROM UserSpend
GROUP BY UserSpend.Spend_date

UNION ALL

SELECT UserSpend.Spend_date,
       'Desktop' AS Platform,
       SUM(UserSpend.desktop_amount) AS Total_Amount,
       COUNT(CASE WHEN UserSpend.desktop_amount > 0 AND UserSpend.mobile_amount = 0 THEN 1 END) AS Total_users
FROM UserSpend
GROUP BY UserSpend.Spend_date

UNION ALL

SELECT UserSpend.Spend_date,
       'Both' AS Platform,
       SUM(UserSpend.mobile_amount + UserSpend.desktop_amount) AS Total_Amount,
       COUNT(CASE WHEN UserSpend.mobile_amount > 0 AND UserSpend.desktop_amount > 0 THEN 1 END) AS Total_users
FROM UserSpend
GROUP BY UserSpend.Spend_date
ORDER BY Spend_date, Platform;

---10-task

WITH Numbers AS (
    SELECT 1 AS num UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6 UNION ALL
    SELECT 7 UNION ALL
    SELECT 8 UNION ALL
    SELECT 9 UNION ALL
    SELECT 10
)
SELECT Grouped.Product,
       1 AS Quantity
FROM Grouped
JOIN Numbers
  ON Numbers.num <= Grouped.Quantity
ORDER BY Grouped.Product;
