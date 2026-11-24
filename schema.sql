-- Call tracking database for SQL practice
-- Works in MySQL and SQLite

CREATE TABLE sources (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    channel VARCHAR(20) NOT NULL
);

CREATE TABLE managers (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(30) NOT NULL
);

CREATE TABLE calls (
    id INTEGER PRIMARY KEY,
    call_time DATETIME NOT NULL,
    caller_phone VARCHAR(20) NOT NULL,
    source_id INTEGER,
    manager_id INTEGER,
    status VARCHAR(10) NOT NULL,
    duration_sec INTEGER NOT NULL
);
