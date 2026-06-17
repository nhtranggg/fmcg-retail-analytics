CREATE DATABASE fmcg_retail;
USE fmcg_retail;
CREATE TABLE categories (
CategoryID INT PRIMARY KEY,
CategoryName VARCHAR(45) NOT NULL
);
CREATE TABLE countries (
CountryID INT PRIMARY KEY,
CountryName VARCHAR(45) NOT NULL,
CountryCode VARCHAR(2)
);
CREATE TABLE cities (
CityID INT PRIMARY KEY,
CityName VARCHAR(45) NOT NULL,
Zipcode DECIMAL(5,0),
CountryID INT,
FOREIGN KEY (CountryID) REFERENCES countries (CountryID) ON DELETE CASCADE
);
CREATE TABLE customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(45),
MiddleInitial VARCHAR(1),
LastName VARCHAR(45),
CityID INT,
Address VARCHAR(90),
FOREIGN KEY (CityID) REFERENCES cities (CityID) ON DELETE SET NULL
);
CREATE TABLE employees (
EmployeeID INT PRIMARY KEY,
FirstName VARCHAR(45),
MiddleInitial VARCHAR(1),
LastName VARCHAR(45),
BirthDate DATE,
Gender VARCHAR(10),
CityID INT,
HireDate DATE,
FOREIGN KEY (CityID) REFERENCES cities (CityID) ON DELETE SET NULL
);
CREATE TABLE products (
ProductID INT PRIMARY KEY,
ProductName VARCHAR(45) NOT NULL,
Price DECIMAL(4,0),
CategoryID INT,
Class VARCHAR(15),
ModifyDate DATE,
Resistant VARCHAR(15),
IsAllergic VARCHAR(7),
VitalityDays DECIMAL(3,0),
FOREIGN KEY (CategoryID) REFERENCES categories (CategoryID) ON DELETE CASCADE
);
CREATE TABLE sales (
SalesID INT PRIMARY KEY,
SalesPersonID INT,
CustomerID INT,
ProductID INT, 
Quantity INT,
Discount DECIMAL(10,2),
TotalPrice DECIMAL(10,2) NOT NULL,
SalesDate DATETIME,
TransactionNumber VARCHAR(25),
FOREIGN KEY (SalesPersonID) REFERENCES employees (EmployeeID) ON DELETE SET NULL,
FOREIGN KEY (CustomerID) REFERENCES customers (CustomerID) ON DELETE SET NULL,
FOREIGN KEY (ProductID) REFERENCES products (ProductID) ON DELETE SET NULL
);
ALTER TABLE sales ADD INDEX idx_sales_date (SalesDate);
ALTER TABLE sales ADD INDEX idx_sales_customer (CustomerID);
ALTER TABLE sales ADD INDEX idx_sales_product (ProductID);
ALTER TABLE sales ADD INDEX idx_sales_person (SalesPersonID);
ALTER TABLE sales ADD INDEX idx_transaction (TransactionNumber);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(SalesID, SalesPersonID, CustomerID, ProductID, Quantity, Discount, TotalPrice, @SalesDate, TransactionNumber)
SET SalesDate = NULLIF(@SalesDate, '');
UPDATE sales s
JOIN products p ON s.ProductID = p.ProductID
SET s.TotalPrice = p.Price * s.Quantity * (1 - s.Discount);