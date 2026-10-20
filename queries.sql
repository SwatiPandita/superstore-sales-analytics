-- Superstore Sales Analytics: SQL queries
-- Database: SQLite (DB Browser for SQLite) | Table: superstore (9,994 rows)

-- 1. Data quality check: missing values and row count
SELECT
  SUM(CASE WHEN Sales IS NULL OR Sales = '' THEN 1 ELSE 0 END) AS null_sales,
  SUM(CASE WHEN Profit IS NULL OR Profit = '' THEN 1 ELSE 0 END) AS null_profit,
  SUM(CASE WHEN Discount IS NULL OR Discount = '' THEN 1 ELSE 0 END) AS null_discount,
  COUNT(*) AS total_rows
FROM superstore;

-- 2. Profit by sub-category (CTE): finds the loss-making sub-categories
WITH sub AS (
  SELECT "Sub-Category" AS sub_cat,
         ROUND(SUM(Sales),0) AS sales,
         ROUND(SUM(Profit),0) AS profit,
         ROUND(AVG(Discount)*100,1) AS avg_discount
  FROM superstore
  GROUP BY 1
)
SELECT *, ROUND(profit*100.0/sales,1) AS margin_pct
FROM sub
ORDER BY profit ASC;

-- 3. Discount impact: profit by discount band
SELECT CASE WHEN Discount = 0 THEN '0%'
            WHEN Discount <= 0.2 THEN '1-20%'
            WHEN Discount <= 0.4 THEN '21-40%'
            ELSE '40%+' END AS discount_band,
       COUNT(*) AS lines,
       ROUND(SUM(Profit),0) AS profit,
       ROUND(SUM(Profit)*100.0/SUM(Sales),1) AS margin_pct
FROM superstore
GROUP BY 1
ORDER BY 1;

-- 4. Window function: most profitable category in each region
SELECT Region, Category, ROUND(SUM(Profit),0) AS profit,
       RANK() OVER (PARTITION BY Region ORDER BY SUM(Profit) DESC) AS rnk
FROM superstore
GROUP BY Region, Category;


-- 5. What-if: profit if discounts above 20% were capped at 20% (best case, assumes the same quantity sold)
WITH x AS (
  SELECT SUM(Profit) AS actual,
         SUM(CASE WHEN Discount > 0.2
                  THEN Sales / (1 - Discount) * 0.8 - (Sales - Profit)
                  ELSE Profit END) AS capped
  FROM superstore
)
SELECT ROUND(actual, 0) AS actual_profit,
       ROUND(capped, 0) AS profit_if_capped,
       ROUND(capped - actual, 0) AS gain,
       ROUND((capped - actual) * 100.0 / actual, 1) AS gain_pct
FROM x;
