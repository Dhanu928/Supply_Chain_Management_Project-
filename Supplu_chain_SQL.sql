CREATE DATABASE supply_chain;
USE supply_chain;

select * from dim_products;
select * from dim_supplier;
select * from dim_warehouses;
select * from dim_customers;
select * from fact_orders;
select * from fact_inventory;

RENAME TABLE supply_chain_dataset_diminventory TO dim_warehouses;
RENAME TABLE supply_chain_dataset_dimcustomers TO dim_customers;
RENAME TABLE supply_chain_dataset_dimsupplier TO dim_supplier;
RENAME TABLE supply_chain_product TO dim_products;
RENAME TABLE supply_chain_dataset_factorders TO fact_orders;
RENAME TABLE supply_chain_dataset_factinventory TO fact_inventory;

-- creating back up tables for cleaning the data

CREATE TABLE Fact_Orders_Backup AS
SELECT * FROM Fact_Orders;

CREATE TABLE Fact_Inventory_Backup AS
SELECT * FROM Fact_Inventory;

CREATE TABLE Dim_Product_Backup AS
SELECT * FROM Dim_Products;

CREATE TABLE Dim_Customer_Backup AS
SELECT * FROM Dim_Customers;

CREATE TABLE Dim_Supplier_Backup AS
SELECT * FROM Dim_Supplier;

CREATE TABLE Dim_Warehouse_Backup AS
SELECT * FROM Dim_Warehouses;

-- total check of the records

SELECT 'Fact_Orders' AS Table_Name, COUNT(*) AS Total_Records
FROM Fact_Orders

UNION ALL

SELECT 'Fact_Inventory', COUNT(*)
FROM Fact_Inventory

UNION ALL

SELECT 'Dim_Products', COUNT(*)
FROM Dim_Products

UNION ALL

SELECT 'Dim_Customers', COUNT(*)
FROM Dim_Customers

UNION ALL

SELECT 'Dim_Supplier', COUNT(*)
FROM Dim_Supplier

UNION ALL

SELECT 'Dim_Warehouses', COUNT(*)
FROM Dim_Warehouses;

 -- Identifying NULL and MISSING values in all the tables
 
 ALTER TABLE fact_orders
CHANGE COLUMN `ï»¿Order_ID` Order_ID VARCHAR(50);

 ALTER TABLE dim_supplier
CHANGE COLUMN `ï»¿Supplier_ID` Supplier_ID VARCHAR(50);
 
 SELECT
    COUNT(*) AS Total_Rows,
    SUM(Order_ID IS NULL) AS Missing_Order_ID,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Order_Date IS NULL) AS Missing_Order_Date,
    SUM(Revenue IS NULL) AS Missing_Revenue,
    SUM(Order_Quantity IS NULL) AS Missing_Order_Quantity,
    SUM(Shipped_Quantity IS NULL) AS Missing_Shipped_Quantity,
    SUM(Delivery_Status IS NULL) AS Missing_Delivery_Status,
    SUM(Ship_Mode IS NULL) AS Missing_Ship_Mode,
    SUM(Fill_Rate_Pct IS NULL) AS Missing_Fill_Rate
FROM Fact_Orders;

 -- fact inventory
 
 SELECT
    COUNT(*) AS Total_Rows,
    SUM(Product_ID IS NULL) AS Missing_Product_ID,
    SUM(Snapshot_Date IS NULL) AS Missing_Snapshot_Date,
    SUM(Stock_On_Hand IS NULL) AS Missing_Stock
FROM Fact_Inventory;

 -- Dim customers
 
 SELECT
    COUNT(*) AS Total_Rows,
    SUM(Customer_ID IS NULL) AS Missing_Customer_ID,
    SUM(Customer_Region IS NULL) AS Missing_Region,
    SUM(Customer_Country IS NULL) AS Missing_Country,
    SUM(Customer_City IS NULL) AS Missing_City
FROM Dim_Customers;

 -- 
 
 SELECT * FROM Dim_Products WHERE Product_ID IS NULL;

SELECT * FROM Dim_Supplier WHERE Supplier_ID IS NULL;

SELECT * FROM Dim_Warehouses WHERE Warehouse_ID IS NULL;

 ALTER TABLE dim_Warehouses
CHANGE COLUMN `ï»¿Warehouse_ID` Warehouse_ID VARCHAR(50);

select * from dim_customers;

 -- Checking for duplicate records
 
 SELECT
    Order_ID,
    COUNT(*) AS Duplicate_Count
FROM Fact_Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;

SELECT
    Customer_ID,
    COUNT(*) AS Duplicate_Count
FROM Dim_Customers
GROUP BY Customer_ID
HAVING COUNT(*) > 1;

SELECT
    Product_ID,
    COUNT(*) AS Duplicate_Count
FROM Dim_Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT
    Product_ID,
    Snapshot_Date,
    COUNT(*) AS Duplicate_Count
FROM Fact_Inventory
GROUP BY Product_ID, Snapshot_Date
HAVING COUNT(*) > 1;

 -- Removing unwanted spaces and standardize text
select * from fact_orders;

set sql_safe_updates=0;

UPDATE Fact_Orders
SET Delivery_Status = TRIM(Delivery_Status);

UPDATE Fact_Orders
SET Ship_Mode = TRIM(Ship_Mode);

UPDATE Dim_Customers
SET Customer_Region = TRIM(Customer_Region),
    Customer_Country = TRIM(Customer_Country),
    Customer_City = TRIM(Customer_City);
    
