#!/bin/bash
set -e

echo "🚀 Starting Railway deployment..."

# Install dependencies if needed
if [ ! -d "vendor" ]; then
    echo "📦 Installing Composer dependencies..."
    composer install --optimize-autoloader --no-dev --no-interaction
fi

# Create storage directories and set permissions
echo "📁 Setting up storage directories..."
mkdir -p storage/framework/{sessions,views,cache,testing}
mkdir -p storage/logs
mkdir -p bootstrap/cache
chmod -R 775 storage bootstrap/cache

# Create storage link if it doesn't exist
if [ ! -L "public/storage" ]; then
    echo "🔗 Creating storage link..."
    php artisan storage:link || echo "Storage link already exists or failed"
fi

# Clear any cached config first (important!)
echo "🧹 Clearing cached config..."
php artisan config:clear || echo "Config clear failed"
php artisan route:clear || echo "Route clear failed"
php artisan view:clear || echo "View clear failed"
php artisan cache:clear || echo "Cache clear failed"

# Test database connection
echo "🔌 Testing database connection..."
php artisan db:show || echo "⚠️  Database connection test failed"

# Run migrations
echo "🗄️  Running database migrations..."
php artisan migrate --force --no-interaction || echo "⚠️  Migration failed or no migrations to run"

# DON'T cache config in production - it can cause issues with Railway env vars
echo "⚡ Optimizing routes and views..."
php artisan route:cache
php artisan view:cache

# Test that the app can boot
echo "🧪 Testing application..."
php artisan about || echo "⚠️  App test failed"

# Start the application using PHP built-in server
# Railway provides the PORT environment variable
echo "🌐 Starting web server on port ${PORT:-8000}..."
echo "📍 Document root: public/"
echo "🔧 Environment: ${APP_ENV:-production}"
echo "🔍 Logs will be sent to stderr"
echo ""
echo "✅ Server starting..."

# Use PHP built-in server directly (more reliable than artisan serve)
# The -t flag sets the document root to public/
cd /app && exec php -S 0.0.0.0:${PORT:-8000} -t public/ 2>&1

