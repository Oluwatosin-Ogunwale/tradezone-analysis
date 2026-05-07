-- =====================================================================================
-- Question 4: Quarterly Revenue Trends
-- Compare quarterly revenue across 2023 and 2024. For each quarter, calculate 
-- total revenue, average order value and total number of orders. Identify which single 
-- quarter showed the strongest revenue growth from 2023 to 2024.
-- ======================================================================================
-- Question 4: Quarterly Revenue Trends
-- Quarterly comparison 2023 vs 2024 with growth rate.
-- Note: Revenue based on total_amount in orders (after mismatch flagging).

SELECT sum(total_amount)
FROM orders;
-- total revenue is 984689575.99
WITH quarterly AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(QUARTER FROM order_date) AS quarter,
        SUM(total_amount) AS total_revenue,
        COUNT(order_id) AS total_orders,
        ROUND(AVG(total_amount), 2) AS avg_order_value
    FROM orders
    WHERE order_date >= '2023-01-01' AND order_date < '2025-01-01'
    GROUP BY year, quarter
)
SELECT 
    year, quarter, total_revenue, total_orders, avg_order_value,
    LAG(total_revenue) OVER (PARTITION BY quarter ORDER BY year) AS prev_year_revenue,
    ROUND(100.0 * (total_revenue - LAG(total_revenue) OVER (PARTITION BY quarter ORDER BY year)) 
          / NULLIF(LAG(total_revenue) OVER (PARTITION BY quarter ORDER BY year), 0), 2) AS growth_pct
FROM quarterly
ORDER BY year, quarter;

-- Q1 in 2024 showed the most growth of 1544.12%
-- the total orders changed from 22-342 and even though the average order value has remained fairly stable
