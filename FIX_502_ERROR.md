# Fix 502 Bad Gateway Error on Railway

## 🔴 Current Issue

You're getting a **502 Bad Gateway** error, which means your Laravel app is **not starting** on Railway.

The CORS errors are just a symptom - the backend isn't running at all.

## ✅ What I Just Fixed

I updated these files to fix the startup issues:

1. **`backend/railway-start.sh`**
   - Added config clearing before caching (important!)
   - Changed from `php artisan serve` to `php -S` (more reliable)
   - Better error handling

2. **`backend/nixpacks.toml`**
   - Improved build process
   - Better dependency installation

3. **`backend/railway.json`** (NEW)
   - Explicit Railway configuration
   - Restart policy for reliability

## 🚀 Steps to Fix Your Deployment

### Step 1: Commit and Push These Changes

```bash
git add .
git commit -m "Fix Railway 502 error - update startup configuration"
git push origin main
```

### Step 2: Verify Railway Settings

Go to Railway → Your Backend Service → **Settings**

#### Check Root Directory:
- Should be set to: `backend`
- If not set or wrong, change it to `backend`
- Click "Save"

#### Check Environment Variables:
Go to **Variables** tab and verify these are set:

**Critical Variables:**
```
APP_KEY=base64:... (must be set!)
APP_ENV=production
APP_DEBUG=false
APP_URL=https://resite-production.up.railway.app
FRONTEND_URL=https://re-site-drab.vercel.app
LOG_CHANNEL=stderr
LOG_LEVEL=error
```

**Database Variables:**
```
DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
```

**Session/Cache:**
```
SESSION_DRIVER=database
CACHE_STORE=database
QUEUE_CONNECTION=database
```

### Step 3: Check PostgreSQL Database

Make sure you have a PostgreSQL database added:
- In Railway project, you should see a "Postgres" service
- If not, click "New" → "Database" → "Add PostgreSQL"

### Step 4: Trigger Redeploy

After pushing your code:
1. Go to Railway → Your Service → **Deployments**
2. Wait for the new deployment to start
3. **Watch the logs carefully**

### Step 5: Check Deployment Logs

Look for these in the logs:

**Good signs:**
```
✅ Installing Composer dependencies...
✅ Setting up storage directories...
✅ Running database migrations...
✅ Optimizing application...
✅ Starting web server on port 8000...
```

**Bad signs (errors to look for):**
```
❌ "No application encryption key" → APP_KEY not set
❌ "Connection refused" → Database not connected
❌ "Class not found" → Composer install failed
❌ "Permission denied" → File permissions issue
```

### Step 6: Test the Health Endpoint

After deployment completes, test:
```
https://resite-production.up.railway.app/up
```

**Expected:** `{"status":"ok"}`

If you still get 502, check the logs for specific errors.

## 🔍 Common Causes of 502 Error

### 1. APP_KEY Not Set
**Symptom:** App crashes immediately on startup
**Fix:** Set APP_KEY in Railway variables (use the one from prepare-railway-deploy.sh)

### 2. Database Connection Failed
**Symptom:** App crashes when trying to connect to database
**Fix:** 
- Make sure PostgreSQL service exists
- Verify DB variables use `${{Postgres.XXX}}` syntax
- Check database service is running

### 3. Root Directory Wrong
**Symptom:** Railway can't find your app files
**Fix:** Set Root Directory to `backend` in Railway settings

### 4. Composer Dependencies Failed
**Symptom:** "Class not found" errors in logs
**Fix:** 
- Check composer.json is valid
- Make sure PHP 8.2 is available
- Check Railway build logs

### 5. Storage Permissions
**Symptom:** "Permission denied" on storage/logs
**Fix:** The railway-start.sh script should handle this now

## 🆘 If Still Getting 502

### Check Railway Logs for Specific Error

1. Railway → Service → Deployments → Click latest
2. Look for the actual error message
3. Share the error here for specific help

### Try Manual Commands

If you have Railway CLI installed:

```bash
# Install Railway CLI
npm i -g @railway/cli

# Login and link
railway login
railway link

# View logs
railway logs

# Try running commands manually
railway run php artisan config:clear
railway run php artisan migrate --force
```

### Nuclear Option - Recreate Service

If nothing works:
1. Create a NEW service in Railway
2. Connect to your GitHub repo
3. Set Root Directory to `backend`
4. Add all environment variables
5. Link to existing PostgreSQL database
6. Deploy

## 📝 What to Share If You Need Help

If still not working, share:

1. **Full Railway deployment logs** (copy the entire log output)
2. **Screenshot of Railway Variables tab** (hide sensitive values)
3. **Screenshot of Railway Settings** (showing Root Directory)
4. **What you see when visiting the health endpoint**

This will help identify the exact issue!

## ✨ After It Works

Once you get `{"status":"ok"}` from the health endpoint:

1. Update Vercel environment variables if needed:
   - `VITE_API_BASE_URL=https://resite-production.up.railway.app/api`
   - `VITE_STORAGE_BASE_URL=https://resite-production.up.railway.app/storage`

2. Redeploy Vercel (or just wait for auto-deploy)

3. Test your site - CORS errors should be gone!

