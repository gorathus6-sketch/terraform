WITH ranked_orders AS (
  SELECT
    o.*,
    ROW_NUMBER() OVER (
      PARTITION BY o.customer_id
      ORDER BY o.order_date DESC
      ) AS
  FROM orders o
)
SELECT *
FROM ranked_orders
WHERE rn = 1;
--This pattern solves:
--latest login per user
--most recent transaction per account
--top n events per category
--in essense, most recent order for each customer