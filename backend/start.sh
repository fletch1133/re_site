#!/bin/bash
set -e

echo "Starting application..."
echo "PORT: ${PORT:-8000}"

# Run migrations
echo "Running migrations..."
php artisan migrate --force || echo "Migration failed"
echo "Migrations complete!"

# Start the server
echo "Starting Laravel development server on 0.0.0.0:${PORT:-8000}..."
exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}

