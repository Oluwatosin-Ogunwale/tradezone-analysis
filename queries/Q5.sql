-- ===================================================================================
-- Question 5: Customer Spend Segmentation
-- Segment customers based on their total spend in 2024 into three groups:
-- High Spenders: ≥ ₦100,000
-- Medium Spenders: ₦50,000 – ₦99,999
-- Low Spenders: < ₦50,000
-- For each group, calculate the customer count, average spend per customer and total 
-- revenue contribution.
-- =======================================================================================


WITH customer_spend AS (
    SELECT 
        customer_id,
        SUM(total_amount) AS total_spend_2024
    FROM orders
    WHERE order_date >= '2024-01-01' AND order_date < '2025-01-01'
    GROUP BY customer_id
)
SELECT 
    CASE 
        WHEN total_spend_2024 >= 100000 THEN 'High Spenders'
        WHEN total_spend_2024 >= 50000  THEN 'Medium Spenders'
        ELSE 'Low Spenders'
    END AS segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_spend_2024), 2) AS avg_spend,
    ROUND(SUM(total_spend_2024), 2) AS total_revenue,
    ROUND(100.0 * SUM(total_spend_2024) / SUM(SUM(total_spend_2024)) OVER (), 2) AS revenue_share_pct
FROM customer_spend
GROUP BY segment
ORDER BY total_revenue DESC;

-- 591 high spenders, 31 medium spenders and 55 low spenders