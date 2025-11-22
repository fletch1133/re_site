# Railway Deployment Checklist ✅

Use this checklist to ensure your Railway deployment is configured correctly.

## 📦 Before You Deploy

- [ ] Committed all new files to git:
  - [ ] `backend/Procfile`
  - [ ] `backend/railway-start.sh`
  - [ ] `backend/nixpacks.toml`
- [ ] Pushed changes to GitHub
- [ ] Generated APP_KEY locally: `cd backend && php artisan key:generate --show`

## 🚂 Railway Project Setup

### 1. Create/Verify Services

- [ ] Backend service exists and is connected to your GitHub repo
- [ ] PostgreSQL database is added to the project
- [ ] Services are in the same project (for internal networking)

### 2. Backend Service Configuration

- [ ] **Root Directory** is set to: `backend`
  - Location: Service Settings → Root Directory
- [ ] **Public Domain** is generated
  - Location: Service Settings → Networking → Generate Domain
- [ ] Copy the domain URL (e.g., `resite-production.up.railway.app`)

### 3. Environment Variables

Go to: Backend Service → Variables tab

#### Required Variables (Set These!)

- [ ] `APP_NAME` = `Real Estate Portfolio`
- [ ] `APP_ENV` = `production`
- [ ] `APP_DEBUG` = `false`
- [ ] `APP_KEY` = `base64:...` (from php artisan key:generate --show)
- [ ] `APP_URL` = `https://resite-production.up.railway.app` (your Railway domain)
- [ ] `FRONTEND_URL` = `https://your-app.vercel.app` (your Vercel domain)

#### Logging

- [ ] `LOG_CHANNEL` = `stderr`
- [ ] `LOG_LEVEL` = `error`

#### Database (Use Railway References)

- [ ] `DB_CONNECTION` = `pgsql`
- [ ] `DB_HOST` = `${{Postgres.PGHOST}}`
- [ ] `DB_PORT` = `${{Postgres.PGPORT}}`
- [ ] `DB_DATABASE` = `${{Postgres.PGDATABASE}}`
- [ ] `DB_USERNAME` = `${{Postgres.PGUSER}}`
- [ ] `DB_PASSWORD` = `${{Postgres.PGPASSWORD}}`

#### Session & Cache

- [ ] `SESSION_DRIVER` = `database`
- [ ] `CACHE_STORE` = `database`
- [ ] `QUEUE_CONNECTION` = `database`

#### File Storage (CRITICAL!)

- [ ] `FILESYSTEM_DISK` = `public`
  - **IMPORTANT:** This must be set to `public` for resume and project PDFs to be accessible
  - Without this, you'll get 404 errors when trying to view uploaded files

## 🚀 Deploy

- [ ] Trigger deployment (push to GitHub or click "Deploy" in Railway)
- [ ] Wait for build to complete (watch the logs)
- [ ] Check for any errors in deployment logs

## ✅ Verify Deployment

### Test Endpoints

- [ ] Health check works: `https://resite-production.up.railway.app/up`
  - Should return: `{"status":"ok"}`
  
- [ ] API projects endpoint: `https://resite-production.up.railway.app/api/projects`
  - Should return: JSON array (may be empty)
  
- [ ] API resume endpoint: `https://resite-production.up.railway.app/api/resume`
  - Should return: Resume data or 404 if not uploaded

### Check Logs

- [ ] No errors in Railway deployment logs
- [ ] Migrations ran successfully
- [ ] Storage directories created
- [ ] Config cached successfully

## 🎨 Update Frontend (Vercel)

### Update Environment Variables

Go to: Vercel Project → Settings → Environment Variables

- [ ] `VITE_API_BASE_URL` = `https://resite-production.up.railway.app/api`
- [ ] `VITE_STORAGE_BASE_URL` = `https://resite-production.up.railway.app/storage`

### Redeploy Frontend

- [ ] Trigger Vercel redeployment (push to GitHub or redeploy in Vercel)
- [ ] Wait for build to complete
- [ ] Test the live site

## 🧪 Test Full Application

- [ ] Visit your Vercel site
- [ ] Check browser console for errors
- [ ] Test viewing projects page
- [ ] Test viewing resume page
- [ ] Test login functionality (if applicable)
- [ ] Test admin features (if logged in)

## 🐛 If Something's Wrong

### Common Issues

**"Network Error" in frontend:**
- Check CORS: Is FRONTEND_URL set correctly in Railway?
- Check API URL: Is VITE_API_BASE_URL correct in Vercel?
- Check Railway service is running

**"500 Internal Server Error":**
- Check Railway logs for specific error
- Verify APP_KEY is set
- Verify database connection

**"404 Not Found" on API routes:**
- Check Root Directory is set to `backend`
- Check routes are cached correctly
- Check deployment logs

**Database connection errors:**
- Verify PostgreSQL service is running
- Check database environment variables
- Make sure using `${{Postgres.VARIABLE}}` syntax

### Get Help

- [ ] Check `RAILWAY_TROUBLESHOOTING.md` for detailed solutions
- [ ] Review Railway deployment logs
- [ ] Test individual endpoints with curl
- [ ] Check Railway status page: https://status.railway.app/

## 📝 Notes

Write any issues or observations here:

```
[Your notes here]
```

## ✨ Success!

Once everything is checked off and working:

- [ ] Test all features on production
- [ ] Share the link with others
- [ ] Monitor Railway logs for any issues
- [ ] Set up monitoring/alerts (optional)

---

**Need help?** Refer to:
- `RAILWAY_SETUP.md` - Detailed setup instructions
- `RAILWAY_TROUBLESHOOTING.md` - Common issues and solutions

