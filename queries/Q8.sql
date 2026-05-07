-- ==================================================================================
-- Question 8: Top Seller Bonus Qualification
-- Identify the top 10 sellers in 2024 by total revenue who completed at least 10 orders
-- and have an average customer rating of 4.0 or above. Include their total orders, 
-- average rating, and total revenue.
-- Question 8: Top Seller Bonus Qualification
-- Top 10 sellers in 2024 by revenue with ≥10 orders and avg rating ≥4.0
-- ====================================================================================
-- Note: Uses invalid_rating flag to exclude bad reviews from average.

WITH seller_stats AS (
    SELECT 
        s.seller_id,
        s.seller_name,
        SUM(o.total_amount) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(AVG(r.rating)::numeric, 2) AS avg_rating
    FROM orders o
    JOIN sellers s ON o.seller_id = s.seller_id
    LEFT JOIN reviews r ON o.order_id = r.order_id 
                             AND r.invalid_rating = FALSE
    WHERE o.order_date >= '2024-01-01' AND o.order_date < '2025-01-01'
    GROUP BY s.seller_id, s.seller_name
)
SELECT 
    seller_name,
    total_orders,
    avg_rating,
    ROUND(total_revenue, 2) AS total_revenue
FROM seller_stats
WHERE total_orders >= 10 
  AND avg_rating >= 4.0
ORDER BY total_revenue DESC
LIMIT 10;