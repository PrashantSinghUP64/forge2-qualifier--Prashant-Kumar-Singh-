FROM php:8.3-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    sqlite3 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql pdo_sqlite mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application files
COPY . .

# Remove stale lock file and install fresh for PHP 8.3
RUN rm -f composer.lock && composer install --no-interaction --prefer-dist --optimize-autoloader

# Create SQLite database file
RUN mkdir -p database && touch database/database.sqlite

# Make startup script executable
RUN chmod +x start.sh

# Set storage permissions
RUN chmod -R 775 storage bootstrap/cache

# Expose port
EXPOSE ${PORT:-8000}

# Start via script (runs migrate at runtime, not build time)
CMD ["./start.sh"]
