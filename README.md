========================================================================
GLOBAL E-COMMERCE DATA ANALYTICS & EXECUTIVE COGNOS DASHBOARD
========================================================================
Developed by: Kyloni Anna-Sofia


1. PROJECT OVERVIEW
-------------------
This project demonstrates an end-to-end data analytics pipeline. It covers initial data exploration in Excel, data cleaning and ingestion into a MySQL database, advanced SQL querying for business insights, and final interactive dashboard development using IBM Cognos Analytics.

2. DATA SOURCE & PREPARATION (EXCEL)
------------------------------------
- Data Source: Retrieved from Kaggle (Global E-Commerce Sales & Customer Data).
- Excel Auditing: Performed initial schema validation. Identified a column naming layout utilizing specific formatting (underscores), which was structurally aligned in SQL to prevent schema mismatch errors during ingestion.

3. DATABASE DESIGN & INGESTION (SQL)
------------------------------------
The "ecommerce_sales" table was constructed in MySQL with strict data types to ensure data integrity:

CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

CREATE TABLE ecommerce_sales (
    Order_ID VARCHAR(50) PRIMARY KEY,
    Order_Date VARCHAR(50),
    Customer_Name VARCHAR(150),
    Customer_Segment VARCHAR(100),
    Country VARCHAR(100),
    Region VARCHAR(100),
    Product_Category VARCHAR(100),
    Product_Name VARCHAR(255),
    Quantity INT,
    Unit_Price DECIMAL(10, 2),
    Discount_Percent DECIMAL(5, 2),
    Total_Sales DECIMAL(15, 2),
    Shipping_Cost DECIMAL(10, 2),
    Profit DECIMAL(15, 2),
    Payment_Method VARCHAR(50)
);

4. DATA CLEANING (VIA SQL)
--------------------------
Transaction dates were converted from raw strings (VARCHAR) into native database date objects (DATE) for accurate time-series analysis:

SET SQL_SAFE_UPDATES = 0;
UPDATE ecommerce_sales
SET Order_Date = CASE
    WHEN Order_Date LIKE '%/%' THEN STR_TO_DATE(Order_Date, '%d/%m/%Y')
    WHEN Order_Date LIKE '%-%' THEN STR_TO_DATE(Order_Date, '%Y-%m-%d')
    ELSE Order_Date
END;
ALTER TABLE ecommerce_sales MODIFY COLUMN Order_Date DATE;
SET SQL_SAFE_UPDATES = 1;

5. BUSINESS PERFORMANCE QUERIES (SQL)
-------------------------------------
- Query 1: Product Category Profitability
SELECT Product_Category, ROUND(SUM(Total_Sales), 2) AS Total_Revenue, ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales GROUP BY Product_Category;

- Query 2: Top Performing Countries
SELECT Country, COUNT(Order_ID) AS Total_Orders FROM ecommerce_sales GROUP BY Country ORDER BY Total_Orders DESC LIMIT 5;

- Query 3: Checkout Preferences by Customer Segment
SELECT Customer_Segment, Payment_Method, COUNT(*) AS Usage_Count FROM ecommerce_sales GROUP BY Customer_Segment, Payment_Method;

6. IBM COGNOS Analytics INTEGRATION & DASHBOARD LAYOUT
------------------------------------------------------
## 📊 Interactive Dashboard

You can explore the fully interactive IBM Cognos dashboard and test the filters live by clicking the link below:

👉 **[Launch Interactive Cognos Dashboard]https://us1.ca.analytics.ibm.com/bi/?perspective=dashboard&pathRef=.public_folders%2Fecommerce_project%2Fecommerce%2BProject&action=view&mode=dashboard&subView=model0000019e82e14dcb_00000000&nav_filter=true**

*Note: For the best user experience, it is recommended to view the dashboard on a desktop screen.*

- The database was exported as "cleaned_ecommerce_sales.csv" from MySQL Workbench and uploaded to Cognos.
- Built an interactive Executive Dashboard featuring:
  * KPI Cards: High-level metrics tracking Total Sales, Net Profit, and Quantities.
  * Clustered Column Chart: Comparing Revenue vs. Profit per Product Category (revealed Furniture drives volume, but Clothing yields a higher profit margin).
  * Choropleth Map: A geographical canvas tracking market penetration based on Country (darker shading over Mexico and USA due to higher order volumes).
  * Stacked Bar Chart: Displaying Payment Methods across Customer Segments. Since transaction count was not a native measure, Order_ID was dragged into the Value field and explicitly changed to a COUNT aggregation.

7. PORTFOLIO REVIEW
-------------------
Since IBM Cognos is an enterprise cloud environment, high-resolution screenshots of the complete dashboard canvas have been uploaded to the images/ directory for immediate evaluation.