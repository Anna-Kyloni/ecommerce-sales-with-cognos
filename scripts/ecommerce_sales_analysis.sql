-- ========================================================================
-- PROJECT: Global E-Commerce Sales & Customer Data Analytics
-- AUTHOR: Data Analyst Portfolio Piece
-- DATABASE: MySQL Server
-- ========================================================================

-- ------------------------------------------------------------------------
-- STEP 1: Database & Schema Creation (DDL)
-- ------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

DROP TABLE IF EXISTS ecommerce_sales;

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

-- ------------------------------------------------------------------------
-- STEP 2: Data Cleaning & Date Type Conversion
-- ------------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 0;

-- Convert Order_Date from raw string text to a native database DATE object
UPDATE ecommerce_sales
SET Order_Date = CASE
    WHEN Order_Date LIKE '%/%' THEN STR_TO_DATE(Order_Date, '%d/%m/%Y')
    WHEN Order_Date LIKE '%-%' THEN STR_TO_DATE(Order_Date, '%Y-%m-%d')
    ELSE Order_Date
END;

-- Modify the column structure to enforce standard DATE format
ALTER TABLE ecommerce_sales MODIFY COLUMN Order_Date DATE;

SET SQL_SAFE_UPDATES = 1;

-- ------------------------------------------------------------------------
-- STEP 3: Business Performance Queries (Insights for Cognos)
-- ------------------------------------------------------------------------

-- Query 1: Product Category Profitability
-- Purpose: Evaluates revenue vs net profit margins across broad product sectors.
SELECT 
    Product_Category, 
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue, 
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM ecommerce_sales 
GROUP BY Product_Category;


-- Query 2: Top Performing Countries
-- Purpose: Identifies the top 5 international markets by total transactional order volume.
SELECT 
    Country, 
    COUNT(Order_ID) AS Total_Orders 
FROM ecommerce_sales 
GROUP BY Country 
ORDER BY Total_Orders DESC 
LIMIT 5;


-- Query 3: Checkout Preferences by Customer Segment
-- Purpose: Analyzes payment method operational volume segmented across user types.
SELECT 
    Customer_Segment, 
    Payment_Method, 
    COUNT(*) AS Usage_Count 
FROM ecommerce_sales 
GROUP BY Customer_Segment, Payment_Method
ORDER BY Customer_Segment, Usage_Count DESC;