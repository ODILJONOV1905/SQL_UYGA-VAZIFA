use homework3

---oson
1. BULK INSERT ta’rifi

BULK INSERT – tashqi fayllardan (masalan, .txt, .csv) ma’lumotlarni tezkor tarzda jadvalga import qilish uchun ishlatiladi.

2. SQL Server’ga import qilinadigan fayl formatlari

.csv (Comma Separated Values)

.txt (Text File)

.xls yoki .xlsx (Excel)

.xml (XML fayl)
3. CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (1, 'Laptop', 1200.00);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES (2, 'Phone', 800.00);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES (3, 'Book', 25.50);
-- Bu query barcha mahsulotlarni chiqaradi
SELECT * FROM Products;

ALTER TABLE Products
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- Bu query barcha mahsulotlarni chiqaradi
SELECT * FROM Products;

ALTER TABLE Products
ADD CategoryID INT;

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

---Ortacha

BULK INSERT Products
FROM 'C:\data\products.txt'
WITH (
    FIELDTERMINATOR = ',',  -- Ustun ajratgich
    ROWTERMINATOR = '\n',   -- Qator ajratgich
    FIRSTROW = 2            -- Birinchi qator sarlavha bo‘lsa
);

ALTER TABLE Products
ADD CONSTRAINT FK_Products_Categories
FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID);

ALTER TABLE Products
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

ALTER TABLE Products
ADD Stock INT NOT NULL DEFAULT 0;

SELECT ProductID, ProductName, ISNULL(Price, 0) AS Price
FROM Products;

---qiyin
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Age INT CHECK (Age >= 18)
);

CREATE TABLE TestIdentity (
    ID INT IDENTITY(100,10) PRIMARY KEY,
    ItemName VARCHAR(50)
);

CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

