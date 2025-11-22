FROM php:8.2-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpq-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nodejs \
    npm

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev --no-interaction

# Install npm dependencies and build
RUN npm install && npm run build

# Create storage directories
RUN mkdir -p storage/framework/{sessions,views,cache,testing} storage/logs bootstrap/cache && \
    chmod -R 777 storage bootstrap/cache

EXPOSE 8000

# Start command - use exec form to ensure proper signal handling
CMD ["sh", "-c", "php artisan migrate --force && (php artisan db:seed --force || true) && php artisan storage:link && php artisan serve --host=0.0.0.0 --port=${PORT:-8000}"]

