CREATE DATABASE Walmart_sales;
SELECT * FROM walmart_sales
LIMIT 10;

-- TASKS

-- 1.  Find the total number of records in the walmart_sales table.
-- 2. Calculate the total weekly sales across all stores.
-- 3. Calculate the average weekly sales.
-- 4. Find the highest and lowest weekly sales in the dataset.
-- 5. Find the earliest and latest sales dates.
-- 6. Calculate total sales for every store and identify the top 10 stores.
-- 7. Identify the 10 stores with the lowest total sales.
-- 8. Calculate the average weekly sales for every store and rank them from highest to lowest.
-- 9. Find the store and date associated with the highest single weekly sale.
-- 10. Compare total sales and number of weeks between holiday and non-holiday periods.
-- 11. Calculate total sales for each year and compare the years.
-- 12. Calculate total sales for each month across the entire dataset.
-- 13. Determine which month has the highest average weekly sales.
-- 14. Find the 10 highest-selling store/week combinations.
-- 15. Identify stores whose average weekly sales are higher than the overall average weekly sales.
-- 16. Rank all stores based on their total sales using a window function.
-- 17. Calculate what percentage of total company sales each store contributes.
-- 18. For every store, calculate how far its total sales are above or below the average store's total sales.
-- 19. Calculate the standard deviation of weekly sales for each store. Identify the stores with the highest sales volatility.
-- 20.Investigate whether temperature and weekly sales have a meaningful relationship. Calculate an appropriate correlation measure and interpret the result.

-- 1.  Find the total number of records in the walmart_sales table.
SELECT COUNT(*) AS total_records
 FROM walmart_sales;

-- 2. Calculate the total weekly sales across all stores.
SELECT SUM(weekly_sales) AS total_weekly_sales
FROM walmart_sales;


-- 3. Calculate the average weekly sales.
SELECT AVG(weekly_sales) AS avg_weekly_sales
FROM walmart_sales;

-- 4. Find the highest and lowest weekly sales in the dataset.
SELECT MAX(weekly_sales) FROM walmart_sales;
SELECT MIN(weekly_sales) FROM walmart_sales;

-- 5. Find the earliest and latest sales dates.
SELECT
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM walmart_sales;

-- 6. Calculate total sales for every store and identify the top 10 stores.
SELECT store, SUM(weekly_sales) AS total_sales
FROM walmart_sales
GROUP BY store
ORDER BY total_sales DESC
LIMIT 10;

-- 7. Identify the 10 stores with the lowest total sales.
SELECT store, SUM(weekly_sales) AS total_sales
FROM walmart_sales
GROUP BY store
ORDER BY total_sales
LIMIT 10;

-- 8. Calculate the average weekly sales for every store and rank them from highest to lowest.
SELECT store, AVG(weekly_sales) AS avg_weekly_sales, RANK() OVER (ORDER BY AVG(weekly_sales) DESC) AS sales_rank
FROM walmart_sales
GROUP BY store
ORDER BY avg_weekly_sales DESC;

-- 9. Find the store and date associated with the highest single weekly sale.
SELECT store, date, weekly_sales 
FROM walmart_sales
ORDER BY weekly_sales DESC
LIMIT 1;

-- 10. Compare total sales and number of weeks between holiday and non-holiday periods.
SELECT holiday_flag, ROUND(SUM(weekly_sales),2) AS total_sales, count(*) AS number_of_weeks
FROM walmart_sales
GROUP BY holiday_flag;

-- 11. Calculate total sales for each year and compare the years.
SELECT YEAR(STR_TO_DATE(date, '%d-%m-%Y')) AS sales_year, ROUND(SUM(weekly_sales),2) AS total_sales
FROM walmart_sales
GROUP BY sales_year
ORDER BY sales_year;

-- 12. Calculate total sales for each month across the entire dataset.
SELECT MONTHNAME(STR_TO_DATE(date,'%d-%m-%Y')) AS sales_month , ROUND(SUM(weekly_sales),2) AS total_sales
FROM walmart_sales
GROUP BY sales_month;


-- 13. Determine which month has the highest average weekly sales.
SELECT MONTHNAME(STR_TO_DATE(date,'%d-%m-%Y')) AS sales_month , ROUND(AVG(weekly_sales),2) AS total_sales
FROM walmart_sales
GROUP BY sales_month
ORDER BY total_sales DESC
LIMIT 1;

-- 14. Find the 10 highest-selling store/week combinations.
SELECT store, date, ROUND(weekly_sales,0) AS total_sales
FROM walmart_sales
ORDER BY total_sales DESC
LIMIT 10;


-- 15. Identify stores whose average weekly sales are higher than the overall average weekly sales.
SELECT store,  ROUND(AVG(weekly_sales),0) AS average_weekly_sales
FROM walmart_sales
GROUP BY store
HAVING average_weekly_sales > (SELECT AVG(weekly_sales) FROM walmart_sales)
ORDER BY average_weekly_sales;

-- 16. Rank all stores based on their total sales using a window function.
SELECT 
    store,
    ROUND(SUM(weekly_sales), 0) AS total_sales,
    RANK() OVER (ORDER BY SUM(weekly_sales) DESC) AS sales_rank
FROM walmart_sales
GROUP BY store
ORDER BY sales_rank ASC;

-- 17. Calculate what percentage of total company sales each store contributes.
SELECT store, 
    ROUND(SUM(weekly_sales),0) AS total_sales, 
    ROUND((SUM(weekly_sales) / SUM(SUM(weekly_sales)) OVER()) * 100, 2) AS percentage_contribution 
FROM walmart_sales 
GROUP BY store;

-- USAGE OF CTE(common table expression)
-- 18. For every store, calculate how far its total sales are above or below the average store's total sales.	
WITH store_sales AS (
    SELECT store, ROUND(SUM(weekly_sales),0) AS total_sales
    FROM walmart_sales
    GROUP BY store
)
SELECT
    store,
    total_sales,
    ROUND(total_sales - AVG(total_sales) OVER (),0) AS difference_from_avg
FROM store_sales
ORDER BY difference_from_avg DESC;

-- 19. Calculate the standard deviation of weekly sales for each store. Identify the stores with the highest sales volatility.
SELECT store, ROUND(AVG(weekly_sales), 0) AS avg_sales,
    ROUND(STDDEV(weekly_sales), 0) AS sales_stddev
FROM walmart_sales
GROUP BY store
ORDER BY sales_stddev DESC;
