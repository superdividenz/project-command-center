#!/bin/bash

echo "🚀 Command Center - Complete Deployment"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if in correct directory
if [ ! -f "backend/railway.json" ] || [ ! -f "frontend/railway.json" ]; then
    echo -e "${RED}❌ Error: Must run from Command-Center root directory${NC}"
    echo "   Current directory: $(pwd)"
    exit 1
fi

echo -e "${BLUE}📋 Deployment Checklist:${NC}"
echo "1. ✅ GitHub repository ready"
echo "2. 🔄 Railway account configured"
echo "3. 🐘 Supabase project active"
echo ""

echo -e "${YELLOW}📦 Step 1: Push to GitHub${NC}"
echo "-------------------------"
read -p "Push latest changes to GitHub? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Checking Git status..."
    git status
    
    read -p "Commit message [Command Center deployment]: " commit_msg
    commit_msg=${commit_msg:-"Command Center deployment"}
    
    echo "Committing changes..."
    git add .
    git commit -m "$commit_msg"
    
    echo "Pushing to GitHub..."
    if git push origin main; then
        echo -e "${GREEN}✅ Successfully pushed to GitHub!${NC}"
    else
        echo -e "${RED}❌ Failed to push to GitHub${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⏭️ Skipping GitHub push${NC}"
fi

echo ""
echo -e "${YELLOW}🚂 Step 2: Deploy to Railway${NC}"
echo "---------------------------"
echo ""
echo -e "${BLUE}Option A: Using Railway Dashboard (Recommended)${NC}"
echo ""
echo "1. Go to https://railway.app"
echo "2. Click 'New Project'"
echo "3. Select 'Deploy from GitHub repo'"
echo "4. Choose 'superdividenz/Command-Center'"
echo "5. For backend: Set Root Directory to 'backend'"
echo "6. For frontend: Add New Service → Set Root Directory to 'frontend'"
echo ""
echo -e "${BLUE}Option B: Using Railway CLI${NC}"
echo ""
echo "First, install Railway CLI:"
echo "  npm i -g @railway/cli"
echo ""
echo "Then deploy:"
echo "  # Deploy backend"
echo "  cd backend && railway up"
echo ""
echo "  # Deploy frontend"
echo "  cd ../frontend && railway up"
echo ""

echo -e "${YELLOW}🔧 Step 3: Configure Environment Variables${NC}"
echo "-----------------------------------------"
echo ""
echo -e "${BLUE}Backend Service → Variables:${NC}"
echo "  SUPABASE_URL=https://bgtpfnmxscrbbgmqavup.supabase.co"
echo "  SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key"
echo "  PORT=3001 (auto-set by Railway)"
echo ""
echo -e "${BLUE}Frontend Service:${NC}"
echo "  No variables needed (connects directly to Supabase)"
echo ""

echo -e "${YELLOW}🗄️ Step 4: Set Up Database${NC}"
echo "----------------------------"
echo ""
echo "1. Go to Supabase Dashboard: https://app.supabase.com"
echo "2. Select your project"
echo "3. Go to 'SQL Editor'"
echo "4. Run the SQL from 'backend/schema.sql'"
echo "5. (Optional) Run 'backend/communication-schema.sql' for full features"
echo "6. Verify tables in 'Table Editor'"
echo ""

echo -e "${YELLOW}🌐 Step 5: Configure Domains & CORS${NC}"
echo "--------------------------------------"
echo ""
echo "1. Backend service → Settings → Networking → Generate domain"
echo "2. Frontend service → Settings → Networking → Generate domain"
echo "3. Supabase → Authentication → URL Configuration"
echo "   Add frontend domain to 'Additional Redirect URLs'"
echo ""

echo -e "${YELLOW}🧪 Step 6: Test Deployment${NC}"
echo "-------------------------"
echo ""
echo "Test backend:"
echo "  curl https://your-backend-domain.up.railway.app/health"
echo ""
echo "Test frontend:"
echo "  Open https://your-frontend-domain.up.railway.app in browser"
echo ""

echo -e "${YELLOW}🔒 Step 7: Security Configuration${NC}"
echo "--------------------------------"
echo ""
echo "1. Supabase → Authentication → Policies"
echo "   Set up Row Level Security (RLS)"
echo "2. Railway → Project Settings → Environment"
echo "   Review and secure all environment variables"
echo ""

echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo ""
echo -e "${BLUE}Quick Reference:${NC}"
echo "- Backend URL: https://command-center-backend.up.railway.app"
echo "- Frontend URL: https://command-center-frontend.up.railway.app"
echo "- Supabase: https://bgtpfnmxscrbbgmqavup.supabase.co"
echo "- GitHub: https://github.com/superdividenz/Command-Center"
echo ""
echo -e "${BLUE}Database Tables:${NC}"
echo "1. projects - Project management"
echo "2. users - User accounts"
echo "3. tasks - Task tracking"
echo "4. messages - Communication"
echo "5. files - Attachments"
echo ""
echo -e "${YELLOW}Need help?${NC}"
echo "- Railway Docs: https://docs.railway.app"
echo "- Supabase Docs: https://supabase.com/docs"
echo "- GitHub Issues: https://github.com/superdividenz/Command-Center/issues"
echo ""
echo -e "${GREEN}Your Command Center is now ready for communication and project management! 🚀${NC}"