-- 1. Which products generate the highest revenue and profit? 

SELECT TOP 10
    Product_Name,
    Category,
    [Sub-Category],
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM superstore_database
GROUP BY
    Product_Name, Category, [Sub-Category]
ORDER BY
    Total_Sales DESC, Total_Profit DESC;


-- 2. What have monthly sales been like in recent years?

SELECT
    [Year],
    Month_Name,
    Month_Num,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM 
    superstore_database
WHERE 
    [Year] IS NOT NULL 
GROUP BY
    [Year], Month_Num, Month_Name
ORDER BY
    [Year] ASC, Month_Num ASC;

-- additional inquiry with distinction of the year for visualization

SELECT
    [Year],
    SUM(Sales) AS Sales_by_Year,
    SUM(Profit) AS Profit_by_Year,
    COUNT(DISTINCT Order_ID) AS Orders_by_Year
FROM 
    superstore_database
WHERE 
    [Year] IS NOT NULL
GROUP BY
    [Year]
ORDER BY
    [Year] DESC;

-- 3. Which regions are the most profitable, and which have the lowest profits?

SELECT
    Region,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Avg_Profit_Margin
FROM 
    superstore_database
WHERE 
    Region IS NOT NULL
GROUP BY
    Region
ORDER BY
    Total_Profit DESC;

-- 4. Is there a correlation between discounts and profit?

SELECT
    Is_Discounted,
    COUNT(*) AS Total_Transactions,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Avg_Profit_Margin
FROM 
    superstore_database
WHERE
    Is_Discounted IS NOT NULL
GROUP BY
    Is_Discounted;

-- 5. Which customer segments generate the most profit?

SELECT
    Segment,
    SUM(Sales) AS Segment_Sales,
    SUM(Profit) AS Segment_Profit,
    COUNT(DISTINCT Customer_ID) AS Total_Customers_in_Segment,
    SUM(Profit) / COUNT(DISTINCT Customer_ID) AS Avg_Profit_Per_Customer
FROM 
    superstore_database
WHERE 
    Segment IS NOT NULL
GROUP BY
    Segment
ORDER BY
    Segment_Profit DESC;


-- 6. Does faster shipping affect profitability?

SELECT
    Lead_Speed,
    AVG(Lead_Time) AS Avg_Delivery_Time_Days,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    AVG(Profit_Margin) AS Avg_Profit_Margin
FROM superstore_database
GROUP BY
    Lead_Speed
ORDER BY
    Avg_Delivery_Time_Days ASC;

-- 7. Identification of products that have negative profit (or very low margins), which is crucial for assortment management.

SELECT
    Product_Name,
    Category,
    [Sub-Category],
    SUM(Profit) AS Total_Profit,
    SUM(Quantity) AS Total_Units_Sold
FROM superstore_database
WHERE
    Profit < 0
GROUP BY
    Product_Name, Category, [Sub-Category]
ORDER BY
    Total_Profit ASC;

-- additional query for general comparison:
SELECT
    COUNT(*) AS Total_Transactions,
    SUM(CASE WHEN Profit > 0 THEN 1 ELSE 0 END) AS Transactions_With_Profit,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS Transactions_With_Loss,
    SUM(CASE WHEN Profit = 0 THEN 1 ELSE 0 END) AS Transactions_Neutral,
    ROUND((SUM(CASE WHEN Profit > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 0) AS Percent_Transactions_With_Profit
FROM superstore_database;


-- 8. Analysis of the Impact of the City and State to determine the concentration of losses

SELECT TOP 10
    State,
    City,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    COUNT(Order_ID) AS Total_Orders
FROM 
    superstore_database
WHERE
    Profit < 0
GROUP BY
    State, City
ORDER BY
    Total_Profit ASC;