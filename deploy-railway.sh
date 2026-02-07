#!/bin/bash

echo "🚀 Command Center - Railway Deployment"
echo "======================================"
echo ""

# Check if in correct directory
if [ ! -f "backend/railway.json" ] || [ ! -f "frontend/railway.json" ]; then
    echo "❌ Error: Must run from Command-Center root directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo "📋 Prerequisites Checklist:"
echo "1. ✅ GitHub repository: https://github.com/superdividenz/Command-Center"
echo "2. 🔄 Railway account: https://railway.app"
echo "3. 🐘 Supabase project: https://bgtpfnmxscrbbgmqavup.supabase.co"
echo ""

echo "📦 Step 1: Push to GitHub"
echo "-------------------------"
read -p "Do you want to push latest changes to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Checking Git status..."
    git status
    
    read -p "Commit message [Update for Railway deployment]: " commit_msg
    commit_msg=${commit_msg:-"Update for Railway deployment"}
    
    echo "Committing changes..."
    git add .
    git commit -m "$commit_msg"
    
    echo "Pushing to GitHub..."
    git push origin main
    
    echo "✅ Pushed to GitHub!"
else
    echo "⏭️ Skipping GitHub push"
fi

echo ""
echo "🚂 Step 2: Deploy to Railway"
echo "---------------------------"
echo ""
echo "You have two options:"
echo ""
echo "A) Use Railway Dashboard (Recommended for first time):"
echo "   1. Go to https://railway.app"
echo "   2. Click 'New Project'"
echo "   3. Select 'Deploy from GitHub repo'"
echo "   4. Choose 'superdividenz/Command-Center'"
echo "   5. For backend: Set Root Directory to 'backend'"
echo "   6. For frontend: Add New Service → Set Root Directory to 'frontend'"
echo ""
echo "B) Use Railway CLI:"
echo "   # Install CLI"
echo "   npm i -g @railway/cli"
echo "   "
echo "   # Login"
echo "   railway login"
echo "   "
echo "   # Deploy backend"
echo "   cd backend && railway up"
echo "   "
echo "   # Deploy frontend"
echo "   cd ../frontend && railway up"
echo ""

echo "🔧 Step 3: Configure Environment Variables"
echo "-----------------------------------------"
echo ""
echo "After deployment, set these in Railway dashboard:"
echo ""
echo "Backend Service → Variables:"
echo "  SUPABASE_URL=https://bgtpfnmxscrbbgmqavup.supabase.co"
echo "  SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key"
echo ""
echo "Frontend Service → Variables:"
echo "  (Optional) Update Supabase URL in index.html if using different project"
echo ""

echo "🌐 Step 4: Configure Domains"
echo "---------------------------"
echo ""
echo "1. Backend service → Settings → Networking → Generate domain"
echo "2. Frontend service → Settings → Networking → Generate domain"
echo "3. Note both URLs for testing"
echo ""

echo "🧪 Step 5: Test Deployment"
echo "-------------------------"
echo ""
echo "Test backend:"
echo "  curl https://your-backend-domain.up.railway.app/health"
echo ""
echo "Test frontend:"
echo "  Open https://your-frontend-domain.up.railway.app in browser"
echo ""

echo "🔒 Step 6: Security Configuration"
echo "--------------------------------"
echo ""
echo "1. Supabase → Authentication → URL Configuration"
echo "   Add frontend domain to 'Additional Redirect URLs'"
echo "2. Supabase → Authentication → Policies"
echo "   Set up proper Row Level Security (RLS)"
echo ""

echo "🎉 Deployment Complete!"
echo ""
echo "Quick Reference:"
echo "- Backend: Manages API with Supabase"
echo "- Frontend: Direct Supabase connection"
echo "- Database: PostgreSQL via Supabase"
echo "- Hosting: Railway"
echo ""
echo "For detailed instructions, see RAILWAY_DEPLOY.md"
echo ""
echo "Need help?"
echo "- Railway Docs: https://docs.railway.app"
echo "- Supabase Docs: https://supabase.com/docs"
echo "- GitHub Issues: https://github.com/superdividenz/Command-Center/issues"