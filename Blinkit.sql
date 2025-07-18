-- =======================================
-- A. DATA INSPECTION
-- =======================================

-- View all data
SELECT * FROM Blinkit;

-- Check total number of records
SELECT COUNT(*) AS Total_Records FROM Blinkit;

-- View unique values in Fat Content (before cleaning)
SELECT DISTINCT Item_Fat_Content FROM Blinkit;


-- =======================================
-- B. DATA CLEANING
-- =======================================

-- Standardize Fat Content values
UPDATE Blinkit
SET Item_Fat_Content = CASE 
    WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
    WHEN Item_Fat_Content = 'reg' THEN 'Regular'
    ELSE Item_Fat_Content
END;

-- Verify cleaned values
SELECT DISTINCT Item_Fat_Content FROM Blinkit;


-- =======================================
-- C. KPIs
-- =======================================

-- 1. Total Sales in Millions
SELECT ROUND(SUM(Sales)/1000000, 2) AS Total_Sales_Millions FROM Blinkit;

-- 2. Average Sales per Item
SELECT ROUND(AVG(Sales), 2) AS Avg_Sales FROM Blinkit;

-- 3. Total Number of Items
SELECT COUNT(*) AS No_Of_Items FROM Blinkit;

-- 4. Average Customer Rating
SELECT ROUND(AVG(Rating), 2) AS Avg_Rating FROM Blinkit;

-- =======================================
-- D. CATEGORY-WISE PERFORMANCE INSIGHTS
-- =======================================

-- 1. All Metrics by Fat Content
SELECT 
    Item_Fat_Content,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Item_Fat_Content
ORDER BY Total_Sales DESC;


-- 2. All Metrics by Item Type
SELECT 
    Item_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Item_Type
ORDER BY Total_Sales DESC;


-- 3. Fat Content Sales by Outlet Location
SELECT 
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END), 2) AS Low_Fat_Sales,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END), 2) AS Regular_Sales
FROM Blinkit
GROUP BY Outlet_Location_Type
ORDER BY Outlet_Location_Type;


-- 4. All Metrics by Outlet Establishment Year
SELECT 
    Outlet_Establishment_Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;


-- 5. Sales and Share Percentage by Outlet Size
SELECT
    Outlet_Size,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage
FROM Blinkit
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;


-- 6. All Metrics by Outlet Location
SELECT
    Outlet_Location_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;


-- 7. All Metrics by Outlet Type
SELECT
    Outlet_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;


-- 8. Top 10 Products by Total Sales
SELECT TOP 10
    Item_Identifier,
    Item_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Sales), 2) AS Avg_Sales,
    COUNT(*) AS Sale_Count
FROM Blinkit
GROUP BY Item_Identifier, Item_Type
ORDER BY Total_Sales DESC;


-- 9. Top 10 Rated Products (Min 5 Ratings)
SELECT TOP 10
    Item_Identifier,
    Item_Type,
    ROUND(AVG(Rating), 2) AS Avg_Rating,
    COUNT(Rating) AS No_Of_Ratings
FROM Blinkit
WHERE Rating IS NOT NULL
GROUP BY Item_Identifier, Item_Type
HAVING COUNT(Rating) >= 5
ORDER BY Avg_Rating DESC;


-- 10. Sales by Fat Content and Item Type
SELECT 
    Item_Fat_Content,
    Item_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM Blinkit
GROUP BY Item_Fat_Content, Item_Type
ORDER BY Item_Fat_Content, Total_Sales DESC;


-- 11. Rating Distribution (Grouped)
SELECT 
    FLOOR(Rating) AS Rating_Band,
    COUNT(*) AS No_Of_Records
FROM Blinkit
WHERE Rating IS NOT NULL
GROUP BY FLOOR(Rating)
ORDER BY Rating_Band DESC;

-- 12. Items with No or Missing Ratings
SELECT 
    Item_Identifier,
    COUNT(*) AS No_Of_Records
FROM Blinkit
WHERE Rating IS NULL OR Rating = 0
GROUP BY Item_Identifier;

-- 13. Best Performing Outlet by Sales
SELECT TOP 1
    Outlet_Identifier,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM Blinkit
GROUP BY Outlet_Identifier
ORDER BY Total_Sales DESC;

-- 14. Rating vs Sales Correlation (Grouped)
SELECT 
    FLOOR(Rating) AS Rating_Band,
    ROUND(AVG(Sales), 2) AS Avg_Sales
FROM Blinkit
WHERE Rating IS NOT NULL
GROUP BY FLOOR(Rating)
ORDER BY Rating_Band DESC;

-- 15. Sales Contribution by Item Type (%)
SELECT 
    Item_Type,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER(), 2) AS Sales_Percentage
FROM Blinkit
GROUP BY Item_Type
ORDER BY Sales_Percentage DESC;

-- 16. Outlet Type and Size Combination Metrics
SELECT 
    Outlet_Type,
    Outlet_Size,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(AVG(Rating), 2) AS Avg_Rating
FROM Blinkit
GROUP BY Outlet_Type, Outlet_Size
ORDER BY Total_Sales DESC;

-- 17. Fat Content Breakdown by Outlet Type
SELECT 
    Outlet_Type,
    Item_Fat_Content,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM Blinkit
GROUP BY Outlet_Type, Item_Fat_Content
ORDER BY Outlet_Type, Total_Sales DESC;

-- 18. Sales Trend by Establishment Year and Fat Content
SELECT 
    Outlet_Establishment_Year,
    Item_Fat_Content,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM Blinkit
GROUP BY Outlet_Establishment_Year, Item_Fat_Content
ORDER BY Outlet_Establishment_Year, Total_Sales DESC;

-- 19. Count of Items by Fat Content & Outlet Size
SELECT 
    Item_Fat_Content,
    Outlet_Size,
    COUNT(*) AS Item_Count
FROM Blinkit
GROUP BY Item_Fat_Content, Outlet_Size
ORDER BY Item_Count DESC;

-- 20. Item Types with Highest Avg Ratings (Min 10 Ratings)
SELECT TOP 10
    Item_Type,
    ROUND(AVG(Rating), 2) AS Avg_Rating,
    COUNT(*) AS Rating_Count
FROM Blinkit
WHERE Rating IS NOT NULL
GROUP BY Item_Type
HAVING COUNT(*) >= 10
ORDER BY Avg_Rating DESC;
