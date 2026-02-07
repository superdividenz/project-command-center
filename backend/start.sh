#!/bin/bash

echo "🚀 Starting Command Center Backend..."
echo "====================================="

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Check for required environment variables
if [ -z "$SUPABASE_URL" ]; then
    echo "⚠️  WARNING: SUPABASE_URL environment variable not set"
    echo "   The app will start but won't be able to connect to Supabase"
fi

if [ -z "$SUPABASE_SERVICE_ROLE_KEY" ]; then
    echo "⚠️  WARNING: SUPABASE_SERVICE_ROLE_KEY environment variable not set"
    echo "   The app will start but won't be able to authenticate with Supabase"
fi

# Set default port if not provided
if [ -z "$PORT" ]; then
    export PORT=3001
    echo "📡 Using default port: $PORT"
else
    echo "📡 Using port from environment: $PORT"
fi

# Start the server
echo "🚀 Starting Node.js server on port $PORT..."
echo "🔌 Supabase URL: ${SUPABASE_URL:-Not configured}"
echo "🔑 Supabase Key: ${SUPABASE_SERVICE_ROLE_KEY:0:10}... (truncated)"

# Start the application
exec node server.js