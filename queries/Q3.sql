-- ==============================================================================
-- Question 3: Seller Fulfilment Efficiency
-- Calculate the average time in hours between order placement and delivery for each seller.
-- Return the top 20 sellers with the fastest average fulfilment times among sellers who
-- have completed at least 20 orders. Include their total completed orders and average
-- customer rating.
-- =================================================================================
-- Note: Uses delivery_date - order_date. Flagged amount_mismatch orders are still included 
-- as they represent real fulfilled orders
-- delivery_date and order_date are DATE type (not timestamp).
-- We use (delivery_date - order_date) * 24 to calculate hours.
-- "order_status","Delivered", "Shipped", "Processing", "Returned", "Cancelled"

SELECT COUNT (DISTINCT seller_id)
FROM sellers;
-- 90 sellers in total

SELECT 
    s.seller_name,
    COUNT(DISTINCT o.order_id) AS total_completed_orders,
    ROUND(
        AVG( 
            CASE 
                WHEN o.delivery_date IS NOT NULL 
                 AND o.order_date IS NOT NULL 
                THEN (o.delivery_date - o.order_date) * 24 
                ELSE NULL 
            END
        )::numeric, 
    2) AS avg_fulfilment_hours,
    ROUND(AVG(r.rating)::numeric, 2) AS avg_customer_rating
FROM orders o
JOIN sellers s ON o.seller_id = s.seller_id
LEFT JOIN reviews r ON o.order_id = r.order_id 
                         AND r.invalid_rating = FALSE   -- Exclude the 5 invalid ratings found during cleaning
WHERE o.delivery_date IS NOT NULL 
  AND o.order_status IN ('Delivered')
GROUP BY s.seller_id, s.seller_name
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY avg_fulfilment_hours ASC -- fastest is smallest hours
LIMIT 20;
