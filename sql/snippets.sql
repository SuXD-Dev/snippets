-- Useful SQL snippets

-- --- Table Management ---

-- Create table if not exists
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Upsert (insert or update)
INSERT INTO users (username, email)
VALUES ('alice', 'alice@example.com')
ON CONFLICT (username)
DO UPDATE SET email = EXCLUDED.email, updated_at = CURRENT_TIMESTAMP;

-- --- Query Patterns ---

-- Pagination
SELECT * FROM users
ORDER BY id
LIMIT 20 OFFSET 0;

-- Conditional aggregation
SELECT
    COUNT(*) FILTER (WHERE status = 'active') AS active,
    COUNT(*) FILTER (WHERE status = 'inactive') AS inactive,
    AVG(score) FILTER (WHERE score > 0) AS avg_score
FROM users;

-- Time-based grouping
SELECT
    DATE(created_at) AS day,
    COUNT(*) AS signups
FROM users
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(created_at)
ORDER BY day;

-- --- Useful Queries ---

-- Find duplicates
SELECT email, COUNT(*) AS count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Delete duplicates, keep latest
DELETE FROM users
WHERE id NOT IN (
    SELECT MAX(id) FROM users GROUP BY email
);

-- Generate date series (PostgreSQL)
SELECT generate_series(
    CURRENT_DATE - INTERVAL '30 days',
    CURRENT_DATE,
    '1 day'::interval
)::date AS day;

-- JSON operations (PostgreSQL)
SELECT data->>'name' AS name, data->'tags' AS tags
FROM items
WHERE data->>'category' = 'books';

-- Recursive CTE for tree structures
WITH RECURSIVE tree AS (
    SELECT id, name, parent_id, 1 AS depth
    FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.name, c.parent_id, t.depth + 1
    FROM categories c JOIN tree t ON c.parent_id = t.id
)
SELECT * FROM tree ORDER BY depth;

-- GREATEST/LEAST across columns
SELECT id,
    GREATEST(score1, score2, score3) AS max_score,
    LEAST(score1, score2, score3) AS min_score
FROM results;
