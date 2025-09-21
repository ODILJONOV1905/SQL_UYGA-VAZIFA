use homework2
---oson
CREATE TABLE Employees (
    EmpID INT,
    Name VARCHAR(50),
    Salary DECIMAL(10,2)
);

-- Bitta yozuv qo‘shish
INSERT INTO Employees (EmpID, Name, Salary)
VALUES (1, 'Ali', 5000.00);

-- Ikkinchi yozuv (to‘liq ustunlarni ko‘rsatmasdan)
INSERT INTO Employees
VALUES (2, 'Vali', 6000.00);

-- Ko‘p qator qo‘shish
INSERT INTO Employees (EmpID, Name, Salary)
VALUES 
(3, 'Dilshod', 5500.00),
(4, 'Gulbahor', 6200.00);

UPDATE Employees
SET Salary = 7000
WHERE EmpID = 1;
DELETE FROM Employees
WHERE EmpID = 2;

ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100);
ALTER TABLE Employees
ADD Department VARCHAR(50);

ALTER TABLE Employees
ALTER COLUMN Salary FLOAT;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

TRUNCATE TABLE Employees;

---Orta
INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'HR' UNION ALL
SELECT 2, 'Finance' UNION ALL
SELECT 3, 'IT' UNION ALL
SELECT 4, 'Marketing' UNION ALL
SELECT 5, 'Logistics';

UPDATE Employees
SET Department = 'Management'
WHERE Salary > 5000;

TRUNCATE TABLE Employees;

ALTER TABLE Employees
DROP COLUMN Department;

EXEC sp_rename 'Employees', 'StaffMembers';

EXEC sp_rename 'Employees', 'StaffMembers';

---qiyin

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Supplier VARCHAR(50)
);

ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

ALTER TABLE Products
ADD StockQuantity INT DEFAULT 50;

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Supplier)
VALUES
(1, 'Laptop', 'Electronics', 1200.00, 'HP'),
(2, 'Phone', 'Electronics', 800.00, 'Samsung'),
(3, 'Shoes', 'Fashion', 150.00, 'Nike'),
(4, 'Watch', 'Accessories', 200.00, 'Casio'),
(5, 'Book', 'Stationery', 25.00, 'O‘qituvchi');

INSERT INTO Products (ProductID, ProductName, ProductCategory, Price, Supplier)
VALUES
(1, 'Laptop', 'Electronics', 1200.00, 'HP'),
(2, 'Phone', 'Electronics', 800.00, 'Samsung'),
(3, 'Shoes', 'Fashion', 150.00, 'Nike'),
(4, 'Watch', 'Accessories', 200.00, 'Casio'),
(5, 'Book', 'Stationery', 25.00, 'O‘qituvchi');

EXEC sp_rename 'Products', 'Inventory';

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT;

ALTER TABLE Inventory
ADD ProductCode INT IDENTITY(1000,5);

