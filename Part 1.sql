-- ========================================================
-- PART A: DATA CLEANING SCRIPT - TradeZone Database
-- HNG14-DA-S2
-- DATA ANALYTICS STAGE 2 TASK: SQL with Business Context.
-- =========================================================

-- =========================================================================
-- TO DO
-- Missing Values: Identify and handle NULL or blank entries in critical columns
-- Duplicate Records: Check for and remove duplicate rows in customers, sellers and orders. 
-- Inconsistent Formatting: Standardise city names. 
-- Ensure all date columns follow a consistent format (YYYY-MM-DD).
-- Normalise product category names to title case.
-- Data Validation: Verify that each order's total_amount matches the sum of its line items in order_items.
-- Flag orders where the difference is greater than ₦10. 
-- Check that all review ratings are between 1 and 5. 
-- Check for negative product prices or discount percentages above 100%.
-- ============================================================================

-- ============================================================
-- STEP 1: GET FULL TABLE DETAILS
-- Reason: To know exact table names, column names and data types
-- =============================================================

-- See all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
-- 7tables in total

-- 1. Customers table columns
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'customers' 
ORDER BY ordinal_position;

-- 2. Orders table columns
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'orders' 
ORDER BY ordinal_position;

-- 3. Order_items table columns
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'order_items' 
ORDER BY ordinal_position;

-- 4. Products table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'products' 
ORDER BY ordinal_position;

-- 5. Sellers table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sellers' 
ORDER BY ordinal_position;

-- 6. Reviews table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'reviews' 
ORDER BY ordinal_position; 

-- 7. Payments table
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'payments' 
ORDER BY ordinal_position;

-- ============================================================
-- STEP 2: CREATE CLEAN COPIES OF ALL TABLES
-- Reason: We never modify raw data directly. If our cleaning
-- decisions turn out to be wrong we can always go back to
-- the original tables and start again safely.
-- =============================================================

DROP TABLE IF EXISTS customers_clean;
DROP TABLE IF EXISTS orders_clean;
DROP TABLE IF EXISTS order_items_clean;
DROP TABLE IF EXISTS products_clean;
DROP TABLE IF EXISTS sellers_clean;
DROP TABLE IF EXISTS reviews_clean;
DROP TABLE IF EXISTS payments_clean;

CREATE TABLE customers_clean AS SELECT * FROM customers;
CREATE TABLE orders_clean AS SELECT * FROM orders;
CREATE TABLE order_items_clean AS SELECT * FROM order_items;
CREATE TABLE products_clean AS SELECT * FROM products;
CREATE TABLE sellers_clean AS SELECT * FROM sellers;
CREATE TABLE reviews_clean AS SELECT * FROM reviews;
CREATE TABLE payments_clean AS SELECT * FROM payments;

-- ===========================================
-- STEP 3: REMOVE DUPLICATE RECORDS
-- ===========================================

-- Customers: duplicate = same customer_id
DELETE FROM customers_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM customers_clean
    GROUP BY customer_id
);
-- ctid is Postgres-specific: it is the physical row address
-- MIN(ctid) keeps the first physical occurrence of each duplicate

-- Orders: duplicate = same order_id
DELETE FROM orders_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM orders_clean
    GROUP BY order_id
);

-- Order items: duplicate = same order_id + product_id combination
DELETE FROM order_items_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM order_items_clean
    GROUP BY order_id, product_id
);

-- Sellers: duplicate = same seller_id
DELETE FROM sellers_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM sellers_clean
    GROUP BY seller_id
);

-- Reviews: duplicate = same review_id
DELETE FROM reviews_clean
WHERE ctid NOT IN (
    SELECT MIN(ctid)
    FROM reviews_clean
    GROUP BY review_id
);

-- ====================
-- NO DUPLICATES FOUND
-- =====================


-- ============================================================
-- STEP 4: STANDARDISE TEXT FORMATTING
-- Standardize city name and product categories
-- INITCAP() - capitalises the first letter of each word
-- TRIM() - removes leading and trailing spaces
-- Payment date processing
-- ============================================================
-- See first 5 rows of customers_clean table
SELECT * FROM customers_clean LIMIT 5;

