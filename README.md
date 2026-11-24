# SQL practice: call tracking

A small database for a call tracking service and the SQL queries I wrote for it. It has calls, traffic sources and managers who answer the calls.

## Files

- `schema.sql`: tables
- `data.sql`: test data. Some records are broken on purpose so that the data checks have something to find.
- `queries.sql`: 16 queries with a short comment for each
- `SQL_Checks.xlsx`: the same queries as a checklist with expected results

## Tables

| Table | Columns |
|---|---|
| calls | id, call_time, caller_phone, source_id, manager_id, status, duration_sec |
| sources | id, name, channel |
| managers | id, name, department |

`calls.source_id` links to `sources.id`, `calls.manager_id` links to `managers.id`.

## Queries

Basic (WHERE, ORDER BY, GROUP BY):

- missed calls for one day
- answered calls longer than 3 minutes
- number of calls by status

JOIN:

- calls with source name and manager name
- number of calls from each source
- answered calls and average talk time for each manager
- sources with no calls (LEFT JOIN)
- paid sources with more than 2 missed calls (HAVING)

Data checks, each one should return 0 rows:

- negative call duration
- missed call with talk time
- answered call with 0 seconds
- answered call without a manager
- call with a source that does not exist
- the same call saved twice
- call date in the future
- unknown status

## How to run

The queries work in MySQL and SQLite.

The fastest way is https://sqliteonline.com: run `schema.sql`, then `data.sql`, then the queries one by one.

From the command line with SQLite:

```
sqlite3 calls.db < schema.sql
sqlite3 calls.db < data.sql
sqlite3 calls.db < queries.sql
```

## Author

Vira Shkurenko, Junior QA Engineer. [LinkedIn](https://linkedin.com/in/vira-shkurenko)
