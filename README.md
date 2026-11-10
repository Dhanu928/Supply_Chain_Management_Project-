# Supply Chain Management – End-to-End Data Analytics Project

## Project Overview

The **Supply Chain Management Analytics Project** is an end-to-end data analytics and business intelligence project focused on analyzing supply chain operations, sales performance, inventory levels, order fulfillment, and delivery efficiency.

The project uses **Microsoft Excel, MySQL, Power BI, and Tableau** to clean, transform, analyze, and visualize supply chain data.

The primary objective is to understand operational performance, monitor important business KPIs, identify delivery and inventory trends, and generate actionable insights that can support effective supply chain decision-making.

## Project Objectives

- Analyze overall sales revenue and order performance.
- Monitor order fulfillment and fill rate.
- Evaluate on-time, delayed, and slightly delayed deliveries.
- Analyze inventory availability and stock levels.
- Identify trends in customer orders and product demand.
- Compare sales performance across regions and cities.
- Evaluate shipping modes and delivery lead times.
- Develop interactive dashboards for supply chain performance monitoring.
- Convert raw operational data into meaningful business insights.

## Tools and Technologies Used

| Tool | Purpose |
|---|---|
| Microsoft Excel | Data cleaning, calculations, PivotTables, and initial dashboard development |
| MySQL | Data cleaning, SQL queries, joins, aggregations, and data validation |
| Power BI | Data modeling, DAX calculations, KPI development, and interactive dashboards |
| Tableau | Interactive visualizations, trend analysis, and business reporting |

## Dataset Description

The project uses a supply chain dataset containing information related to customer orders, products, inventory, and business operations.

The data is organized into fact and dimension tables to support structured analysis.

### Database Tables

**Fact Tables**

- Fact_Orders – Contains order-level information, revenue, order quantity, shipped quantity, delivery dates, delivery status, shipping mode, and fill rate.
- Fact_Inventory – Contains inventory information, product references, stock on hand, and inventory snapshot dates.

**Dimension Tables**

- Dim_Customer – Contains customer information, including region, country, and city.
- Dim_Product – Contains product-related information.
- Dim_Supplier – Contains supplier-related information, where available.
- Dim_Warehouse – Contains warehouse-related information, where available.

### Data Model

A dimensional data model was used to organize the dataset.

The fact tables store measurable business transactions and inventory information, while the dimension tables provide descriptive details for analysis.

This structure supports analysis across customers, products, suppliers, warehouses, and inventory.

## Project Workflow

### 1. Data Collection and Understanding

- Imported the supply chain dataset.
- Examined the structure of the available tables.
- Identified important business columns and data types.
- Understood relationships between fact and dimension tables.
- Identified key metrics required for business analysis.

### 2. Data Cleaning and Transformation – Excel

Microsoft Excel was used for initial data preparation and analysis.

Activities included:

- Identifying missing and duplicate values.
- Checking data consistency.
- Standardizing text and date formats.
- Validating numerical fields.
- Applying formulas for business calculations.
- Using PivotTables to summarize supply chain performance.
- Preparing structured data for dashboard development.

### 3. SQL Analysis and Data Cleaning – MySQL

MySQL was used to clean, validate, transform, and analyze the dataset.

Key activities included:

- Inspecting database tables and column structures.
- Checking missing and NULL values.
- Identifying duplicate records.
- Standardizing text values.
- Validating order quantities and shipped quantities.
- Checking date inconsistencies.
- Identifying unmatched customer and product references.
- Establishing relationships between fact and dimension tables.
- Performing JOIN operations.
- Using GROUP BY, ORDER BY, aggregate functions, and subqueries.

**Example SQL Queries**

**Total Orders**

```sql
SELECT
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM Fact_Orders;
```

**Total Sales Revenue**

```sql
SELECT
    ROUND(SUM(Revenue), 2) AS Total_Sales_Revenue
FROM Fact_Orders;
```

**On-Time Delivery Percentage**

```sql
SELECT
    ROUND(
        SUM(CASE
            WHEN Delivery_Status = 'On-Time'
            THEN 1 ELSE 0
        END) * 100.0 / COUNT(*), 2
    ) AS On_Time_Percentage
FROM Fact_Orders;
```

**Average Fill Rate**

```sql
SELECT
    ROUND(AVG(Fill_Rate_Pct), 2) AS Average_Fill_Rate
FROM Fact_Orders;
```

**Latest Inventory Stock**

```sql
SELECT
    SUM(Stock_On_Hand) AS Total_Stock
FROM Fact_Inventory
WHERE Snapshot_Date = (
    SELECT MAX(Snapshot_Date)
    FROM Fact_Inventory
);
```

**Orders by Customer Region**

```sql
SELECT
    c.Customer_Region,
    COUNT(DISTINCT o.Order_ID) AS Total_Orders
FROM Fact_Orders o
JOIN Dim_Customer c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Region
ORDER BY Total_Orders DESC;
```

**Sales by Customer City**

```sql
SELECT
    c.Customer_City,
    ROUND(SUM(o.Revenue), 2) AS Total_Sales
FROM Fact_Orders o
JOIN Dim_Customer c
    ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_City
ORDER BY Total_Sales DESC
LIMIT 5;
```

**Average Delivery Lead Time by Shipping Mode**

```sql
SELECT
    Ship_Mode,
    ROUND(
        AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)), 0
    ) AS Average_Lead_Time_Days
FROM Fact_Orders
GROUP BY Ship_Mode;
```

*Note: These queries are based on the column names used in the project SQL script. Confirm the table structure and data types before execution.*

### 4. KPI Development and Business Analysis

The project focused on monitoring important supply chain performance indicators.

