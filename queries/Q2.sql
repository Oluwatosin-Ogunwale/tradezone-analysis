-- ================================================================================
-- Question 2: Product Performance
-- Identify the top 10 products by total revenue in 2024. Include product name,
-- category, total revenue and total number of orders. Sort by revenue descending.
-- ================================================================================
-- Note: Revenue uses line_total from order_items. 
--       97 rows had unit_price=0 (from 4 products with missing prices in products table).
--       Those orders still contribute 0 revenue here.


SELECT 
    p.product_name,
    p.category,
    SUM(oi.line_total) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= '2024-01-01' AND o.order_date < '2025-01-01'
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC
LIMIT 10;

-- Electronics category has the top 10 revenue generating products