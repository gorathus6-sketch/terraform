SELECT o.order_id, c.customer_name
FROM orders o
INNER JOIN customers c
  ON o.customer_id = c.customer_id;