-- CUSTOMERS TABLE
-- city and state: INITCAP because these are place names
-- email: LOWER because emails are case insensitive
-- account_status: UPPER for consistency with status flags
-- first_name/last_name: TRIM only — we respect original casing
UPDATE customers_clean
SET
    first_name     = TRIM(first_name),
    last_name      = TRIM(last_name),
    email          = LOWER(TRIM(email)),
    city           = INITCAP(TRIM(city)),
    state          = INITCAP(TRIM(state)),
    account_status = UPPER(TRIM(account_status));


SELECT DISTINCT city FROM customers_clean;
-- city has spelling errors
UPDATE customers_clean
SET city = 'Lagos'
WHERE (TRIM(city)) IN ('Lago S');
-- 54 updated
UPDATE customers_clean
SET city = 'Port Harcourt'
WHERE (TRIM(city)) IN ('Portharcourt','Port-Harcourt');
-- 51 updated

-- 5 cities in total(correct)


-- See first 5 rows of orders_clean table
SELECT * FROM orders_clean LIMIT 5;
-- no necessary changes

-- See first 5 rows of order_items_clean table
SELECT * FROM order_items_clean LIMIT 5;
-- no necessary changes


-- See first 5 rows of products_clean table
SELECT * FROM products_clean LIMIT 5;
-- TO FIX: category shows spelling errors and inconsistent casing
UPDATE products_clean
SET
	product_name = TRIM(product_name),
    category       = INITCAP(TRIM(category))
WHERE category IS NOT NULL
OR product_name IS NOT NULL;
;
-- Fix specific known misspellings
UPDATE products_clean
SET category = 'Electronics'
WHERE (TRIM(category)) IN ('Electronis');
-- 11 successfully updated

UPDATE products_clean
SET category = 'Fashion'
WHERE (TRIM(category)) IN ('Fashon');
-- 10 successfully updated

UPDATE products_clean
SET category = 'Food And Beverages'
WHERE (TRIM(category)) IN ('Food & Beverages');
-- 17 successfully updated

UPDATE products_clean
SET category = 'Beauty And Personal Care'
WHERE (TRIM(category)) IN ('Beauty & Personal Care');
-- 23 successfully updated
UPDATE products_clean
SET category = 'Home And Garden'
WHERE (TRIM(category)) IN ('Home & Garden');
-- 30 successfully updated

UPDATE products_clean
SET category = 'Sports And Fitness'
WHERE (TRIM(category)) IN ('Sports & Fitness');
-- 20 successfully updated
UPDATE products_clean
SET category = 'Books And Stationery'
WHERE (TRIM(category)) IN ('Books & Stationery');
-- 11 successfully updated
-- check is categories are distinct
SELECT DISTINCT category
FROM products_clean;
-- 11 distinct categories found


-- See first 5 rows of sellers_clean table
SELECT * FROM sellers_clean LIMIT 5;
-- check sellers_clean for distinct product category
SELECT DISTINCT product_category FROM sellers_clean ;

UPDATE sellers_clean
SET product_category = 'Electronics'
WHERE (TRIM(product_category)) IN ('Electronis');
-- 2 successfully updated

UPDATE sellers_clean
SET product_category = 'Fashion'
WHERE (TRIM(product_category)) IN ('Fashon');
-- 4 successfully updated

UPDATE sellers_clean
SET product_category = 'Food And Beverages'
WHERE (TRIM(product_category)) IN ('Food & Beverages');
-- 7 successfully updated

UPDATE sellers_clean
SET product_category = 'Beauty And Personal Care'
WHERE (TRIM(product_category)) IN ('Beauty & Personal Care');
-- 8 successfully updated

UPDATE sellers_clean
SET product_category = 'Home And Garden'
WHERE (TRIM(product_category)) IN ('Home & Garden');
-- 8 successfully updated

UPDATE sellers_clean
SET product_category = 'Sports And Fitness'
WHERE (TRIM(product_category)) IN ('Sports & Fitness');
-- 4 successfully updated

