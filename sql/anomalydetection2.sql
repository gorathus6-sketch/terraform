SELECT t.account_id
FROM transactions t
LEFT JOIN customers c
  ON t.account_id = c.account_id
WHERE c.account_id IS NULL;

--
-- This finds accounts with transactions but no
-- customer records.
--
-- Infers:
--   accounts table owns account_id
--   transaction table references account_id
--   missing customer record -> LEFT JOIN + NULL
--