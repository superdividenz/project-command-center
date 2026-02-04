-- Run in psql. Connect first: psql "$DATABASE_URL"
-- Then: \i backend/check-db.sql
-- Or run \dt first, then this file for the count.

SELECT COUNT(*) AS project_count FROM projects;