**Key Performance Indicators**

1. Total Sales Revenue
2. Total Orders
3. On-Time Delivery Percentage
4. Order Fulfillment Rate
5. Average Fill Rate
6. Total Inventory Stock
7. Average Delivery Lead Time
8. Delayed Orders
9. Demand vs. Actual Shipped Quantity
10. Inventory Performance

**Important KPI Calculations**

**Order Fulfillment Rate**

The project calculated an order fulfillment rate of:

```text
0.846916666...
```

This is approximately 84.69% when expressed as a percentage.

**Fill Rate**

The Excel analysis produced a fill rate of 96.88%, while the reference dashboard displayed 96.78%.

These figures should be validated against the same underlying records and calculation logic before final reporting.

**On-Time Delivery Percentage**

```text
On-Time Delivery Percentage =
(On-Time Orders / Total Orders) × 100
```

**Average Delivery Lead Time**

```text
Average Lead Time =
Average of (Actual Delivery Date - Order Date)
```

### 5. Power BI Dashboard Development

Power BI was used to create an interactive dashboard for monitoring supply chain performance.

Key activities included:

- Importing cleaned datasets.
- Transforming data using Power Query.
- Creating relationships between fact and dimension tables.
- Developing calculated measures using DAX.
- Creating KPI cards and interactive charts.
- Analyzing delivery and order performance.
- Monitoring inventory and stock levels.
- Comparing actual demand with forecast demand.

**Dashboard Focus Areas**

- Sales revenue and order performance.
- Delivery status analysis.
- Order fulfillment and fill rate.
- Inventory stock analysis.
- Demand versus forecast demand.
- Customer and regional performance.
- Shipping mode and delivery trends.

### 6. Tableau Dashboard Development

Tableau was used to develop interactive visualizations and explore supply chain performance.

The analysis focused on:

- Order and delivery performance.
- Inventory and stock levels.
- Product performance.
- Customer and regional sales.
- Shipping and delivery trends.
- Demand and supply comparisons.

Interactive charts and filters helped present operational data in a clear and understandable format.

## Key Business Questions Explored

1. What is the total sales revenue generated?
2. How many orders were placed?
3. What percentage of orders were delivered on time?
4. How many orders were delayed or slightly delayed?
5. What is the order fulfillment rate?
6. What is the average fill rate?
7. What is the total stock available in the latest inventory snapshot?
8. Which customer regions generate the highest number of orders?
9. Which cities contribute the most sales?
10. Which shipping mode has the lowest average delivery lead time?
11. How does actual shipped quantity compare with total demand?
12. How can inventory and delivery performance be monitored more effectively?

## Key Challenges and Learning

During this project, I worked on understanding supply chain data, organizing multiple fact and dimension tables, developing business KPIs, and creating interactive dashboards.

Some of the key learning areas included:

- Handling missing and inconsistent data.
- Working with multiple related datasets.
- Understanding fact and dimension tables.
- Performing SQL joins and aggregations.
- Calculating supply chain KPIs.
- Validating business metrics across Excel and Power BI.
- Developing interactive dashboards.
- Interpreting operational trends and performance indicators.

## Skills Demonstrated

**Technical Skills**

- Microsoft Excel
- Advanced Excel
- MySQL
- SQL Queries
- Data Cleaning
- Data Transformation
- Power BI
- DAX
- Power Query
- Tableau
- Data Modeling
- Dashboard Development
- KPI Development

**Analytical Skills**

- Supply Chain Analytics
- Inventory Analysis
- Sales Analysis
- Order Fulfillment Analysis
- Delivery Performance Analysis
- Trend Analysis
- Business Reporting
- Data Validation
- Business Intelligence
- Data-Driven Decision-Making

## Project Outcome

The project provided practical experience in analyzing supply chain operations using multiple data analytics tools.

By combining Excel, MySQL, Power BI, and Tableau, I developed an understanding of how to clean and validate operational data, calculate business KPIs, analyze order and inventory performance, and present insights through interactive dashboards.

The project strengthened my practical knowledge of business data analysis and supply chain performance monitoring.

## Repository Structure

```text
Supply-Chain-Management-Analytics/
│
├── Dataset/
│   ├── Fact_Orders.csv
│   ├── Fact_Inventory.csv
│   ├── Dim_Customer.csv
│   ├── Dim_Product.csv
│   ├── Dim_Supplier.csv
│   └── Dim_Warehouse.csv
│
├── Excel/
│   └── Supply_Chain_Analysis.xlsx
│
├── SQL/
│   └── Supply_Chain_Queries.sql
│
├── PowerBI/
│   └── Supply_Chain_Dashboard.pbix
│
├── Tableau/
│   └── Supply_Chain_Dashboard.twbx
│
├── Images/
│   ├── Excel_Dashboard.png
│   ├── PowerBI_Dashboard.png
│   └── Tableau_Dashboard.png
│
└── README.md
```

*Update the folder names and filenames to match the files you actually upload. Do not include files that are not part of your project.*

## Conclusion

The Supply Chain Management Analytics Project demonstrates my ability to apply data analytics and business intelligence tools to operational business problems.

Through data cleaning, SQL analysis, KPI calculations, and dashboard development, I gained practical experience in analyzing sales, inventory, order fulfillment, and delivery performance.

This project reflects my ability to transform raw business data into meaningful insights that can support operational monitoring and informed business decisions.

---

**Project Category:** Data Analytics / Business Intelligence  
**Tools Used:** Microsoft Excel | MySQL | Power BI | Tableau  
**Domain:** Supply Chain Management  
**Focus Areas:** Sales Analytics | Inventory Management | Order Fulfillment | Delivery Performance | Business Reporting
