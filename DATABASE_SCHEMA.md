# Command Center Database Schema

## Overview

The Command Center uses a comprehensive database schema designed for:
1. **Project Management** - Track projects, tasks, and progress
2. **Communication** - Real-time messaging and notifications
3. **User Management** - Authentication and user profiles
4. **File Management** - Document and attachment storage

## Database Options

### Option 1: Simple Schema (`schema.sql`)
For basic project management:
- **Projects table** - Core project tracking
- **Users table** - User accounts
- **Tasks table** - Task breakdown
- **Messages table** - Project communication
- **Files table** - Attachments

### Option 2: Full Communication Schema (`communication-schema.sql`)
For complete communication system:
- **Conversations** - Direct and group chats
- **Channels** - Organized communication channels
- **Messages** with reactions and read receipts
- **Notifications** - User notifications
- **Audit Log** - Action tracking
- **User Settings** - Preferences

## Quick Start

### 1. Set Up Supabase Database
```sql
-- Run in Supabase SQL Editor
-- For basic functionality:
\i schema.sql

-- For full communication system:
\i communication-schema.sql
```

### 2. Core Tables Explained

#### Projects Table
```sql
CREATE TABLE projects (
  id UUID PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  status VARCHAR(50), -- planning, in_progress, blocked, completed
  progress INTEGER, -- 0-100
  priority VARCHAR(20), -- low, medium, high
  description TEXT,
  next_action TEXT,
  due_date DATE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### Users Table
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255) NOT NULL,
  role VARCHAR(50), -- user, admin, manager
  avatar_url TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

#### Messages Table
```sql
CREATE TABLE messages (
  id UUID PRIMARY KEY,
  project_id UUID REFERENCES projects(id),
  user_id UUID REFERENCES users(id),
  content TEXT NOT NULL,
  reply_to UUID REFERENCES messages(id),
  created_at TIMESTAMP
);
```

## Sample Queries

### Get All Projects with Progress
```sql
SELECT 
  name,
  status,
  progress,
  priority,
  due_date
FROM projects
ORDER BY 
  CASE priority 
    WHEN 'high' THEN 1
    WHEN 'medium' THEN 2
    WHEN 'low' THEN 3
  END,
  due_date;
```

### Get Project with Tasks and Messages
```sql
SELECT 
  p.name as project_name,
  p.progress,
  COUNT(DISTINCT t.id) as task_count,
  COUNT(DISTINCT m.id) as message_count,
  MAX(m.created_at) as last_activity
FROM projects p
LEFT JOIN tasks t ON p.id = t.project_id
LEFT JOIN messages m ON p.id = m.project_id
GROUP BY p.id, p.name, p.progress;
```

### Get Unread Messages for User
```sql
SELECT 
  p.name as project_name,
  COUNT(m.id) as unread_count,
  MAX(m.created_at) as latest_message
FROM projects p
JOIN project_members pm ON p.id = pm.project_id
JOIN messages m ON p.id = m.project_id
LEFT JOIN message_reads mr ON m.id = mr.message_id AND mr.user_id = pm.user_id
WHERE pm.user_id = 'user-uuid-here'
  AND mr.message_id IS NULL
GROUP BY p.id, p.name;
```

## Relationships

```
projects
  ├── project_members (many-to-many with users)
  ├── tasks (one-to-many)
  ├── messages (one-to-many)
  └── files (one-to-many)

users
  ├── project_members (many-to-many with projects)
  ├── tasks (one-to-many, as assignee)
  ├── messages (one-to-many)
  └── files (one-to-many, as uploader)
```

## Indexes for Performance

```sql
-- Projects
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_projects_priority ON projects(priority);
CREATE INDEX idx_projects_due_date ON projects(due_date);

-- Tasks
CREATE INDEX idx_tasks_project ON tasks(project_id);
CREATE INDEX idx_tasks_status ON tasks(status);
CREATE INDEX idx_tasks_assignee ON tasks(assignee_id);

-- Messages
CREATE INDEX idx_messages_project ON messages(project_id);
CREATE INDEX idx_messages_created ON messages(created_at DESC);

-- Users
CREATE INDEX idx_users_email ON users(email);
```

## Security (Row Level Security)

Enable RLS in Supabase:
```sql
-- Enable RLS on all tables
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Example policy: Users can only see projects they're members of
CREATE POLICY "Users can view their projects" ON projects
  FOR SELECT USING (
    id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid())
  );

-- Example policy: Project members can insert tasks
CREATE POLICY "Project members can create tasks" ON tasks
  FOR INSERT WITH CHECK (
    project_id IN (SELECT project_id FROM project_members WHERE user_id = auth.uid())
  );
```

## Migration Notes

### Adding New Features
1. Always backup database before schema changes
2. Use `ALTER TABLE` for adding columns
3. Use transactions for multiple changes
4. Test migrations in development first

### Example Migration: Add Budget Column
```sql
BEGIN;
ALTER TABLE projects ADD COLUMN budget DECIMAL(10,2);
ALTER TABLE projects ADD COLUMN spent DECIMAL(10,2) DEFAULT 0;
COMMIT;
```

## Backup and Recovery

### Supabase Backups
1. Automatic daily backups
2. Point-in-time recovery
3. Manual backup exports

### Export Data
```sql
-- Export projects to CSV
COPY (SELECT * FROM projects) TO '/tmp/projects.csv' WITH CSV HEADER;

-- Export with relationships
COPY (
  SELECT 
    p.*,
    u.name as created_by_name,
    COUNT(t.id) as task_count
  FROM projects p
  LEFT JOIN users u ON p.created_by = u.id
  LEFT JOIN tasks t ON p.id = t.project_id
  GROUP BY p.id, u.name
) TO '/tmp/projects_detailed.csv' WITH CSV HEADER;
```

## Troubleshooting

### Common Issues

1. **Connection Errors**
   - Check Supabase connection string
   - Verify network access
   - Check SSL configuration

2. **Performance Issues**
   - Add missing indexes
   - Optimize queries
   - Consider partitioning large tables

3. **Permission Errors**
   - Verify RLS policies
   - Check user roles
   - Review audit logs

### Monitoring
```sql
-- Check table sizes
SELECT 
  table_name,
  pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) as size
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY pg_total_relation_size(quote_ident(table_name)) DESC;

-- Check index usage
SELECT 
  schemaname,
  tablename,
  indexname,
  idx_scan as index_scans
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC;
```

## Support

- **Supabase Documentation**: https://supabase.com/docs
- **PostgreSQL Documentation**: https://www.postgresql.org/docs/
- **GitHub Issues**: https://github.com/superdividenz/Command-Center/issues

---

*Last Updated: $(date)*