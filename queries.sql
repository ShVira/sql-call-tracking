-- SQL queries for the call tracking database
-- Today for these checks is 2026-11-24


-- ===== Basic queries =====

-- 1. Missed calls on 2026-11-19, newest first
SELECT id, call_time, caller_phone
FROM calls
WHERE status = 'missed'
  AND call_time >= '2026-11-19 00:00:00'
  AND call_time < '2026-11-20 00:00:00'
ORDER BY call_time DESC;

-- 2. Answered calls longer than 3 minutes
SELECT id, call_time, caller_phone, duration_sec
FROM calls
WHERE status = 'answered' AND duration_sec > 180
ORDER BY duration_sec DESC;

-- 3. Number of calls by status
SELECT status, COUNT(*) AS calls
FROM calls
GROUP BY status;


-- ===== JOIN =====

-- 4. Calls with source name and manager name
SELECT c.id, c.call_time, s.name AS source, m.name AS manager, c.status
FROM calls c
JOIN sources s ON s.id = c.source_id
JOIN managers m ON m.id = c.manager_id
ORDER BY c.call_time;

-- 5. Number of calls from each source
SELECT s.name AS source, COUNT(c.id) AS calls
FROM sources s
JOIN calls c ON c.source_id = s.id
GROUP BY s.name
ORDER BY calls DESC;

-- 6. Answered calls and average talk time for each manager
SELECT m.name AS manager, COUNT(c.id) AS answered_calls, ROUND(AVG(c.duration_sec)) AS avg_duration_sec
FROM managers m
JOIN calls c ON c.manager_id = m.id
WHERE c.status = 'answered'
GROUP BY m.name
ORDER BY answered_calls DESC;

-- 7. Sources that brought no calls
SELECT s.name AS source
FROM sources s
LEFT JOIN calls c ON c.source_id = s.id
WHERE c.id IS NULL;

-- 8. Paid sources with more than 2 missed calls
SELECT s.name AS source, COUNT(*) AS missed_calls
FROM calls c
JOIN sources s ON s.id = c.source_id
WHERE s.channel = 'paid' AND c.status = 'missed'
GROUP BY s.name
HAVING COUNT(*) > 2;


-- ===== Data checks (each query should return 0 rows) =====

-- 9. Calls with negative duration
SELECT id, duration_sec FROM calls WHERE duration_sec < 0;

-- 10. Missed calls that have duration
SELECT id, duration_sec FROM calls WHERE status = 'missed' AND duration_sec > 0;

-- 11. Answered calls with 0 seconds
SELECT id, duration_sec FROM calls WHERE status = 'answered' AND duration_sec = 0;

-- 12. Answered calls without a manager
SELECT id, call_time FROM calls WHERE status = 'answered' AND manager_id IS NULL;

-- 13. Calls with a source that does not exist
SELECT c.id, c.source_id
FROM calls c
LEFT JOIN sources s ON s.id = c.source_id
WHERE s.id IS NULL;

-- 14. Same phone and same time saved twice
SELECT caller_phone, call_time, COUNT(*) AS times
FROM calls
GROUP BY caller_phone, call_time
HAVING COUNT(*) > 1;

-- 15. Calls with a date in the future
SELECT id, call_time FROM calls WHERE call_time > '2026-11-24 23:59:59';

-- 16. Unknown status
SELECT id, status FROM calls WHERE status NOT IN ('answered', 'missed');