UPDATE sellers_clean
SET product_category = 'Books And Stationery'
WHERE (TRIM(product_category)) IN ('Books & Stationery');
-- 6 successfully updated

-- check is categories are distinct
SELECT DISTINCT product_category
FROM sellers_clean;

-- 11 distinct categories found ( matching the categories)
--  made product_category == product_clean.category, city == customer_clean.city,
-- state == customer_clean.state, account_status== customer_clean.account status

UPDATE sellers_clean
SET
	product_category  	 = INITCAP(TRIM(product_category)),
    city         		 = INITCAP(TRIM(city)),
    state         		 = INITCAP(TRIM(state)),
    account_status		 = UPPER(TRIM(account_status))
WHERE city IS NOT NULL
   OR state IS NOT NULL
   OR product_category IS NOT NULL
   OR account_status IS NOT NULL;
   
-- city has spelling errors
SELECT DISTINCT city
FROM sellers_clean;

UPDATE sellers_clean
SET city = 'Lagos'
WHERE (TRIM(city)) IN ('Lago S');
-- 9 updated
UPDATE sellers_clean
SET city = 'Port Harcourt'
WHERE (TRIM(city)) IN ('Portharcourt','Port-Harcourt');
-- 8 updated
-- 5 cities in total

-- See first 5 rows of reviews_clean table
SELECT * FROM reviews_clean LIMIT 5;  
-- no necessary change


-- See first 5 rows of payments_clean table
SELECT * FROM payments_clean LIMIT 5;
-- ============================================================
-- PAYMENT DATE HANDLING DECISION
-- Issue: payments.payment_date is TIMESTAMP WITHOUT TIME ZONE
--        while all other date columns are DATE type
-- Decision: We do NOT convert the timestamp to DATE (preserves original data)
-- Action: Add payment_date_only for easy joining with other DATE columns
-- A separate payment_hour column is NOT added because none of the 8 business questions require hour-level precision on payments.
-- ============================================================

ALTER TABLE payments_clean 
    ADD COLUMN IF NOT EXISTS payment_date_only DATE;

UPDATE payments_clean 
SET payment_date_only = payment_date::DATE;

-- ============================================================
-- STEP 5: HANDLE MISSING VALUES (NULL AND BLANK ENTRIES)
-- Critical columns are given safe defaults instead of deleting rows
-- ============================================================

-- CUSTOMERS TABLE
UPDATE customers_clean
SET city = 'Unknown'
WHERE city IS NULL OR TRIM(city) = '';

UPDATE customers_clean
SET state = 'Unknown'
WHERE state IS NULL OR TRIM(state) = '';

UPDATE customers_clean
SET account_status = 'Unknown'
WHERE account_status IS NULL OR TRIM(account_status) = '';

-- PRODUCTS TABLE
UPDATE products_clean
SET category = 'Uncategorized'
WHERE category IS NULL OR TRIM(category) = '';

-- SELLERS TABLE
UPDATE sellers_clean
SET city = 'Unknown'
WHERE city IS NULL OR TRIM(city) = '';

UPDATE sellers_clean
SET state = 'Unknown'
WHERE state IS NULL OR TRIM(state) = '';

UPDATE sellers_clean
SET account_status = 'Unknown'
WHERE account_status IS NULL OR TRIM(account_status) = '';
-- no updates needed
-- ORDERS TABLE
UPDATE orders_clean
SET order_status = 'Unknown'
WHERE order_status IS NULL OR TRIM(order_status) = '';

-- ORDER_ITEMS TABLE - Important for revenue calculations
UPDATE order_items_clean
SET quantity = 1
WHERE quantity IS NULL;

