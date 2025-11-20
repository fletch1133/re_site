# Environment Configuration Guide

This project uses environment variables to configure different settings for development and production.

## Overview

The application is split into two parts:
- **Frontend** (Vue.js) - Located in `/frontend`
- **Backend** (Laravel) - Located in `/backend`

Each part has its own environment configuration.

## Frontend Environment Variables

### Files
- `.env.development` - Used when running `npm run dev`
- `.env.production` - Used when running `npm run build`
- `.env.example` - Template file

### Available Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `VITE_API_BASE_URL` | Backend API endpoint | `http://localhost:8000/api` |
| `VITE_STORAGE_BASE_URL` | Backend storage URL for PDFs/images | `http://localhost:8000/storage` |

### Development Setup

The `.env.development` file is already configured for local development:

```env
VITE_API_BASE_URL=http://localhost:8000/api
VITE_STORAGE_BASE_URL=http://localhost:8000/storage
```

No changes needed for local development!

### Production Setup

Before deploying, update `.env.production` with your production URLs:

```env
VITE_API_BASE_URL=https://api.yoursite.com/api
VITE_STORAGE_BASE_URL=https://api.yoursite.com/storage
```

## Backend Environment Variables

### Files
- `.env` - Your local development configuration (not in git)
- `.env.example` - Template for development
- `.env.production.example` - Template for production

### Key Variables

| Variable | Description | Development | Production |
|----------|-------------|-------------|------------|
| `APP_ENV` | Environment | `local` | `production` |
| `APP_DEBUG` | Debug mode | `true` | `false` |
| `APP_URL` | Backend URL | `http://localhost` | `https://api.yoursite.com` |
| `FRONTEND_URL` | Frontend URL (CORS) | `http://localhost:5173` | `https://yoursite.com` |
| `DB_CONNECTION` | Database type | `sqlite` | `mysql` |

### Development Setup

Your current `.env` file is already configured for local development. The key settings are:

```env
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost
FRONTEND_URL=http://localhost:5173
DB_CONNECTION=sqlite
```

### Production Setup

On your production server:

1. Copy `.env.production.example` to `.env`
2. Update all values marked with `your_*`
3. Generate a new APP_KEY: `php artisan key:generate`
4. Configure your production database

## How It Works

### Frontend

The frontend uses Vite's environment variable system:
- Variables must be prefixed with `VITE_`
- Access in code: `import.meta.env.VITE_VARIABLE_NAME`
- Different `.env` files are loaded based on the command:
  - `npm run dev` → `.env.development`
  - `npm run build` → `.env.production`

### Backend

The backend uses Laravel's environment system:
- Variables are loaded from `.env` file
- Access in code: `env('VARIABLE_NAME')`
- The same `.env` file is used, but you change it per environment

## Common Scenarios

### Running Locally
No configuration needed! Just run:
```bash
# Terminal 1 - Backend
cd backend
php artisan serve

# Terminal 2 - Frontend
cd frontend
npm run dev
```

### Building for Production
1. Update `frontend/.env.production` with production URLs
2. Build: `cd frontend && npm run build`
3. Deploy the `dist` folder

### Testing Production Build Locally
```bash
cd frontend
npm run build
npm run preview
```

Note: The preview will use production environment variables, so API calls will go to your production backend if configured.

## Troubleshooting

### Frontend can't connect to backend
- Check `VITE_API_BASE_URL` is correct
- Verify backend is running
- Check browser console for CORS errors

### CORS errors
- Verify `FRONTEND_URL` in backend `.env` matches your frontend URL
- For local dev, should be `http://localhost:5173`
- For production, should be your actual domain

### Environment variables not updating
- **Frontend:** Restart dev server (`npm run dev`)
- **Backend:** Clear config cache (`php artisan config:clear`)

### Images/PDFs not loading
- Check `VITE_STORAGE_BASE_URL` is correct
- Verify `php artisan storage:link` was run on backend
- Check file permissions on `backend/storage`

## Security Notes

- Never commit `.env` files with sensitive data
- Always use `APP_DEBUG=false` in production
- Use strong, unique passwords for production databases
- Keep `APP_KEY` secret and unique per environment

