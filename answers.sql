-- Question 1: Achieving 1NF

-- Create a temporary table to hold the split products
CREATE TEMPORARY TABLE SplitProducts AS
SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM
    ProductDetail
CROSS JOIN
    (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) AS numbers -- Adjust the number of unions based on the maximum number of products in a row
WHERE
    SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1) <> '';

-- Select the results from the temporary table
SELECT
    OrderID,
    CustomerName,
    Product
FROM
    SplitProducts;

-- Optionally, drop the temporary table if you don't need it anymore
-- DROP TEMPORARY TABLE SplitProducts;

/*
Explanation:
The Products column contains multiple values, violating 1NF.  This query splits the comma-separated product list into individual rows, ensuring each row has a single product.  A temporary table is used to store the intermediate result. The CROSS JOIN with the numbers table is a common technique to generate the rows needed for splitting.  TRIM removes extra spaces.
*/

-- Question 2: Achieving 2NF

-- Create table Customers
CREATE TEMPORARY TABLE Customers AS
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Create table OrderProducts
CREATE TEMPORARY TABLE OrderProducts AS
SELECT OrderID, Product, Quantity
FROM OrderDetails;

-- Select from Customers and OrderProducts
SELECT * FROM Customers;
SELECT * FROM OrderProducts;

/*
Explanation:
The original OrderDetails table has a partial dependency: CustomerName depends only on OrderID, not on the full primary key (OrderID, Product).  To achieve 2NF, we decompose the table.  The Customers table stores OrderID and CustomerName, eliminating the partial dependency.  The OrderProducts table stores OrderID, Product, and Quantity.
*/
