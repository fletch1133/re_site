# Deployment Guide

This guide will help you deploy your Real Estate Portfolio site to production.

## Prerequisites

- A domain name (e.g., `yoursite.com`)
- A hosting provider for the backend (Laravel)
- A hosting provider for the frontend (Vue.js)

## Recommended Hosting Options

### Frontend (Vue.js)
- **Vercel** (Recommended - Free tier available)
- **Netlify** (Free tier available)
- **AWS S3 + CloudFront**
- **GitHub Pages**

### Backend (Laravel)
- **DigitalOcean** (Recommended - $6/month)
- **AWS EC2**
- **Heroku**
- **Laravel Forge** (Easiest but paid)

## Step 1: Prepare Backend for Production

### 1.1 Update Backend Environment Variables

Create a production `.env` file on your server:

```bash
APP_NAME="Real Estate Portfolio"
APP_ENV=production
APP_KEY=base64:YOUR_GENERATED_KEY_HERE
APP_DEBUG=false
APP_URL=https://api.yoursite.com

# Frontend URL (for CORS)
FRONTEND_URL=https://yoursite.com

# Database (MySQL/PostgreSQL for production)
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_secure_password

# Other settings...
SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database
```

### 1.2 Generate Application Key

```bash
php artisan key:generate
```

### 1.3 Set Up Database

```bash
# Run migrations
php artisan migrate --force

# Create storage link
php artisan storage:link
```

### 1.4 Optimize for Production

```bash
# Cache configuration
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache
```

### 1.5 Set Proper Permissions

```bash
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

## Step 2: Prepare Frontend for Production

### 2.1 Update Frontend Environment Variables

Edit `frontend/.env.production`:

```env
# Replace with your actual production API URL
VITE_API_BASE_URL=https://api.yoursite.com/api

# Replace with your actual production storage URL
VITE_STORAGE_BASE_URL=https://api.yoursite.com/storage
```

### 2.2 Build Frontend

```bash
cd frontend
npm install
npm run build
```

This creates a `dist` folder with optimized production files.

## Step 3: Deploy Backend

### Option A: DigitalOcean (Recommended)

1. Create a Droplet (Ubuntu 22.04)
2. Install LEMP stack (Linux, Nginx, MySQL, PHP)
3. Clone your repository
4. Set up `.env` file
5. Run migrations and optimizations
6. Configure Nginx to point to `public` folder
7. Set up SSL with Let's Encrypt

### Option B: Laravel Forge (Easiest)

1. Connect your server to Forge
2. Create a new site
3. Connect your Git repository
4. Set environment variables in Forge dashboard
5. Deploy!

## Step 4: Deploy Frontend

### Option A: Vercel (Recommended)

1. Install Vercel CLI: `npm i -g vercel`
2. From `frontend` folder: `vercel`
3. Follow prompts
4. Set environment variables in Vercel dashboard:
   - `VITE_API_BASE_URL`
   - `VITE_STORAGE_BASE_URL`

### Option B: Netlify

1. Install Netlify CLI: `npm i -g netlify-cli`
2. From `frontend` folder: `netlify deploy --prod`
3. Set environment variables in Netlify dashboard

## Step 5: Configure DNS

Point your domain to your hosting providers:

- `yoursite.com` → Frontend (Vercel/Netlify)
- `api.yoursite.com` → Backend (DigitalOcean/etc.)

## Step 6: Test Production Site

1. Visit your frontend URL
2. Check that projects load
3. Check that resume loads
4. Test all navigation
5. Check browser console for errors

## Security Checklist

- [ ] `APP_DEBUG=false` in production
- [ ] Strong `APP_KEY` generated
- [ ] Database credentials are secure
- [ ] CORS only allows your frontend domain
- [ ] SSL/HTTPS enabled on both frontend and backend
- [ ] File upload limits configured
- [ ] Storage folder permissions set correctly

## Troubleshooting

### Images/PDFs not loading
- Check `VITE_STORAGE_BASE_URL` is correct
- Verify `php artisan storage:link` was run
- Check file permissions on `storage` folder

### CORS errors
- Verify `FRONTEND_URL` in backend `.env`
- Check `config/cors.php` settings
- Clear config cache: `php artisan config:clear`

### 500 errors
- Check Laravel logs: `storage/logs/laravel.log`
- Verify database connection
- Ensure all migrations ran

