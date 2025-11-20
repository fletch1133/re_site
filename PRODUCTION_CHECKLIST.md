# Production Deployment Checklist

## Before You Deploy

### Frontend Configuration
- [ ] Update `frontend/.env.production` with your production API URL
- [ ] Update `VITE_API_BASE_URL` to your backend domain (e.g., `https://api.yoursite.com/api`)
- [ ] Update `VITE_STORAGE_BASE_URL` to your storage URL (e.g., `https://api.yoursite.com/storage`)
- [ ] Run `npm run build` to test production build locally
- [ ] Test the production build with `npm run preview`

### Backend Configuration
- [ ] Copy `backend/.env.production.example` to `.env` on your server
- [ ] Set `APP_ENV=production`
- [ ] Set `APP_DEBUG=false`
- [ ] Update `APP_URL` to your backend domain
- [ ] Update `FRONTEND_URL` to your frontend domain (for CORS)
- [ ] Generate new `APP_KEY` with `php artisan key:generate`
- [ ] Configure production database (MySQL/PostgreSQL)
- [ ] Update database credentials in `.env`

### Database Setup
- [ ] Create production database
- [ ] Run migrations: `php artisan migrate --force`
- [ ] Create storage symlink: `php artisan storage:link`
- [ ] Set proper permissions on `storage` and `bootstrap/cache`

### Security
- [ ] Ensure `APP_DEBUG=false` in production
- [ ] Use strong database passwords
- [ ] CORS configured to only allow your frontend domain
- [ ] SSL/HTTPS enabled on both frontend and backend
- [ ] File upload limits configured appropriately

### Performance
- [ ] Run `php artisan config:cache`
- [ ] Run `php artisan route:cache`
- [ ] Run `php artisan view:cache`
- [ ] Enable OPcache in PHP
- [ ] Configure proper caching headers

## Deployment Steps

### 1. Deploy Backend
```bash
# On your server
cd /var/www/your-site
git pull origin main
composer install --optimize-autoloader --no-dev
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### 2. Deploy Frontend
```bash
# Locally
cd frontend
npm run build

# Then upload dist folder to your hosting provider
# OR use Vercel/Netlify CLI for automatic deployment
```

## Post-Deployment Testing

- [ ] Visit your site and check homepage loads
- [ ] Navigate to About page - check profile image loads
- [ ] Navigate to Projects page - check projects load
- [ ] Click on a project PDF - verify it opens
- [ ] Navigate to Resume page - check resume loads
- [ ] Test on mobile device
- [ ] Check browser console for errors
- [ ] Test all links and navigation

## Common Issues & Solutions

### PDFs/Images Not Loading
**Problem:** Files return 404 or CORS errors
**Solution:**
- Verify `php artisan storage:link` was run
- Check `VITE_STORAGE_BASE_URL` matches your backend URL
- Verify file permissions: `chmod -R 755 storage`

### CORS Errors
**Problem:** API requests blocked by CORS
**Solution:**
- Check `FRONTEND_URL` in backend `.env`
- Verify `config/cors.php` allows your frontend domain
- Clear config cache: `php artisan config:clear`

### 500 Server Errors
**Problem:** Backend returns 500 errors
**Solution:**
- Check `storage/logs/laravel.log`
- Verify database connection
- Ensure all migrations ran
- Check file permissions

### Blank Page on Frontend
**Problem:** Frontend shows blank page
**Solution:**
- Check browser console for errors
- Verify `VITE_API_BASE_URL` is correct
- Check that backend API is accessible
- Verify CORS is configured correctly

## Environment Variables Reference

### Frontend (.env.production)
```env
VITE_API_BASE_URL=https://api.yoursite.com/api
VITE_STORAGE_BASE_URL=https://api.yoursite.com/storage
```

### Backend (.env)
```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://api.yoursite.com
FRONTEND_URL=https://yoursite.com
DB_CONNECTION=mysql
# ... other database settings
```

## Support

If you encounter issues:
1. Check Laravel logs: `storage/logs/laravel.log`
2. Check browser console for frontend errors
3. Verify all environment variables are set correctly
4. Test API endpoints directly with Postman/curl
5. Check server error logs (Nginx/Apache)

