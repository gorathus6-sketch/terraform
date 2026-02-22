SET PAGESIZE 500
SET LINESIZE 200
SET FEEDBACK OFF
SET HEADING ON

SELECT
    s.sid,
    s.serial#,
    s.username,
    s.status,
    q.sql_text,
    s.last_call_et AS seconds_running
FROM v$session s
JOIN v$sql q ON s.sql_id = q.sql_id
WHERE s.status = 'ACTIVE'
  AND s.username IS NOT NULL
  AND s.last_call_et > 300 -- running > 5 mins
ORDER BY s.last_call_et DESC;

EXIT;