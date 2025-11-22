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

# Start the application
# Railway provides the PORT environment variable
PORT=${PORT:-8000}
echo "🌐 Starting web server on port ${PORT}..."
echo "📍 Document root: public/"
echo "🔧 Environment: ${APP_ENV:-production}"
echo "🔗 Server will be available at: http://0.0.0.0:${PORT}"
echo ""

# Test if we can reach the app before starting the server
echo "🧪 Testing if Laravel can boot..."
php -r "require 'vendor/autoload.php'; echo 'PHP OK\n';" || echo "⚠️  PHP test failed"

# Test if we can load the Laravel app
echo "🧪 Testing Laravel bootstrap..."
php artisan --version || echo "⚠️  Laravel bootstrap failed"

echo ""
echo "✅ Starting server with PHP built-in server..."
echo "📝 Request logs will appear below:"
echo ""

# Use PHP built-in server with Laravel's server.php router
# This is more reliable than artisan serve for production
exec php -S 0.0.0.0:${PORT} -t public server.php 2>&1

