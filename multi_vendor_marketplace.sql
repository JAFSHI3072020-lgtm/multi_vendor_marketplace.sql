-- =========================================
-- MULTI-VENDOR SAAS MARKETPLACE DATABASE
-- =========================================

-- =========================================
-- PART B: SQL DDL (CREATE TABLE)
-- =========================================

-- Create SubscriptionPlan table
CREATE TABLE SubscriptionPlan (
    PlanID INT PRIMARY KEY AUTO_INCREMENT,
    PlanName VARCHAR(100),
    MonthlyFee DECIMAL(10,2),
    ProductListingLimit INT,
    CommissionPercentage DECIMAL(5,2),
    Features VARCHAR(255)
);

-- Create Vendor table
CREATE TABLE Vendor (
    VendorID INT PRIMARY KEY AUTO_INCREMENT,
    BusinessName VARCHAR(150) NOT NULL,
    OwnerName VARCHAR(150),
    Email VARCHAR(150) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    BusinessAddress VARCHAR(255),
    VATNumber VARCHAR(50),
    JoinDate DATE,
    AccountStatus ENUM('Active','Suspended') DEFAULT 'Active',
    PlanID INT,
    FOREIGN KEY (PlanID) REFERENCES SubscriptionPlan(PlanID)
);

-- Create Warehouse table
CREATE TABLE Warehouse (
    WarehouseID INT PRIMARY KEY AUTO_INCREMENT,
    VendorID INT,
    WarehouseName VARCHAR(150),
    Location VARCHAR(150),
    Capacity INT,
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);

-- Create Product table
CREATE TABLE Product (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    VendorID INT,
    ProductName VARCHAR(150),
    Brand VARCHAR(100),
    BasePrice DECIMAL(10,2),
    Description TEXT,
    Status ENUM('Active','Inactive'),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);

-- Create ProductVariation table
CREATE TABLE ProductVariation (
    VariationID INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT NOT NULL,
    Size VARCHAR(50),
    Color VARCHAR(50),
    AdditionalPrice DECIMAL(10,2) DEFAULT 0,
    SKU VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- Create Category table
CREATE TABLE Category (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100),
    Description VARCHAR(255)
);

-- Create ProductCategory junction table
CREATE TABLE ProductCategory (
    ProductID INT,
    CategoryID INT,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

-- Create Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(150),
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(20),
    Address VARCHAR(255),
    RegistrationDate DATE,
    Status VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    OrderStatus ENUM('Pending','Confirmed','Shipped','Delivered','Cancelled'),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create OrderItem table
CREATE TABLE OrderItem (
    OrderItemID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    VariationID INT,
    VendorID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Subtotal DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID),
    FOREIGN KEY (VendorID) REFERENCES Vendor(VendorID)
);

-- Create Payment table (1:1 with Orders)
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT UNIQUE,
    PaymentMethod ENUM('Card','Bkash','Nagad','PayPal','COD'),
    Amount DECIMAL(10,2),
    PaymentDate DATE,
    PaymentStatus ENUM('Pending','Paid','Failed','Refunded'),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Create Return table
CREATE TABLE ReturnRequest (
    ReturnID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    VariationID INT,
    Reason VARCHAR(255),
    ReturnStatus ENUM('Requested','Approved','Rejected','Refunded'),
    RequestDate DATE,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID)
);

-- Create WarehouseStock table
CREATE TABLE WarehouseStock (
    WarehouseID INT,
    VariationID INT,
    Quantity INT DEFAULT 0,
    PRIMARY KEY (WarehouseID, VariationID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID),
    FOREIGN KEY (VariationID) REFERENCES ProductVariation(VariationID)
);

-- =========================================
-- PART C: SQL DML
-- =========================================

-- Q9: Insert Standard subscription plan
INSERT INTO SubscriptionPlan
(PlanName, MonthlyFee, ProductListingLimit, CommissionPercentage, Features)
VALUES ('Standard', 3000, 200, 8, 'Standard features');

