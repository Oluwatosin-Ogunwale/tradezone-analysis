-- =============================================================================
-- Question 1: Customer Acquisition & 30-Day Conversion
-- Find the top 5 states by number of new customer sign-ups in 2024. For each state, 
-- calculate what percentage of these new customers made at least one purchase within 
-- their first 30 days of signing up.
-- ==============================================================================

WITH new_customers_2024 AS (
    SELECT customer_id, state, signup_date
    FROM customers
    WHERE signup_date >= '2024-01-01' AND signup_date < '2025-01-01'
),
first_purchase AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM orders
    GROUP BY customer_id
)
SELECT 
    nc.state,
    COUNT(DISTINCT nc.customer_id) AS new_customers,
    COUNT(DISTINCT CASE WHEN fp.first_order_date <= nc.signup_date + INTERVAL '30 days' 
                        THEN nc.customer_id END) AS converted_within_30d,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN fp.first_order_date <= nc.signup_date + INTERVAL '30 days' 
                                      THEN nc.customer_id END) 
          / NULLIF(COUNT(DISTINCT nc.customer_id), 0), 2) AS conversion_pct
FROM new_customers_2024 nc
LEFT JOIN first_purchase fp ON nc.customer_id = fp.customer_id
GROUP BY nc.state
ORDER BY new_customers DESC;

-- The 5 cities have conversion around 31% - 49 % within the first 30 days