UPDATE Fact_Orders
SET Delivery_Status =
    CASE
        WHEN LOWER(TRIM(Delivery_Status)) IN
             ('on-time', 'on time', 'ontime')
            THEN 'On-Time'

        WHEN LOWER(TRIM(Delivery_Status)) IN
             ('delayed', 'late')
            THEN 'Delayed'

        WHEN LOWER(TRIM(Delivery_Status)) IN
             ('slightly delayed', 'slightly-delayed')
            THEN 'Slightly Delayed'

        ELSE Delivery_Status
    END;
    
SELECT
    Delivery_Status,
    COUNT(*) AS Total_Orders
FROM Fact_Orders
GROUP BY Delivery_Status;

 -- Checking date inconsistencies

SELECT *
FROM Fact_Orders
WHERE Order_Date IS NULL
   OR Actual_Delivery_Date IS NULL;
   
   SELECT *
FROM Fact_Orders
WHERE Actual_Delivery_Date < Order_Date;

SELECT *
FROM Fact_Orders
WHERE Actual_Delivery_Date < Order_Date;

SELECT *
FROM Fact_Orders
WHERE Order_Date > CURDATE()
   OR Actual_Delivery_Date > CURDATE();
   
SELECT
    MIN(Order_Date) AS First_Order_Date,
    MAX(Order_Date) AS Last_Order_Date,
    MIN(Actual_Delivery_Date) AS First_Delivery_Date,
    MAX(Actual_Delivery_Date) AS Last_Delivery_Date
FROM Fact_Orders;

 -- Identifying missing customers and product references
 
 SELECT o.*
FROM Fact_Orders o
LEFT JOIN Dim_Customers c
    ON o.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT o.*
FROM Fact_Orders o
LEFT JOIN Dim_Products p
    ON o.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

SELECT i.*
FROM Fact_Inventory i
LEFT JOIN Dim_Products p
    ON i.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;

 -- Checking and standardize dimension tables
 
 SELECT *
FROM Dim_Customers
WHERE Customer_ID IS NULL
   OR Customer_City IS NULL
   OR Customer_Country IS NULL
   OR Customer_Region IS NULL;
   
SELECT Product_ID, COUNT(*) AS Total
FROM Dim_Products
GROUP BY Product_ID
HAVING COUNT(*) > 1;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'supply_chain'
AND (
    (TABLE_NAME = 'Dim_Customers' AND COLUMN_NAME = 'Customer_ID')
    OR
    (TABLE_NAME = 'Fact_Orders' AND COLUMN_NAME = 'Customer_ID')
    OR
    (TABLE_NAME = 'Dim_Products' AND COLUMN_NAME = 'Product_ID')
    OR
    (TABLE_NAME = 'Fact_Orders' AND COLUMN_NAME = 'Product_ID')
    OR
    (TABLE_NAME = 'Fact_Inventory' AND COLUMN_NAME = 'Product_ID')
);

 -- Data validation
 
 SELECT COUNT(*) AS Total_Orders
FROM Fact_Orders;

SELECT COUNT(*) AS Total_Inventory_Records
FROM Fact_Inventory;

SELECT COUNT(*) AS Total_Customers
FROM Dim_Customers;

SELECT COUNT(*) AS Total_Products
FROM Dim_Products;

 -- latest inventory snapshot
 
 SELECT
    SUM(Stock_On_Hand) AS Total_Stock
FROM Fact_Inventory
WHERE Snapshot_Date = (
    SELECT MAX(Snapshot_Date)
    FROM Fact_Inventory
);

SELECT COUNT(DISTINCT Order_ID) AS Total_Orders 
FROM Fact_Orders;

SELECT concat(round(sum(Revenue)/1000000,2),'M') AS Total_Sales_Revenue 
FROM Fact_Orders;

SELECT concat(round((SUM(CASE WHEN Delivery_Status = 'On-Time' THEN 1 ELSE 0 END) / COUNT(*)) * 100,2),'%') AS On_Time_Pct 
FROM Fact_Orders;

SELECT SUM(Stock_On_Hand) AS Total_Stock
FROM Fact_Inventory 
WHERE Snapshot_Date = (SELECT MAX(Snapshot_Date) FROM Fact_Inventory);

SELECT round(avg(Fill_Rate_Pct),2) AS Avg_Fill_Rate 
FROM Fact_Orders;

SELECT c.Customer_Region, c.Customer_Country, c.Customer_City, COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM Fact_Orders o
JOIN Dim_Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Region, c.Customer_Country, c.Customer_City;

SELECT c.Customer_Region, COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM Fact_Orders o
JOIN Dim_Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Region;

SELECT Ship_Mode, COUNT(DISTINCT Order_ID) AS Total_Orders
FROM Fact_Orders
GROUP BY Ship_Mode;

SELECT c.Customer_City, round(sum(o.Revenue),0) AS Total_Sales
FROM Fact_Orders o
JOIN Dim_Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_City
ORDER BY Total_Sales DESC
LIMIT 5;

SELECT Ship_Mode, round(avg(DATEDIFF(Actual_Delivery_Date, Order_Date)),0) AS Avg_Lead_Time_Days
FROM Fact_Orders
GROUP BY Ship_Mode;

SELECT DATE_FORMAT(Order_Date, '%Y-%m') AS Order_Month, 
       SUM(Order_Quantity) AS Total_Demand,
       SUM(Shipped_Quantity) AS Actual_Shipped
FROM Fact_Orders
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY Order_Month;