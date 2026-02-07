# Command Center 🚀

A modern project management dashboard built with **Supabase** for real-time database and backend services. The frontend connects directly to Supabase using the Supabase JavaScript client.

## Features

- 📊 **Real-time Dashboard** - Live updates when projects change
- 🎯 **Project Tracking** - Planning, In Progress, Blocked, Completed statuses
- 📈 **Progress Monitoring** - Visual progress bars with gradients
- ⚡ **Priority Management** - High, Medium, Low priority indicators
- ✅ **Task Management** - Next actions and due dates
- 📱 **Responsive Design** - Works on all devices
- 🔄 **Real-time Sync** - Instant updates across all clients
- 🐘 **PostgreSQL Database** - Powered by Supabase
- 🔒 **Secure** - Row Level Security ready

## Live Demo

- **GitHub Repository**: https://github.com/superdividenz/Command-Center
- **Railway Deployment**: [Deploy using RAILWAY_DEPLOY.md]
- **Supabase Project**: `https://bgtpfnmxscrbbgmqavup.supabase.co`
- **Database**: PostgreSQL managed by Supabase

## Architecture

```
┌─────────────────┐     ┌─────────────┐
│   Frontend      │────▶│   Supabase  │
│   (HTML/JS)     │◀────│   (API)     │
└─────────────────┘     └─────────────┘
       │                       │
       │      Real-time        │
       │      WebSocket        │
       └───────────────────────┘
```

## Tech Stack

### Frontend
- **HTML5/CSS3** - Modern, responsive design
- **JavaScript ES6+** - Vanilla JS with async/await
- **Supabase JS Client** - Real-time database client
- **Express** - Simple static server for deployment

### Backend & Database
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Relational database
- **Row Level Security** - Data security policies
- **Real-time Subscriptions** - WebSocket updates

### Deployment
- **Railway** - Full-stack hosting (backend + frontend)
- **Supabase** - Database & backend API hosting
- **GitHub** - Source code and version control

## Quick Start

### 1. Clone the repository
```bash
git clone https://github.com/superdividenz/Command-Center.git
cd Command-Center
```

### 2. Set up Supabase Database
1. Go to [Supabase](https://supabase.com) and create a project
2. Copy your `SUPABASE_URL` and `SUPABASE_ANON_KEY`
3. Run the SQL from `backend/schema.sql` in Supabase SQL Editor
4. Update `frontend/index.html` with your Supabase credentials

### 3. Run Frontend Locally
```bash
cd frontend
npm install
node server.js
# Open http://localhost:3000
```

### 4. Deploy to Production
```bash
# Deploy frontend to Railway
cd frontend
railway init
railway up

# Or deploy to Vercel
vercel
```

## Project Structure

```
Command-Center/
├── frontend/               # Frontend dashboard
│   ├── index.html         # Main dashboard (Supabase client)
│   ├── server.js          # Express static server
│   ├── package.json       # Dependencies
│   └── railway.json       # Railway deployment config
├── backend/               # Optional Node.js backend
│   ├── server.js          # Enhanced API server
│   ├── schema.sql         # Database schema
│   ├── package.json       # Dependencies
│   └── railway.json       # Railway deployment config
├── SUPABASE_DEPLOY.md     # Supabase deployment guide
├── setup-supabase.sh      # Setup script
└── README.md              # This file
```

## Database Schema

### Projects Table
```sql
CREATE TABLE projects (
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
```

## Sample Data

The database includes 4 sample projects:

1. **Physician Monitoring System** - 80% complete, High priority
2. **Mr_Staffr AI Platform** - 20% complete, High priority  
3. **Moltbook Agent** - 90% complete, Medium priority, Blocked
4. **Blockchain P&L Tracking** - 70% complete, Medium priority

## API Access

### Direct Supabase REST API:
```javascript
// Get all projects
fetch('https://bgtpfnmxscrbbgmqavup.supabase.co/rest/v1/projects', {
  headers: {
    'apikey': 'sb_publishable_42DAkhFFQWY5fDiLLW1YPQ_877oL-7E',
    'Authorization': 'Bearer sb_publishable_42DAkhFFQWY5fDiLLW1YPQ_877oL-7E'
  }
})
```

### Supabase JavaScript Client:
```javascript
const { data: projects, error } = await supabase
  .from('projects')
  .select('*')
  .order('created_at', { ascending: false });
```

## Real-time Updates

The dashboard automatically subscribes to real-time changes:
```javascript
const subscription = supabase
  .channel('projects-changes')
  .on('postgres_changes', 
    { event: '*', schema: 'public', table: 'projects' }, 
    () => loadProjects() // Reload when changes occur
  )
  .subscribe();
```

## Security

### Development Mode:
- Public read/write access enabled
- Suitable for demos and testing

### Production Mode:
1. Enable Row Level Security (RLS) in Supabase
2. Create proper RLS policies
3. Add user authentication
4. Use environment variables for credentials
5. Configure CORS properly

## Deployment Options

### Railway (Recommended):
- **Full-stack deployment** - Both backend and frontend
- **Automatic scaling** - Handles traffic spikes
- **Continuous deployment** - Deploys on git push
- **Free tier available** - $5 monthly credit

See [RAILWAY_DEPLOY.md](RAILWAY_DEPLOY.md) for complete deployment guide.

### Alternative Hosting:
- **Frontend**: Vercel, Netlify, GitHub Pages
- **Backend**: Railway, Heroku, Render
- **Database**: Supabase (included), Railway PostgreSQL, Neon

### Backend/Database:
- **Supabase** - Handles database, auth, and real-time

## Environment Variables

### Frontend (set in hosting platform):
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### Backend (optional - for enhanced API):
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
PORT=3001
```

## Development

### Local Development:
```bash
# Frontend
cd frontend
npm install
node server.js

# Backend (optional)
cd backend
npm install
echo "SUPABASE_URL=your-url" > .env
echo "SUPABASE_SERVICE_ROLE_KEY=your-key" >> .env
npm start
```

### Database Migration:
1. Open Supabase SQL Editor
2. Run SQL from `backend/schema.sql`
3. Verify in Table Editor

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - see LICENSE file for details

## Support

- Supabase Documentation: https://supabase.com/docs
- Railway Documentation: https://docs.railway.app
- Project Issues: GitHub repository

---

**Built with ❤️ using Supabase for real-time project management**