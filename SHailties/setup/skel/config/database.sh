# database configuration
development:
    adapter: sqlite3
    database: db/development.sqlite3
    timeout: 5000

test:
    adapter: sqlite3
    database: db/test.sqlite3
    timeout: 5000

production:
    adapter: sqlite3
    database: db/production.sqlite3
    timeout: 5000
