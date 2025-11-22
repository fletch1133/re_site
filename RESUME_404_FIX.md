# Resume 404 Error Fix

## 🐛 The Problem

Resume PDFs were showing a **404 Not Found** error when trying to view them on the frontend.

## 🔍 Root Cause

The `FILESYSTEM_DISK` environment variable was set to `local` instead of `public` in the Laravel configuration.

### What This Means:
- **`FILESYSTEM_DISK=local`**: Files are stored in `storage/app/private` and are NOT accessible via web URLs
- **`FILESYSTEM_DISK=public`**: Files are stored in `storage/app/public` and ARE accessible via the `/storage` URL

## ✅ The Fix

Changed the `FILESYSTEM_DISK` setting from `local` to `public` in all environment files:

### Files Updated:
1. ✅ `backend/.env` (local development)
2. ✅ `backend/.env.example` (template for new developers)
3. ✅ `backend/.env.production.example` (template for production)

### Change Made:
```env
# Before (WRONG)
FILESYSTEM_DISK=local

# After (CORRECT)
FILESYSTEM_DISK=public
```

## 🚀 Production Deployment

### For Railway (or any production environment):

**IMPORTANT:** You need to add this environment variable to your Railway project:

1. Go to Railway Dashboard
2. Select your backend service
3. Go to **Variables** tab
4. Add or update:
   ```
   FILESYSTEM_DISK=public
   ```
5. Redeploy your application

### Why This Works:

When `FILESYSTEM_DISK=public`:
- Resume uploads are stored in `storage/app/public/resume/`
- The storage link (`public/storage` → `storage/app/public`) makes them accessible
- Files are accessible at: `https://your-domain.com/storage/resume/filename.pdf`
- The frontend can load PDFs via: `VITE_STORAGE_BASE_URL + resume.pdf_path`

## 🧪 Testing

### Local Development:
1. Start backend: `cd backend && php artisan serve`
2. Start frontend: `cd frontend && npm run dev`
3. Go to: `http://localhost:5173/resume`
4. Resume should load without 404 errors

### Production:
1. Upload a resume via the Admin panel
2. Navigate to the Resume page
3. The PDF should display in the preview
4. Click to view fullscreen - should work
5. Download button should work

## 📝 Technical Details

### How Laravel Storage Works:

```
backend/
├── storage/
│   └── app/
│       ├── private/     ← FILESYSTEM_DISK=local (NOT web accessible)
│       └── public/      ← FILESYSTEM_DISK=public (web accessible via symlink)
└── public/
    └── storage/         ← Symlink to storage/app/public
```

### The Storage Link:
Laravel creates a symbolic link from `public/storage` to `storage/app/public`:
```bash
php artisan storage:link
```

This is automatically done in:
- Local setup (when you run migrations)
- Railway deployment (in `railway-start.sh`)

### File Upload Flow:
1. Admin uploads resume PDF
2. `ResumeController::upload()` stores file using `$pdf->store('resume', 'public')`
3. File saved to: `storage/app/public/resume/[hash].pdf`
4. Database stores path: `resume/[hash].pdf`
5. Frontend constructs URL: `STORAGE_BASE_URL + resume/[hash].pdf`
6. Browser requests: `https://domain.com/storage/resume/[hash].pdf`
7. Symlink resolves to: `storage/app/public/resume/[hash].pdf`
8. File is served ✅

## 🔒 Security Note

Files in `storage/app/public` are publicly accessible by design. This is correct for:
- Resume PDFs (meant to be viewed by visitors)
- Project PDFs (meant to be viewed by visitors)

If you need to store private files (not for public access), use `FILESYSTEM_DISK=local` or store them in a different location.

## 📚 Related Files

- `backend/config/filesystems.php` - Defines the `public` disk configuration
- `backend/app/Http/Controllers/Api/ResumeController.php` - Handles resume uploads
- `frontend/src/views/ResumeView.vue` - Displays the resume
- `backend/railway-start.sh` - Creates storage link on Railway deployment

## ✨ Summary

**Before:** Resume files were stored but not accessible via web URLs → 404 errors

**After:** Resume files are stored in the public disk and accessible via `/storage` URL → Works perfectly! 🎉