UPDATE order_items_clean
SET unit_price = 0
WHERE unit_price IS NULL;
-- 97 updates(should have joined the table and gotten the price from another table)
UPDATE order_items_clean
SET line_total = 0
WHERE line_total IS NULL;
-- 97 updates too??
SELECT DISTINCT(product_id) 
FROM order_items_clean
WHERE unit_price = 0;
-- check if PROD0205, PROD0088, PROD0104 and PROD0245 has price values that can be inputed here in the product table.
SELECT *
FROM products_clean;
-- the product ids have null price in the product table too but just to verify
SELECT COUNT (DISTINCT product_id)
FROM products_clean;
-- 280 products available
SELECT COUNT (DISTINCT product_id)
FROM order_items_clean;
-- 280 products made it to the market
-- Select the two tables and check for where I can replace the prices
SELECT p.product_id, p.unit_price,p.category, oi.unit_price
FROM products_clean p
LEFT JOIN order_items_clean oi
ON oi.product_id = p.product_id
  WHERE oi.unit_price = 0
  OR oi.unit_price IS NULL
  OR p.unit_price = 0;
--  products that have no price appears 97 times
-- in category "Home And Garden", "Food And Beverages", "Books And stationery"
-- will I be able to get the mid price?
SELECT category, MAX(unit_price), AVG(unit_price), MIN(unit_price)
FROM products_clean
GROUP BY category;
-- the category range is too big to use the mid price


-- REVIEWS TABLE
UPDATE reviews_clean
SET rating = 0
WHERE rating IS NULL;     -- We will flag invalid ratings separately

-- PAYMENTS TABLE
UPDATE payments_clean
SET payment_method = 'Unknown'
WHERE payment_method IS NULL OR TRIM(payment_method) = '';

-- Optional but recommended: Handle NULL total_amount in orders
UPDATE orders_clean
SET total_amount = 0
WHERE total_amount IS NULL;


-- ============================================================
-- STEP 6: DATE FORMAT VALIDATION
-- Postgres stores dates as proper DATE type already (YYYY-MM-DD)
-- We verify there are no obviously wrong dates
-- delivery_date cannot be before order_date
-- ============================================================

-- check orders where delivery happened before the order was placed
-- This is a data quality issue — we flag it, not delete it

SELECT count(*)
FROM orders_clean
WHERE delivery_date IS NOT NULL
  AND order_date IS NOT NULL
  AND delivery_date < order_date;
-- no issue with dates



-- ============================================================
-- STEP 7: DATA VALIDATION — AMOUNT MISMATCH
-- Business rule: each order's total_amount should equal
-- the sum of its line items in order_items
-- We flag orders where the difference is greater than ₦10
-- Reason for flagging not deleting: the order still happened
-- and deleting it would remove real revenue from our analysis
-- ============================================================
SELECT * 
FROM order_items_clean LIMIT 5;
SELECT * 
FROM orders_clean LIMIT 5;
SELECT *
FROM order_items_clean
WHERE line_total <> quantity*unit_price;
-- So there is no line total that is mismatched withe quantity and unit price in order_items


-- check if order items total tallies with order total
-- subtract total in orders from sum of line total.
SELECT o.order_id,
		oi.order_id,o.total_amount, sum(oi.line_total),
ABS(COALESCE(o.total_amount, 0)) - (
        COALESCE(SUM(oi.line_total), 0)) 
FROM order_items_clean oi
JOIN orders_clean o
ON oi.order_id = o.order_id
GROUP BY oi.order_id, o.order_id, o.total_amount;
-- note:  some have negative difference especially where total amount is null

-- How many products have no price?
SELECT 
    product_id,
    product_name,
    category,
    unit_price
FROM products_clean
WHERE unit_price IS NULL
OR unit_price = 0
ORDER BY category, product_name;

-- 4 products have no price"PROD0245","PROD0205","PROD0088","PROD0104"

-- Were the NULL-price products actually ordered?
-- And did order_items capture a price even when products table did not?
SELECT 
    p.product_id,
    p.product_name,
    p.unit_price AS product_table_price,
    oi.unit_price AS order_item_price,
    oi.line_total,
    oi.quantity,
    oi.order_id
FROM products_clean p
INNER JOIN order_items_clean oi 
    ON p.product_id = oi.product_id
WHERE p.unit_price IS NULL
ORDER BY p.product_id;

-- they were sold but there is no price

