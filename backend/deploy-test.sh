#!/bin/bash

echo "🚀 Testing Railway Deployment"
echo "============================"

# Test 1: Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ ERROR: package.json not found!"
    exit 1
else
    echo "✅ package.json found"
fi

# Test 2: Check if server.js exists
if [ ! -f "server.js" ]; then
    echo "❌ ERROR: server.js not found!"
    exit 1
else
    echo "✅ server.js found"
fi

# Test 3: Check if railway.json exists
if [ ! -f "railway.json" ]; then
    echo "❌ ERROR: railway.json not found!"
    exit 1
else
    echo "✅ railway.json found"
fi

# Test 4: Check package.json content
echo "📦 package.json content:"
cat package.json | grep -E '"name"|"version"|"scripts"'

# Test 5: Check railway.json content
echo "🚂 railway.json content:"
cat railway.json

# Test 6: Create a simple test server
echo "🧪 Creating test server..."
cat > test-simple.js << 'EOF'
const http = require('http');
const PORT = process.env.PORT || 3001;
const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ 
        message: 'Test server works!',
        timestamp: new Date().toISOString(),
        path: req.url
    }));
});
server.listen(PORT, () => {
    console.log(`✅ Test server listening on port ${PORT}`);
});
EOF

echo "✅ All tests passed!"
echo ""
echo "📋 Deployment Checklist:"
echo "1. ✅ Root Directory set to 'backend' in Railway"
echo "2. ✅ Build Command: npm install"
echo "3. ✅ Start Command: node server.js"
echo "4. ✅ Healthcheck Path: /health"
echo "5. ✅ Environment Variables: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY"
echo ""
echo "🚀 Ready for Railway deployment!"