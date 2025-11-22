# Railway Deployment Setup Guide

## 🚨 Critical Environment Variables for Railway

You MUST set these environment variables in your Railway project dashboard:

### Required Variables

1. **APP_KEY** (CRITICAL!)
   ```
   Generate with: php artisan key:generate --show
   Copy the entire output including "base64:"
   ```

2. **APP_ENV**
   ```
   production
   ```

3. **APP_DEBUG**
   ```
   false
   ```

4. **APP_URL**
   ```
   https://resite-production.up.railway.app
   ```

5. **FRONTEND_URL** (for CORS)
   ```
   https://your-vercel-app.vercel.app
   ```
   Replace with your actual Vercel URL

6. **LOG_CHANNEL**
   ```
   stderr
   ```

7. **LOG_LEVEL**
   ```
   error
   ```

### Database Configuration

Railway provides PostgreSQL. Use these settings:

8. **DB_CONNECTION**
   ```
   pgsql
   ```

9. **DB_HOST**
   ```
   ${{Postgres.PGHOST}}
   ```

10. **DB_PORT**
    ```
    ${{Postgres.PGPORT}}
    ```

11. **DB_DATABASE**
    ```
    ${{Postgres.PGDATABASE}}
    ```

12. **DB_USERNAME**
    ```
    ${{Postgres.PGUSER}}
    ```

13. **DB_PASSWORD**
    ```
    ${{Postgres.PGPASSWORD}}
    ```

### Session & Cache

14. **SESSION_DRIVER**
    ```
    database
    ```

15. **CACHE_STORE**
    ```
    database
    ```

16. **QUEUE_CONNECTION**
    ```
    database
    ```

### File Storage (CRITICAL!)

17. **FILESYSTEM_DISK**
    ```
    public
    ```
    **⚠️ IMPORTANT:** This MUST be set to `public` for resume and project PDFs to be accessible via web URLs. Without this, uploaded files will return 404 errors.

## 📋 Step-by-Step Railway Setup

### Step 1: Add PostgreSQL Database

1. Go to your Railway project
2. Click "New" → "Database" → "Add PostgreSQL"
3. Wait for it to provision

### Step 2: Set Environment Variables

1. Click on your Laravel service
2. Go to "Variables" tab
3. Add all the variables listed above
4. For database variables, use the Railway reference syntax: `${{Postgres.PGHOST}}`

### Step 3: Configure Root Directory

1. In your service settings
2. Set "Root Directory" to: `backend`
3. This tells Railway where your Laravel app is located

### Step 4: Deploy

1. Push your code to GitHub
2. Railway will automatically detect the changes and redeploy
3. Check the deployment logs for any errors

## 🔍 Troubleshooting

### Check Deployment Logs

In Railway, click on your service → "Deployments" → Click on the latest deployment to see logs

### Common Issues

1. **500 Error**
   - Check if APP_KEY is set
   - Check if database migrations ran successfully
   - Check logs for specific errors

2. **Database Connection Failed**
   - Verify PostgreSQL service is running
   - Check database environment variables are correct
   - Make sure you're using `${{Postgres.VARIABLE}}` syntax

3. **Storage/Permission Errors**
   - The railway-start.sh script handles this
   - Check deployment logs to see if storage directories were created

4. **CORS Errors**
   - Make sure FRONTEND_URL is set to your Vercel URL
   - Check that your Vercel app is using the correct API URL

## 🧪 Testing Your Deployment

After deployment, test these endpoints:

1. **Health Check**
   ```
   https://resite-production.up.railway.app/up
   ```
   Should return: `{"status":"ok"}`

2. **API Projects**
   ```
   https://resite-production.up.railway.app/api/projects
   ```
   Should return JSON array of projects

3. **API Resume**
   ```
   https://resite-production.up.railway.app/api/resume
   ```
   Should return resume data

## 📝 Quick Command Reference

### Generate APP_KEY locally
```bash
cd backend
php artisan key:generate --show
```

### Test database connection locally with PostgreSQL
```bash
# Update your local .env with Railway database credentials
php artisan migrate
```

### View Railway logs
```bash
# Install Railway CLI
npm i -g @railway/cli

# Login
railway login

# Link to your project
railway link

# View logs
railway logs
```

