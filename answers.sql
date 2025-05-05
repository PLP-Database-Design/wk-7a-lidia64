/* Week 7 Assignment: Database Design and Normalization
Question 1: Achieving First Normal Form (1NF) */

/*-- Step 1: Create the original unnormalized ProductDetail table*/
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

* Step 2: Insert unnormalized data (comma-separated product list)*/
INSERT INTO ProductDetail(OrderID, CustomerName, Products)
VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

/* Step 3: Create temporary table to hold the normalized data (split products)*/
CREATE TEMPORARY TABLE SplitProducts AS
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
) numbers ON CHAR_LENGTH(Products)
    - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n - 1;

/* Step 4: View the 1NF-compliant result*/
SELECT * FROM SplitProducts;


/* Question 2: Achieving Second Normal Form (2NF)


 Step 1: Create the original OrderDetails table (already in 1NF)*/
CREATE TABLE OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

/* Step 2: Insert data into OrderDetails*/
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity)
VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

/* Step 3: Create Orders table (to remove partial dependency)*/
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

/*Step 4: Create OrderItems table with full functional dependency*/
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;

-- Step 5: View the normalized tables
SELECT * FROM Orders;
SELECT * FROM OrderItems;
