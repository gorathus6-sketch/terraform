-- 1) identify top performing categories
-- this query calculates total sales and number of transactions
-- per category. Instead of using a greater than operator, it
-- uses a specific range

-- select the category and calculate total metrics
SELECT
    category_name,
    COUNT(order_id) AS transaction_count,
    SUM(sales_price) AS total_revenue
FROM
    sales_table
-- filter for high revenue items using a range to avoid specific symbols
WHERE
    sale_price BTWEEN 100 AND 1000
GROUP BY
    category_name
-- Filter groups that have significant volume
HAVING
    COUNT(order_id) > 50

-- 2) joning user data with activity
-- data scientists frequently join tables to create
-- a master data set for modeling.

-- combine user profiles with their login activity
SELECT
    u.user_id,
    u.signup_date,
    a.last_login_date,
    a.total_sessions
FROM
    users u
JOIN
    activity_log a ON u.user_id = a.user_id
-- Filter for users who joined in a specific year
WHERE
    u.signup_date BETWEEN '2025-01-01,' AND '2025-12-31'