-- For orders containing NULL-price products
-- what did the payments table record?
SELECT 
    o.order_id,
    o.total_amount AS order_total,
    p.amount AS payment_amount,
    p.payment_method,
    p.payment_date
FROM orders_clean o
INNER JOIN payments_clean p 
    ON o.order_id = p.order_id
WHERE o.order_id IN (
	-- orders that contain at least one NULL-price item
    SELECT DISTINCT oi.order_id
    FROM order_items_clean oi
    INNER JOIN products_clean pr 
        ON oi.product_id = pr.product_id
    WHERE pr.unit_price IS NULL
        OR oi.unit_price IS NULL
)
ORDER BY o.order_id;

-- we cannot trace price from payments table

-- Show every order with its mismatch details
-- so you can see what you are dealing with
-- Show every order with its mismatch details
-- so you can see what you are dealing with
WITH order_line_totals AS (
    SELECT 
        order_id,
        SUM(line_total) AS sum_of_line_items,
        COUNT(*) AS item_count,
        SUM(CASE WHEN line_total = 0 THEN 1 ELSE 0 END) AS null_line_total_count
    FROM order_items_clean
    GROUP BY order_id
)
SELECT 
    o.order_id,
    o.total_amount,
    olt.sum_of_line_items,
    olt.null_line_total_count,
    ABS(COALESCE(o.total_amount, 0) - COALESCE(olt.sum_of_line_items, 0)) AS difference,
    CASE
        WHEN olt.null_line_total_count > 0 
            THEN 'Has NULL line items — price data missing'
        WHEN ABS(o.total_amount - COALESCE(olt.sum_of_line_items, 0)) <= 10 
            THEN 'Match — within ₦10 tolerance'
        WHEN o.total_amount > COALESCE(olt.sum_of_line_items, 0) 
            THEN 'Positive gap — total_amount higher than line items'
        WHEN o.total_amount < COALESCE(olt.sum_of_line_items, 0) 
            THEN 'Negative gap — line items higher than total_amount'
        ELSE 'Unknown'
    END AS mismatch_type
FROM orders_clean o
LEFT JOIN order_line_totals olt 
    ON o.order_id = olt.order_id
ORDER BY ABS(o.total_amount - COALESCE(olt.sum_of_line_items, 0)) DESC;
-- every category of mismatch  exists

-- ============================================================
-- DATA VALIDATION: Order total_amount vs sum of line items
-- make a new column and flag them
-- Flag instead of deleting (as per task requirement)
-- ============================================================

ALTER TABLE orders_clean 
ADD COLUMN IF NOT EXISTS amount_mismatch BOOLEAN DEFAULT FALSE;

ALTER TABLE orders_clean 
ADD COLUMN IF NOT EXISTS mismatch_type TEXT;

WITH order_line_totals AS (
    SELECT 
        order_id,
        SUM(COALESCE(line_total, 0)) AS sum_of_line_items
    FROM order_items_clean
    GROUP BY order_id
)
UPDATE orders_clean o
SET amount_mismatch = TRUE,
    mismatch_type = 
        CASE
            WHEN EXISTS (SELECT 1 FROM order_items_clean oi 
                         WHERE oi.order_id = o.order_id AND oi.line_total IS NULL) 
                THEN 'Has NULL line items'
            WHEN ABS(COALESCE(o.total_amount, 0) - COALESCE(olt.sum_of_line_items, 0)) <= 10 
                THEN 'Within tolerance'
            WHEN COALESCE(o.total_amount, 0) > COALESCE(olt.sum_of_line_items, 0) 
                THEN 'Positive gap'
            WHEN COALESCE(o.total_amount, 0) < COALESCE(olt.sum_of_line_items, 0) 
                THEN 'Negative gap'
            ELSE 'Unknown mismatch'
        END
FROM order_line_totals olt
WHERE o.order_id = olt.order_id;
-- 3015 updates completed
-- Also update orders that have no line items at all
UPDATE orders_clean 
SET amount_mismatch = TRUE,
    mismatch_type = 'No line items found'
