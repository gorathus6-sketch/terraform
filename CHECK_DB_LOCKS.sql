SELECT
    lo.session_id,
    s.serial#,
    s.username,
    s.osuser,
    s.machine,
    o.object_name,
    lo.locked_mode
FROM v$locked_object lo
JOIN dba_objects o ON lo.object_id = o.object_id
JOIN v$session s ON lo.session_id = s.sid
WHERE o.object_name = 'BANK'