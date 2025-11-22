#!/bin/bash

echo "🚂 Railway Deployment Preparation Script"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -d "backend" ]; then
    echo "❌ Error: backend directory not found!"
    echo "Please run this script from the project root directory."
    exit 1
fi

echo "✅ Found backend directory"
echo ""

# Generate APP_KEY
echo "📝 Generating APP_KEY..."
cd backend

if [ ! -f "artisan" ]; then
    echo "❌ Error: artisan file not found in backend directory!"
    exit 1
fi

APP_KEY=$(php artisan key:generate --show)

if [ $? -eq 0 ]; then
    echo "✅ APP_KEY generated successfully!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔑 YOUR APP_KEY (copy this to Railway):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "$APP_KEY"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
    echo "❌ Error generating APP_KEY"
    exit 1
fi

cd ..

echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Copy the APP_KEY above"
echo "2. Go to Railway → Your Service → Variables"
echo "3. Add environment variable: APP_KEY = [paste the key]"
echo ""
echo "4. Set these other required variables in Railway:"
echo "   - APP_ENV=production"
echo "   - APP_DEBUG=false"
echo "   - APP_URL=https://resite-production.up.railway.app"
echo "   - FRONTEND_URL=https://your-vercel-app.vercel.app"
echo "   - LOG_CHANNEL=stderr"
echo "   - LOG_LEVEL=error"
echo ""
echo "5. Add PostgreSQL database to your Railway project"
echo ""
echo "6. Set database variables (use Railway references):"
echo "   - DB_CONNECTION=pgsql"
echo "   - DB_HOST=\${{Postgres.PGHOST}}"
echo "   - DB_PORT=\${{Postgres.PGPORT}}"
echo "   - DB_DATABASE=\${{Postgres.PGDATABASE}}"
echo "   - DB_USERNAME=\${{Postgres.PGUSER}}"
echo "   - DB_PASSWORD=\${{Postgres.PGPASSWORD}}"
echo ""
echo "7. Set Root Directory to: backend"
echo ""
echo "8. Push your code to GitHub to trigger deployment"
echo ""
echo "📚 For detailed instructions, see:"
echo "   - RAILWAY_DEPLOYMENT_CHECKLIST.md"
echo "   - RAILWAY_SETUP.md"
echo "   - RAILWAY_TROUBLESHOOTING.md"
echo ""
echo "✨ Good luck with your deployment!"

