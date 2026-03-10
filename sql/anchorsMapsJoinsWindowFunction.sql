WITH ranked_orders AS (
  SELECT
    o.customer_id,
    o.order_date,
    ROW_NUMBER() OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date DESC
    ) AS rn
  FROM orders o
)
SELECT
  c.customer_id,
  c.customer_name,
  r.order_date AS most_recent_order
FROM customers c
LEFT JOIN ranked_orders r
  ON c.customer_id = r.customer_id
WHERE r.rn = 1 OR r.rn IS NULL;

-- 1) anchor table "customers"
--
-- 2) required columns:
-- customer_name
-- order_date (latest first, AKA DESC)
--
-- 3) map columns to tables
-- customer_name -> customers
-- order_date -> orders
--
-- 4) join type
-- since we need 'all' customers -> LEFT JOIN
--
-- 5) add logic for 'most recent' with a
-- window function 