# Railway Deployment Troubleshooting Guide

## 🔴 Common Network Errors and Solutions

### Error: "Network Error" or "Failed to fetch"

This usually means your backend isn't responding. Here's how to diagnose:

#### 1. Check if Railway Service is Running

1. Go to Railway dashboard
2. Click on your backend service
3. Check the status indicator (should be green/running)
4. Look at the "Deployments" tab - is the latest deployment successful?

#### 2. Verify the Public URL

1. In Railway, click your service
2. Go to "Settings" tab
3. Under "Networking" → "Public Networking"
4. Make sure "Generate Domain" is enabled
5. Copy the domain (e.g., `resite-production.up.railway.app`)

#### 3. Test the Health Endpoint

Open in browser or use curl:
```bash
curl https://resite-production.up.railway.app/up
```

Expected response:
```json
{"status":"ok"}
```

If this fails, your app isn't starting correctly.

#### 4. Check Deployment Logs

In Railway:
1. Click your service
2. Go to "Deployments" tab
3. Click the latest deployment
4. Look for errors in the logs

Common log errors and solutions:

**"No application encryption key has been specified"**
- Solution: Set APP_KEY environment variable
- Generate with: `php artisan key:generate --show`

**"SQLSTATE[08006] Connection refused"**
- Solution: Database not connected
- Make sure PostgreSQL service is added
- Verify database environment variables

**"Permission denied" or "storage/logs"**
- Solution: Storage permissions issue
- The railway-start.sh script should fix this
- Check if the script ran successfully in logs

**"Class not found" or "Target class does not exist"**
- Solution: Autoloader not optimized
- Make sure `composer install` ran successfully
- Check if vendor directory exists

### Error: CORS Policy Blocking Requests

If you see: `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution:**
1. Make sure FRONTEND_URL is set in Railway environment variables
2. Set it to your Vercel URL (e.g., `https://your-app.vercel.app`)
3. Redeploy after changing environment variables

### Error: 404 Not Found on API Routes

If `/api/projects` returns 404:

**Solution:**
1. Check if route caching is causing issues
2. In Railway logs, look for route registration
3. Make sure `routes/api.php` exists
4. Try clearing route cache by redeploying

### Error: 404 Not Found on Uploaded PDFs (Resume/Projects)

If uploaded PDFs return 404 errors when trying to view them:

**Root Cause:** `FILESYSTEM_DISK` environment variable is not set to `public`

**Solution:**
1. Go to Railway → Your Service → Variables
2. Add or update: `FILESYSTEM_DISK=public`
3. Redeploy the application
4. The storage link is automatically created by `railway-start.sh`

**Why this happens:**
- When `FILESYSTEM_DISK=local`, files are stored in `storage/app/private` (not web accessible)
- When `FILESYSTEM_DISK=public`, files are stored in `storage/app/public` (web accessible via `/storage` URL)
- The symlink `public/storage` → `storage/app/public` makes files accessible

**To verify the fix:**
1. Upload a resume via Admin panel
2. Check the URL in browser console (should be: `https://your-domain.com/storage/resume/filename.pdf`)
3. Try accessing the URL directly - should download/display the PDF
4. If still 404, check Railway logs to ensure storage link was created

### Error: 500 Internal Server Error

**Solution:**
1. Check Railway logs for the actual error
2. Common causes:
   - Missing APP_KEY
   - Database connection failed
   - Missing required environment variables
   - File permission issues

## 🔧 Step-by-Step Fix Process

### Step 1: Verify Railway Configuration

1. **Check Root Directory**
   - Service Settings → Root Directory = `backend`

2. **Check Build Command** (if custom)
   - Should use nixpacks.toml or Procfile
   - Don't override unless necessary

3. **Check Start Command** (if custom)
   - Should be: `bash railway-start.sh`
   - Or let Procfile handle it

### Step 2: Set All Required Environment Variables

Copy these into Railway Variables tab:

```bash
APP_NAME="Real Estate Portfolio"
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:YOUR_KEY_HERE  # Generate with: php artisan key:generate --show
APP_URL=https://resite-production.up.railway.app

FRONTEND_URL=https://your-vercel-app.vercel.app

LOG_CHANNEL=stderr
LOG_LEVEL=error

DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}

SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database

FILESYSTEM_DISK=public
```

**⚠️ CRITICAL:** Make sure `FILESYSTEM_DISK=public` is set, otherwise uploaded PDFs will return 404 errors!

### Step 3: Add PostgreSQL Database

1. In Railway project, click "New"
2. Select "Database" → "Add PostgreSQL"
3. Wait for provisioning
4. The database variables will auto-populate

### Step 4: Redeploy

After setting variables:
1. Go to "Deployments" tab
2. Click "Deploy" or push new code to trigger deployment
3. Watch the logs for errors

### Step 5: Test Endpoints

After successful deployment, test:

```bash
# Health check
curl https://resite-production.up.railway.app/up

# API endpoints
curl https://resite-production.up.railway.app/api/projects
curl https://resite-production.up.railway.app/api/resume
```

## 🐛 Debugging Tips

### View Live Logs

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and link project
railway login
railway link

# Stream logs
railway logs
```

### Check Environment Variables

In Railway dashboard:
1. Click service
2. Go to "Variables" tab
3. Verify all required variables are set
4. Check for typos

### Test Database Connection

Add this temporary route to `routes/web.php` to test DB:

```php
Route::get('/test-db', function () {
    try {
        DB::connection()->getPdo();
        return 'Database connected: ' . DB::connection()->getDatabaseName();
    } catch (\Exception $e) {
        return 'Database connection failed: ' . $e->getMessage();
    }
});
```

Then visit: `https://resite-production.up.railway.app/test-db`

**Remember to remove this route after testing!**

## 📞 Still Having Issues?

1. Check Railway status page: https://status.railway.app/
2. Review Railway docs: https://docs.railway.app/
3. Check Laravel logs in Railway deployment logs
4. Share specific error messages for more targeted help