WHERE order_id NOT IN (SELECT DISTINCT order_id FROM order_items_clean);
--
-- ============================================================
-- DOCUMENT MISMATCH SUMMARY - For Cleaning Script
-- This shows clear statistics of data quality issues
-- ============================================================

WITH order_line_totals AS (
    SELECT 
        order_id,
        SUM(COALESCE(line_total, 0)) AS sum_of_line_items,
        SUM(CASE WHEN line_total IS NULL OR line_total = 0 THEN 1 ELSE 0 END) AS null_line_total_count
    FROM order_items_clean
    GROUP BY order_id
),
mismatch_summary AS (
    SELECT 
        o.order_id,
        o.total_amount,
        olt.sum_of_line_items,
        olt.null_line_total_count,
        ABS(COALESCE(o.total_amount, 0) - COALESCE(olt.sum_of_line_items, 0)) AS difference,
        CASE
            WHEN olt.null_line_total_count > 0 THEN 'Has NULL line items — price data missing'
            WHEN ABS(COALESCE(o.total_amount, 0) - COALESCE(olt.sum_of_line_items, 0)) <= 10 THEN 'Match — within ₦10 tolerance'
            WHEN COALESCE(o.total_amount, 0) > COALESCE(olt.sum_of_line_items, 0) THEN 'Positive gap — total_amount higher'
            WHEN COALESCE(o.total_amount, 0) < COALESCE(olt.sum_of_line_items, 0) THEN 'Negative gap — line items higher'
            ELSE 'Unknown mismatch'
        END AS mismatch_type
    FROM orders_clean o
    LEFT JOIN order_line_totals olt ON o.order_id = olt.order_id
)
SELECT 
    mismatch_type,
    COUNT(*) AS number_of_orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_total,
    ROUND(AVG(difference), 2) AS avg_difference_naira
FROM mismatch_summary
GROUP BY mismatch_type
ORDER BY number_of_orders DESC;
-- 90% of orders is within the #10 tolerance

-- ========================================================================================
--			mismatch type					no_of_orders	% of total	avg difference in naira
-- "Match — within ₦10 tolerance"				2741		90.91		0.00
-- "Negative gap — line items higher"			130			4.31		136434.71
-- "Has NULL line items — price data missing"	92			3.05		287264.25
-- "Positive gap — total_amount higher"			52			1.72		53967.38

-- ========================================================================================
-- STEP 8: DATA VALIDATION — REVIEW RATINGS
-- Valid ratings must be between 1 and 5
-- Invalid ratings are flagged so they can be excluded
-- from the review analysis queries
-- ============================================================

ALTER TABLE reviews_clean
    ADD COLUMN IF NOT EXISTS invalid_rating BOOLEAN DEFAULT FALSE;

UPDATE reviews_clean
SET invalid_rating = TRUE
WHERE rating IS NOT NULL
  AND (rating < 1 OR rating > 5);
-- 5 invalid ratings
-- How many invalid ratings?
SELECT
    COUNT(*) AS total_invalid_ratings
FROM reviews_clean
WHERE invalid_rating = TRUE;
-- 5  invalid ratings, make sure to exclude from ratings calculation

-- ============================================================
-- STEP 9: DATA VALIDATION — NEGATIVE PRICES AND DISCOUNTS
-- A product cannot have a negative price
-- Flag any such records for investigation
-- ============================================================

ALTER TABLE products_clean
    ADD COLUMN IF NOT EXISTS invalid_price BOOLEAN DEFAULT FALSE;

UPDATE products_clean
SET invalid_price = TRUE
WHERE unit_price IS NOT NULL
  AND unit_price < 0;

ALTER TABLE order_items_clean
    ADD COLUMN IF NOT EXISTS invalid_price BOOLEAN DEFAULT FALSE;

UPDATE order_items_clean
SET invalid_price = TRUE
WHERE unit_price IS NOT NULL
  AND unit_price < 0;

-- How many invalid prices?
SELECT
    COUNT(*) AS products_with_negative_price
FROM products_clean
WHERE invalid_price = TRUE;
-- there are 0 products with invalid price
