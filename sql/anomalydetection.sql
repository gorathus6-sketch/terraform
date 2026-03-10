SELECT t.account_id
FROM transactions t
LEFT JOIN customers c
  ON t.account_id = c.account_id
WHERE c.account_id IS NULL;
-- this will find accounts with transactions
-- but no customer records
