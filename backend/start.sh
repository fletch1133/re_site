#!/bin/bash
set -e

echo "Starting application..."
echo "PORT: ${PORT:-8000}"
echo "DB_CONNECTION: ${DB_CONNECTION}"
echo "DB_HOST: ${DB_HOST}"

# Run migrations
echo "Running migrations..."
php artisan migrate --force
echo "Migrations complete!"

# Seed database (optional)
echo "Seeding database..."
php artisan db:seed --force || echo "Seeding skipped or failed"

# Create storage link
echo "Creating storage link..."
php artisan storage:link || echo "Storage link already exists or failed"

# Start the server
echo "Starting Laravel development server on 0.0.0.0:${PORT:-8000}..."
exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}

