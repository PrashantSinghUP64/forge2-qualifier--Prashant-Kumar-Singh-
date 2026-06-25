#!/bin/bash
set -e

echo "==> Setting up environment..."
if [ ! -f .env ]; then
    cp .env.example .env
fi
php artisan key:generate --no-interaction --force 2>/dev/null || true

echo "==> Setting permissions..."
chmod -R 777 storage bootstrap/cache database || true

echo "==> Running migrations..."
php artisan migrate --force

echo "==> Starting Laravel server..."
php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
