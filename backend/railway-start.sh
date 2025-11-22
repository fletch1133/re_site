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

# Run migrations
echo "🗄️  Running database migrations..."
php artisan migrate --force --no-interaction || echo "⚠️  Migration failed or no migrations to run"

# Cache config for production
echo "⚡ Optimizing application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start the application using PHP's built-in server
# Railway provides the PORT environment variable
echo "🌐 Starting web server on port ${PORT:-8000}..."
echo "📍 Document root: public/"
echo "🔧 Environment: ${APP_ENV:-production}"

# Use PHP built-in server with public directory as document root
php -S 0.0.0.0:${PORT:-8000} -t public/

