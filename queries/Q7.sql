-- ====================================================================================
-- Question 7: Review Ratings and Sales Performance
-- Group products based on their average review rating into three categories:
-- High Rated: 4.0 and above
-- Mid Rated: 3.0 – 3.99
-- Low Rated: Below 3.0
-- For each category, calculate the product count, total revenue and average unit price.
-- Excludes the 5 invalid ratings using the invalid_rating flag added in cleaning.
-- ===============================================================================================

WITH product_ratings AS (
    SELECT 
        product_id,
        ROUND(AVG(rating)::numeric, 2) AS avg_rating
    FROM reviews
    WHERE rating IS NOT NULL 
      AND invalid_rating = FALSE
    GROUP BY product_id
),
product_performance AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.category,
        p.unit_price,
        COALESCE(pr.avg_rating, 0) AS avg_rating,
        SUM(oi.line_total) AS total_revenue
    FROM products p
    LEFT JOIN product_ratings pr ON p.product_id = pr.product_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category, p.unit_price, pr.avg_rating
)
SELECT 
    CASE 
        WHEN avg_rating >= 4.0 THEN 'High Rated'
        WHEN avg_rating >= 3.0 THEN 'Mid Rated'
        ELSE 'Low Rated'
    END AS rating_category,
    COUNT(DISTINCT product_id) AS product_count,
    ROUND(SUM(total_revenue), 2) AS total_revenue,
    ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM product_performance
GROUP BY rating_category
ORDER BY total_revenue DESC;