-- Q10: Insert vendor TechZone Ltd.
INSERT INTO Vendor
(BusinessName, OwnerName, Email, Phone, BusinessAddress, VATNumber, JoinDate, AccountStatus, PlanID)
VALUES
('TechZone Ltd.', 'Rahim Uddin', 'techzone@email.com',
 '01700000000', 'Dhaka, Bangladesh', 'VAT12345',
 CURDATE(), 'Active', 1);

-- Q11: Insert product Smartphone
INSERT INTO Product
(VendorID, ProductName, Brand, BasePrice, Description, Status)
VALUES
(1, 'Smartphone', 'TechBrand', 25000,
 'Latest smartphone device', 'Active');

-- Q12: Insert variation for Smartphone
INSERT INTO ProductVariation
(ProductID, Size, Color, AdditionalPrice, SKU)
VALUES
(1, '128GB', 'Black', 0, 'SP128B');

-- Q13: Update stock in Dhaka warehouse
INSERT INTO WarehouseStock (WarehouseID, VariationID, Quantity)
VALUES (1, 1, 25)
ON DUPLICATE KEY UPDATE Quantity = 25;

-- Q14: Delete inactive customers
DELETE FROM Customer
WHERE Status = 'Inactive';

-- =========================================
-- PART D: SQL QUERIES
-- =========================================

-- Q15: Display vendors with their plan name and commission
SELECT v.BusinessName, sp.PlanName, sp.CommissionPercentage
FROM Vendor v
JOIN SubscriptionPlan sp ON v.PlanID = sp.PlanID;

-- Q16: Show products with total stock
SELECT p.ProductName, SUM(ws.Quantity) AS TotalStock
FROM Product p
JOIN ProductVariation pv ON p.ProductID = pv.ProductID
JOIN WarehouseStock ws ON pv.VariationID = ws.VariationID
GROUP BY p.ProductName;

-- Q17: Orders in last 30 days
SELECT *
FROM Orders
WHERE OrderDate >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Q18: Top 5 best-selling variations
SELECT VariationID, SUM(Quantity) AS TotalSold
FROM OrderItem
GROUP BY VariationID
ORDER BY TotalSold DESC
LIMIT 5;

-- Q19: Customers who requested returns
SELECT DISTINCT c.*
FROM Customer c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN ReturnRequest r ON o.OrderID = r.OrderID;

-- Q20: Delivered orders but payment not Paid
SELECT o.OrderID, o.OrderStatus, p.PaymentStatus
FROM Orders o
JOIN Payment p ON o.OrderID = p.OrderID
WHERE o.OrderStatus = 'Delivered'
AND p.PaymentStatus <> 'Paid';

-- =========================================
-- PART E: ADVANCED SQL
-- =========================================

-- Q21: Total revenue per vendor
SELECT VendorID, SUM(Subtotal) AS TotalRevenue
FROM OrderItem
GROUP BY VendorID;

-- Q22: Customers who purchased from more than two vendors
SELECT o.CustomerID
FROM Orders o
JOIN OrderItem oi ON o.OrderID = oi.OrderID
GROUP BY o.CustomerID
HAVING COUNT(DISTINCT oi.VendorID) > 2;

-- Q23: Monthly sales summary for current year
SELECT MONTH(OrderDate) AS Month, SUM(TotalAmount) AS MonthlySales
FROM Orders
WHERE YEAR(OrderDate) = YEAR(CURDATE())
GROUP BY MONTH(OrderDate);

-- Q24: Vendors who exceeded product listing limit
SELECT v.VendorID, v.BusinessName
FROM Vendor v
JOIN SubscriptionPlan sp ON v.PlanID = sp.PlanID
JOIN Product p ON v.VendorID = p.VendorID
GROUP BY v.VendorID, v.BusinessName, sp.ProductListingLimit
HAVING COUNT(p.ProductID) > sp.ProductListingLimit;

-- Q25: Rank vendors based on total sales using CTE
WITH VendorSales AS (
    SELECT VendorID, SUM(Subtotal) AS TotalSales
    FROM OrderItem
    GROUP BY VendorID
)
SELECT VendorID, TotalSales,
       RANK() OVER (ORDER BY TotalSales DESC) AS SalesRank
FROM VendorSales;
