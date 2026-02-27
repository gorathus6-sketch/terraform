--
-- check_long_running.sql
-- detect long-running active sessions in Oracle
--

SET PAGESIZE 0
SET LINESIZE 200
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF
SET ECHO OFF
SET TERMOUT OFF

-- Threshold in seconds (modify as needed)
DEFINE THRESHOLD = 300;

-- Query for long-running active sessions
SELECT 'LONG_RUNNING: SID=' || s.sid ||
       ' SERIAL=' || s.serial# ||
       ' USER=' || s.username ||
       ' SQL_ID=' || s.sql_id ||
       ' SECONDS=' || s.last_call_et
FROM v$session s
WHERE s.status = 'ACTIVE'
  AND s.username IS NOT NULL
  AND s.last_call_et > &THRESHOLD;

-- Exit SQLPlus
EXIT;