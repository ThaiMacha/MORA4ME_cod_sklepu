FROM php:8.3-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    intl \
    soap \
    opcache

# Install Xdebug
RUN pecl install xdebug-3.3.0 \
    && docker-php-ext-enable xdebug

# Install Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /var/www/html

# Create www-data user with proper permissions
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

# Copy PHP configuration
COPY docker/php/conf.d/php.ini /usr/local/etc/php/conf.d/
COPY docker/php/conf.d/opcache.ini /usr/local/etc/php/conf.d/

# Change ownership of our applications
RUN chown -R www-data:www-data /var/www/html

# Switch to www-data user
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]