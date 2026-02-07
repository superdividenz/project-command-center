-- Command Center Database Schema
-- Core tables for project management and communication

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- PROJECTS TABLE (Original functionality)
-- ============================================
CREATE TABLE IF NOT EXISTS projects (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR(255) NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('planning', 'in_progress', 'blocked', 'completed')),
  progress INTEGER NOT NULL DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
  priority VARCHAR(20) NOT NULL CHECK (priority IN ('low', 'medium', 'high')),
  description TEXT,
  next_action TEXT,
  due_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- USERS TABLE (for authentication and profiles)
-- ============================================
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PROJECT MEMBERS (Many-to-Many)
-- ============================================
CREATE TABLE IF NOT EXISTS project_members (
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(50) DEFAULT 'member',
  joined_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (project_id, user_id)
);

-- ============================================
-- PROJECT UPDATES (Activity feed)
-- ============================================
CREATE TABLE IF NOT EXISTS project_updates (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  content TEXT NOT NULL,
  type VARCHAR(50) DEFAULT 'update',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TASKS (Breakdown of project work)
-- ============================================
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  status VARCHAR(50) DEFAULT 'pending',
  priority VARCHAR(20) DEFAULT 'medium',
  assignee_id UUID REFERENCES users(id),
  due_date TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- MESSAGES (Project communication)
-- ============================================
CREATE TABLE IF NOT EXISTS messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  content TEXT NOT NULL,
  reply_to UUID REFERENCES messages(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- FILES (Project attachments)
-- ============================================
CREATE TABLE IF NOT EXISTS files (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id),
  filename VARCHAR(255) NOT NULL,
  file_type VARCHAR(100),
  file_size INTEGER,
  storage_url TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- FUNCTION to update updated_at timestamp
-- ============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Insert sample users
INSERT INTO users (email, name, role) VALUES
('admin@commandcenter.com', 'System Administrator', 'admin'),
('manager@commandcenter.com', 'Project Manager', 'manager'),
('developer@commandcenter.com', 'Lead Developer', 'developer')
ON CONFLICT (email) DO NOTHING;

-- Insert sample projects
INSERT INTO projects (name, status, progress, priority, description, next_action, due_date) VALUES
('Command Center Dashboard', 'in_progress', 80, 'high', 'Main dashboard for monitoring all operations', 'Deploy to Railway', '2026-02-15'),
('Communication System', 'planning', 20, 'high', 'Real-time messaging and notification system', 'Set up WebSocket server', '2026-03-01'),
('Task Management', 'blocked', 90, 'medium', 'Task tracking and assignment system', 'Fix database migration', '2026-02-10'),
('Reporting Module', 'completed', 100, 'low', 'Analytics and reporting dashboard', 'Add export functionality', '2026-01-31')
ON CONFLICT DO NOTHING;

-- Add users to projects
INSERT INTO project_members (project_id, user_id, role)
SELECT 
    p.id,
    u.id,
    CASE 
        WHEN u.email = 'admin@commandcenter.com' THEN 'owner'
        WHEN u.email = 'manager@commandcenter.com' THEN 'manager'
        ELSE 'member'
    END
FROM projects p
CROSS JOIN users u
ON CONFLICT DO NOTHING;

-- Insert sample tasks
INSERT INTO tasks (project_id, title, description, status, priority, assignee_id, due_date)
SELECT 
    p.id,
    'Design UI components',
    'Create reusable React components for the dashboard',
    'in_progress',
    'high',
    (SELECT id FROM users WHERE email = 'developer@commandcenter.com'),
    '2026-02-12'
FROM projects p WHERE p.name = 'Command Center Dashboard'
UNION ALL
SELECT 
    p.id,
    'Set up database',
    'Configure PostgreSQL and create initial schema',
    'completed',
    'medium',
    (SELECT id FROM users WHERE email = 'admin@commandcenter.com'),
    '2026-02-05'
FROM projects p WHERE p.name = 'Command Center Dashboard'
ON CONFLICT DO NOTHING;

-- Insert sample messages
INSERT INTO messages (project_id, user_id, content)
SELECT 
    p.id,
    u.id,
    'The dashboard design is coming along nicely. Should we add dark mode?'
FROM projects p 
CROSS JOIN users u 
WHERE p.name = 'Command Center Dashboard' 
AND u.email = 'developer@commandcenter.com'
UNION ALL
SELECT 
    p.id,
    u.id,
    'Yes, dark mode would be great! Also consider adding keyboard shortcuts.'
FROM projects p 
CROSS JOIN users u 
WHERE p.name = 'Command Center Dashboard' 
AND u.email = 'manager@commandcenter.com'
ON CONFLICT DO NOTHING;

-- ============================================
-- FINAL MESSAGE
-- ============================================
SELECT '✅ Command Center Database Schema created successfully!' as message;

-- Show table counts
SELECT 
    'projects' as table_name, 
    COUNT(*) as record_count 
FROM projects
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'tasks', COUNT(*) FROM tasks
UNION ALL
SELECT 'messages', COUNT(*) FROM messages
ORDER BY table_name;