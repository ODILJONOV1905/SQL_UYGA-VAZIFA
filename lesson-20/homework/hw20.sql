use homework20

---task1

SELECT DISTINCT S1.CustomerName
FROM #Sales S1
WHERE EXISTS (
    SELECT 1
    FROM #Sales S2
    WHERE S2.CustomerName = S1.CustomerName
      AND MONTH(S2.SaleDate) = 3
      AND YEAR(S2.SaleDate) = 2024
);

---task2
SELECT Product
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRevenue)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRevenue
        FROM #Sales
        GROUP BY Product
    ) AS X
);


--task3
SELECT MAX(SaleAmount) AS SecondHighestSale
FROM (
    SELECT DISTINCT (Quantity * Price) AS SaleAmount
    FROM #Sales
) AS T
WHERE SaleAmount < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

---task4
SELECT SaleMonth, SUM(Quantity) AS TotalQuantity
FROM (
    SELECT MONTH(SaleDate) AS SaleMonth, Quantity
    FROM #Sales
) AS X
GROUP BY SaleMonth
ORDER BY SaleMonth;


---task5
SELECT DISTINCT S1.CustomerName
FROM #Sales S1
WHERE EXISTS (
    SELECT 1
    FROM #Sales S2
    WHERE S1.CustomerName <> S2.CustomerName
      AND S1.Product = S2.Product
);


---task6
SELECT Name,
       SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
       SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
       SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name;

---task7
WITH RecursiveFamily AS (
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    SELECT R.PID, F.ChildID
    FROM RecursiveFamily R
    JOIN Family F ON R.CHID = F.ParentID
)
SELECT PID, CHID
FROM RecursiveFamily
ORDER BY PID, CHID;

---task8
SELECT O2.CustomerID, O2.OrderID, O2.DeliveryState, O2.Amount
FROM #Orders O2
WHERE O2.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders O1
      WHERE O1.CustomerID = O2.CustomerID
        AND O1.DeliveryState = 'CA'
  )
ORDER BY O2.CustomerID, O2.OrderID;


---task9
UPDATE #residents
SET fullname = CONCAT('name=', SUBSTRING(address, CHARINDEX('name=', address)+5, 
                       CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)+5) - (CHARINDEX('name=', address)+5)))
WHERE fullname IS NULL
  AND CHARINDEX('name=', address) > 0;

  ---task10
  WITH RoutesCTE AS (
    SELECT CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route, 
           ArrivalCity, 
           Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    
    UNION ALL
    
    SELECT CAST(R.Route + ' - ' + R2.ArrivalCity AS VARCHAR(MAX)),
           R2.ArrivalCity,
           R.Cost + R2.Cost
    FROM RoutesCTE R
    JOIN #Routes R2 ON R.ArrivalCity = R2.DepartureCity
)
SELECT Route, Cost
FROM RoutesCTE
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost;
