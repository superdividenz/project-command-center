# Supabase Deployment Guide

## Project Command Center with Supabase

This project uses **Supabase** for the database and backend API. The frontend connects directly to Supabase using the Supabase JavaScript client.

## Architecture

```
┌─────────────────┐     ┌─────────────┐     ┌─────────────┐
│   Frontend      │────▶│   Supabase  │────▶│ PostgreSQL  │
│   (HTML/JS)     │◀────│   (API)     │◀────│  Database   │
└─────────────────┘     └─────────────┘     └─────────────┘
       │                       │
       │                       │
       ▼                       ▼
┌─────────────────┐     ┌─────────────┐
│   Railway/      │     │   Row Level │
│   Static Host   │     │   Security  │
└─────────────────┘     └─────────────┘
```

## Step 1: Set Up Supabase

### 1.1 Create Supabase Project
1. Go to [https://supabase.com](https://supabase.com) and sign up/login
2. Click "New Project"
3. Enter project details:
   - **Name**: `command-center`
   - **Database Password**: Choose a secure password
   - **Region**: Choose closest region (e.g., `US East (North Virginia)`)
4. Click "Create new project"

### 1.2 Get Your Credentials
After creation, go to **Project Settings** → **API**:
- **Project URL**: `https://bgtpfnmxscrbbgmqavup.supabase.co` (you already have this)
- **anon/public key**: `sb_publishable_42DAkhFFQWY5fDiLLW1YPQ_877oL-7E` (you already have this)
- **service_role key**: (Keep this secret - for backend only)

### 1.3 Set Up Database Schema
1. Go to **SQL Editor** in Supabase dashboard
2. Create a new query
3. Copy and paste the SQL from `backend/schema.sql`:
   ```sql
   -- Create projects table
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

   -- Enable Row Level Security (RLS)
   ALTER TABLE projects ENABLE ROW LEVEL SECURITY;

   -- Create policy for public read access (adjust for production)
   CREATE POLICY "Allow public read access" ON projects
     FOR SELECT USING (true);

   -- Create policy for public insert/update/delete (adjust for production)
   CREATE POLICY "Allow public write access" ON projects
     FOR ALL USING (true);
   ```
4. Click "Run"
5. Verify table was created in **Table Editor**

### 1.4 Configure Authentication (Optional)
For production, you should:
1. Go to **Authentication** → **Policies**
2. Set up proper RLS policies
3. Consider adding user authentication

## Step 2: Deploy Backend (Optional - Enhanced API)

The frontend connects directly to Supabase, but you can also deploy the Node.js backend for additional functionality:

### Option A: Deploy to Railway (Recommended)
```bash
cd backend
railway init
railway link
railway up
```

### Option B: Deploy to Vercel
1. Install Vercel CLI: `npm i -g vercel`
2. Deploy: `cd backend && vercel`
3. Set environment variables in Vercel dashboard

### Environment Variables for Backend
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_SERVICE_ROLE_KEY`: Service role key (from Supabase API settings)
- `PORT`: Railway/Vercel sets this automatically

## Step 3: Deploy Frontend

### Option A: Deploy to Railway (Simple)
```bash
cd frontend
railway init
railway link
railway up
```

### Option B: Deploy to Vercel (Static Hosting)
```bash
cd frontend
vercel
```

### Option C: Deploy to Netlify
1. Drag and drop the `frontend` folder to Netlify
2. Or use Netlify CLI

## Step 4: Update Frontend Configuration

### If using direct Supabase connection (current setup):
The frontend already has your Supabase credentials hardcoded in `index.html`. For production:

1. **Remove hardcoded credentials** from HTML
2. **Use environment variables** instead
3. **Set up proper CORS** in Supabase:
   - Go to **Authentication** → **URL Configuration**
   - Add your frontend domain to "Additional Redirect URLs"

### Environment Variables for Frontend:
- `SUPABASE_URL`: Your Supabase project URL
- `SUPABASE_ANON_KEY`: Your anon/public key

## Step 5: Test the Application

1. **Open frontend URL** in browser
2. **Check Supabase connection** (green badge in top-right)
3. **Verify projects load** from database
4. **Test real-time updates** (open in two browsers)

## Security Considerations

### For Development:
- Current setup uses public RLS policies (anyone can read/write)
- This is OK for development/demo

### For Production:
1. **Enable proper RLS policies** in Supabase
2. **Add user authentication**
3. **Use environment variables** for credentials
4. **Set up CORS properly**
5. **Consider using the backend API** instead of direct Supabase connection

## API Endpoints

### Direct Supabase API:
- `GET /rest/v1/projects` - Get all projects
- `GET /rest/v1/projects?id=eq.1` - Get single project
- `POST /rest/v1/projects` - Create project
- `PATCH /rest/v1/projects?id=eq.1` - Update project
- `DELETE /rest/v1/projects?id=eq.1` - Delete project

### Custom Backend API (if deployed):
- `GET /api/projects` - Get all projects
- `GET /api/projects/:id` - Get single project
- `POST /api/projects` - Create project
- `PUT /api/projects/:id` - Update project
- `DELETE /api/projects/:id` - Delete project

## Troubleshooting

### 1. "Failed to fetch" error
- Check CORS settings in Supabase
- Verify Supabase URL and key are correct
- Check browser console for detailed errors

### 2. "Table does not exist" error
- Run the SQL schema in Supabase SQL Editor
- Verify table was created in Table Editor

### 3. Real-time not working
- Check if real-time is enabled in Supabase
- Go to **Database** → **Replication**
- Enable replication for the `projects` table

### 4. Deployment issues
- Check Railway/Vercel logs
- Verify environment variables are set
- Check port configuration

## Local Development

### Backend (Optional):
```bash
cd backend
npm install
# Create .env file with Supabase credentials
echo "SUPABASE_URL=https://bgtpfnmxscrbbgmqavup.supabase.co" > .env
echo "SUPABASE_SERVICE_ROLE_KEY=your_service_role_key" >> .env
npm start
```

### Frontend:
```bash
cd frontend
npm install
node server.js
# Open http://localhost:3000
```

## Support
- Supabase Docs: https://supabase.com/docs
- Railway Docs: https://docs.railway.app
- Project Issues: GitHub repository