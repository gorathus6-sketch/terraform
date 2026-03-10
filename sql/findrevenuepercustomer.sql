SELECT
  c.customer_id,
  c.customer_name,
  SUM(o.amount) AS total_revenue
FROM customers c
INNER JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.customer_id, customer_name;

-- this will find total revenue per customer
--
-- 1) entity type
-- customers -> anchor = customers
--
-- 2) output columns
-- customer_name -> customers
-- total_revenue -> must come from orders or
-- or transactions
--
-- 3) relationship inference
-- orders typically contain:
-- order_id
-- customer_id
-- amount
--
-- 4) join type
-- in this case we only need customers who placed
-- orders, hence INNER JOIN
--
-- 5) Logic
-- total revenue -> SUM(amount)
-- Per customer -> GROUP BY customer_id