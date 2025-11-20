# Quick Deployment Commands Reference

## Frontend Deployment

### Build for Production
```bash
cd frontend
npm install
npm run build
```

This creates a `dist` folder ready for deployment.

### Deploy to Vercel
```bash
cd frontend
npm i -g vercel
vercel
```

### Deploy to Netlify
```bash
cd frontend
npm i -g netlify-cli
netlify deploy --prod
```

### Test Production Build Locally
```bash
cd frontend
npm run build
npm run preview
```

## Backend Deployment

### Initial Setup on Server
```bash
# Clone repository
git clone your-repo-url /var/www/your-site
cd /var/www/your-site/backend

# Install dependencies
composer install --optimize-autoloader --no-dev

# Set up environment
cp .env.production.example .env
nano .env  # Edit with your settings

# Generate key
php artisan key:generate

# Set permissions
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache

# Run migrations
php artisan migrate --force

# Create storage link
php artisan storage:link

# Optimize
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Update Existing Deployment
```bash
cd /var/www/your-site/backend

# Pull latest code
git pull origin main

# Update dependencies
composer install --optimize-autoloader --no-dev

# Run migrations
php artisan migrate --force

# Clear and recache
php artisan config:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Restart services (if needed)
sudo systemctl restart php8.2-fpm
sudo systemctl reload nginx
```

## Database Commands

### Create Database (MySQL)
```bash
mysql -u root -p
CREATE DATABASE your_database_name;
CREATE USER 'your_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON your_database_name.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Run Migrations
```bash
php artisan migrate --force
```

### Rollback Migration
```bash
php artisan migrate:rollback
```

### Fresh Migration (WARNING: Deletes all data)
```bash
php artisan migrate:fresh --force
```

## Cache Commands

### Clear All Caches
```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

### Rebuild Caches
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

## File Permissions

### Set Correct Permissions
```bash
# From project root
cd backend
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### Fix Storage Link
```bash
php artisan storage:link
```

## Nginx Configuration Example

```nginx
server {
    listen 80;
    server_name api.yoursite.com;
    root /var/www/your-site/backend/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

## SSL Setup (Let's Encrypt)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d api.yoursite.com

# Auto-renewal is set up automatically
# Test renewal:
sudo certbot renew --dry-run
```

## Troubleshooting Commands

### Check Laravel Logs
```bash
tail -f storage/logs/laravel.log
```

### Check Nginx Logs
```bash
tail -f /var/log/nginx/error.log
```

### Check PHP-FPM Status
```bash
sudo systemctl status php8.2-fpm
```

### Restart Services
```bash
sudo systemctl restart nginx
sudo systemctl restart php8.2-fpm
```

### Test Nginx Configuration
```bash
sudo nginx -t
```

## Environment Variables

### Set in Vercel (Frontend)
```bash
vercel env add VITE_API_BASE_URL
vercel env add VITE_STORAGE_BASE_URL
```

### Set in Netlify (Frontend)
Go to: Site Settings → Environment Variables → Add Variable

## Git Commands

### Deploy from Git
```bash
git pull origin main
composer install --no-dev
php artisan migrate --force
php artisan config:cache
```

### Tag a Release
```bash
git tag -a v1.0.0 -m "Production release v1.0.0"
git push origin v1.0.0
```

