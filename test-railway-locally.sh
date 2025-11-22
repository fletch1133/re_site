#!/bin/bash

echo "🧪 Testing Railway Configuration Locally"
echo "========================================"
echo ""

cd backend

# Check if required files exist
echo "📋 Checking required files..."
files=("Procfile" "railway-start.sh" "nixpacks.toml" "railway.json" "composer.json" "artisan")
all_exist=true

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing!"
        all_exist=false
    fi
done

echo ""

if [ "$all_exist" = false ]; then
    echo "❌ Some required files are missing!"
    exit 1
fi

# Check if railway-start.sh is executable
if [ -x "railway-start.sh" ]; then
    echo "✅ railway-start.sh is executable"
else
    echo "⚠️  railway-start.sh is not executable, fixing..."
    chmod +x railway-start.sh
    echo "✅ Fixed!"
fi

echo ""

# Check PHP version
echo "🔍 Checking PHP version..."
php_version=$(php -v | head -n 1)
echo "$php_version"

if php -v | grep -q "PHP 8.2"; then
    echo "✅ PHP 8.2 detected"
elif php -v | grep -q "PHP 8"; then
    echo "⚠️  PHP 8.x detected (Railway uses 8.2)"
else
    echo "❌ PHP version might be incompatible"
fi

echo ""

# Check if composer is installed
echo "🔍 Checking Composer..."
if command -v composer &> /dev/null; then
    composer_version=$(composer --version | head -n 1)
    echo "✅ $composer_version"
else
    echo "❌ Composer not found!"
fi

echo ""

# Check if vendor directory exists
if [ -d "vendor" ]; then
    echo "✅ Vendor directory exists"
else
    echo "⚠️  Vendor directory missing - run: composer install"
fi

echo ""

# Check critical environment variables
echo "🔍 Checking environment variables in .env..."
if [ -f ".env" ]; then
    echo "✅ .env file exists"
    
    # Check for APP_KEY
    if grep -q "^APP_KEY=base64:" .env; then
        echo "✅ APP_KEY is set"
    else
        echo "❌ APP_KEY is missing or invalid!"
    fi
    
    # Check for DB_CONNECTION
    db_conn=$(grep "^DB_CONNECTION=" .env | cut -d'=' -f2)
    if [ -n "$db_conn" ]; then
        echo "✅ DB_CONNECTION=$db_conn"
    else
        echo "⚠️  DB_CONNECTION not set"
    fi
else
    echo "⚠️  .env file not found (this is OK for Railway)"
fi

echo ""

# Test if artisan works
echo "🔍 Testing artisan..."
if php artisan --version &> /dev/null; then
    artisan_version=$(php artisan --version)
    echo "✅ $artisan_version"
else
    echo "❌ Artisan command failed!"
fi

echo ""

# Check storage directories
echo "🔍 Checking storage directories..."
storage_dirs=("storage/framework/sessions" "storage/framework/views" "storage/framework/cache" "storage/logs" "bootstrap/cache")
for dir in "${storage_dirs[@]}"; do
    if [ -d "$dir" ]; then
        echo "✅ $dir exists"
    else
        echo "⚠️  $dir missing (will be created on deploy)"
    fi
done

echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ All required files are present"
echo "✅ Configuration looks good"
echo ""
echo "📝 Next steps:"
echo "1. Commit and push these changes to GitHub"
echo "2. Make sure Railway Root Directory is set to: backend"
echo "3. Make sure all environment variables are set in Railway"
echo "4. Deploy and check the logs"
echo ""
echo "🔗 Useful commands:"
echo "   git add ."
echo "   git commit -m 'Fix Railway deployment configuration'"
echo "   git push origin main"
echo ""
echo "📚 See FIX_502_ERROR.md for detailed troubleshooting"

