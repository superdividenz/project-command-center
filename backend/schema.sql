-- In your psql session (after connecting):
--   \dt
--   SELECT COUNT(*) FROM projects;

-- If no projects table, create it:
CREATE TABLE IF NOT EXISTS projects (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('planning', 'in_progress', 'blocked', 'completed')),
  progress INTEGER NOT NULL DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  priority VARCHAR(20) NOT NULL CHECK (priority IN ('low', 'medium', 'high')),
  description TEXT,
  next_action TEXT,
  due_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data if empty
INSERT INTO projects (name, status, progress, priority, description, next_action, due_date)
SELECT 'Physician Monitoring System', 'in_progress', 80, 'high', 'Monitor physician payments and compliance', 'Fix Railway deployment', '2026-02-04'
WHERE NOT EXISTS (SELECT 1 FROM projects);

-- Check
SELECT COUNT(*) FROM projects;
SELECT * FROM projects;
