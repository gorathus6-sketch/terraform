SELECT
    s.sid,
    s.serial#,
    s.username,
    s.program,
    s.module,
    s.last_call_et AS seconds_active,
    q.sql_test,
    s.event As current_wait_event
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.status = 'ACTIVE'
  AND s.username IS NOT NULL
  --Optional, filter to check a specific source, like a
  --sqlplus script, e.g.
  --AND s.program LIKE '%sqlplus%'
ORDER BY s.last_call_et DESC; 