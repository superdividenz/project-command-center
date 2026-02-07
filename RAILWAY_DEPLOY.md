# Railway Deployment Guide

## Command Center Deployment to Railway

This guide will help you deploy both the backend and frontend of your Command Center to Railway.

## Prerequisites

1. **Railway Account** - Sign up at [railway.app](https://railway.app)
2. **GitHub Account** - Your project is at `https://github.com/superdividenz/Command-Center`
3. **Supabase Account** (for database) - Already set up

## Step 1: Deploy Backend to Railway

### Option A: Using Railway Dashboard
1. Go to [Railway Dashboard](https://railway.app)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Connect your GitHub account if not already connected
5. Select the `superdividenz/Command-Center` repository
6. Configure deployment:
   - **Root Directory**: `backend`
   - Railway will automatically detect the `railway.json` file
7. Click **"Deploy"**

### Option B: Using Railway CLI
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login to Railway
railway login

# Initialize project
railway init

# Link to existing project or create new
railway link

# Deploy backend
railway up
```

### Backend Environment Variables
After deployment, set these environment variables in Railway dashboard:

1. Go to your backend service → **Variables** tab
2. Add the following:
   ```
   SUPABASE_URL=https://bgtpfnmxscrbbgmqavup.supabase.co
   SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
   PORT=3001 (Railway sets this automatically, but good to have)
   ```

## Step 2: Deploy Frontend to Railway

### Option A: Using Railway Dashboard
1. In the same Railway project, click **"New Service"**
2. Select **"Deploy from GitHub repo"**
3. Select the same repository
4. Configure deployment:
   - **Root Directory**: `frontend`
5. Click **"Deploy"**

### Option B: Using Railway CLI
```bash
# Navigate to frontend directory
cd frontend

# Deploy frontend as separate service
railway up
```

### Frontend Configuration
The frontend connects directly to Supabase, so no backend URL is needed. However, you might want to update the Supabase URL in `frontend/index.html` if using a different Supabase project.

## Step 3: Configure Domains

### Backend Domain
1. Go to backend service → **Settings** → **Networking**
2. Click **"Generate domain"**
3. Copy the domain (e.g., `https://command-center-backend.up.railway.app`)

### Frontend Domain
1. Go to frontend service → **Settings** → **Networking**
2. Click **"Generate domain"**
3. Copy the domain (e.g., `https://command-center-frontend.up.railway.app`)

## Step 4: Test the Deployment

### Test Backend
```bash
# Check backend health
curl https://your-backend-domain.up.railway.app/health

# Should return:
# {"status":"ok","service":"command-center-api","supabase":"connected"}
```

### Test Frontend
1. Open your frontend URL in browser
2. You should see the Command Center dashboard
3. Check connection status (green badge in top-right)

## Step 5: Database Setup (Supabase)

Since we're using Supabase, the database is already set up. Just ensure:

1. Your Supabase project is active
2. The `projects` table exists (run SQL from `backend/schema.sql`)
3. CORS is configured in Supabase for your frontend domain

### Supabase CORS Configuration
1. Go to Supabase Dashboard → **Authentication** → **URL Configuration**
2. Add your frontend domain to **"Additional Redirect URLs"**
3. Add to **"Site URL"** as well

## Step 6: Continuous Deployment

Railway automatically deploys when you push to GitHub. To trigger a manual deployment:

```bash
# Push changes to GitHub
git add .
git commit -m "Update for Railway deployment"
git push origin main

# Railway will automatically deploy both services
```

## Troubleshooting

### Backend Issues
1. **Database connection failed**
   - Check Supabase URL and service role key
   - Verify Supabase project is active
   - Check Railway logs for connection errors

2. **Port already in use**
   - Railway sets PORT automatically
   - Don't hardcode port in code

3. **Build failed**
   - Check `backend/package.json` dependencies
   - Verify Node.js version compatibility

### Frontend Issues
1. **Cannot connect to Supabase**
   - Check Supabase URL in `index.html`
   - Verify CORS settings in Supabase
   - Check browser console for errors

2. **Static files not serving**
   - Check `frontend/server.js` configuration
   - Verify Railway is using correct start command

3. **404 errors**
   - Ensure SPA routing is configured in `server.js`

### Railway CLI Issues
```bash
# Check Railway status
railway status

# View logs
railway logs

# Restart service
railway restart
```

## Monitoring

### Railway Dashboard
- **Metrics**: CPU, Memory, Network usage
- **Logs**: Real-time application logs
- **Deployments**: Deployment history and status

### Custom Domains
To use custom domains (e.g., `command-center.yourdomain.com`):
1. Go to service → **Settings** → **Networking**
2. Click **"Add domain"**
3. Follow DNS configuration instructions

## Cost Management

Railway offers:
- **Free tier**: $5 credit monthly, suitable for small projects
- **Pay-as-you-go**: After free credits
- **Team plans**: For collaborative projects

Monitor usage in **Project Settings** → **Usage**.

## Backup and Recovery

### Database Backups
Since we use Supabase:
1. Supabase automatically backs up PostgreSQL
2. Manual backups available in Supabase dashboard
3. Point-in-time recovery supported

### Code Backups
- GitHub provides code backup
- Railway keeps deployment history
- Use `railway logs --download` to save logs

## Security Best Practices

1. **Environment Variables**
   - Never commit secrets to GitHub
   - Use Railway Variables for all secrets
   - Rotate Supabase keys regularly

2. **API Security**
   - Use Supabase Row Level Security (RLS)
   - Implement rate limiting if needed
   - Use HTTPS only

3. **Dependencies**
   - Keep dependencies updated
   - Use `npm audit` regularly
   - Monitor for security vulnerabilities

## Support

- **Railway Docs**: https://docs.railway.app
- **GitHub Issues**: https://github.com/superdividenz/Command-Center/issues
- **Supabase Docs**: https://supabase.com/docs

## Quick Reference

```bash
# Deploy both services
cd backend && railway up
cd ../frontend && railway up

# Check status
railway status

# View logs
railway logs -f

# Set environment variables
railway variables set SUPABASE_URL=your_url

# Open in browser
railway open
```

Your Command Center is now deployed and ready to use! 🚀