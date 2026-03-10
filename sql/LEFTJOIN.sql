SELECT u.user_id l.last_login
FROM users u
LEFT JOIN logins l
  ON u.user_id = l.user_id;