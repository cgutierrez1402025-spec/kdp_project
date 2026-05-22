FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    zip \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    bcmath \
    ctype \
    json \
    mbstring \
    tokenizer

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Crear usuario laravel
RUN groupadd -g 1000 laravel && \
    useradd -G www-data,root -u 1000 -d /app laravel

WORKDIR /app

# Copiar archivos del proyecto
COPY --chown=laravel:laravel . /app

# Instalar dependencias
RUN composer install --no-interaction --no-dev --prefer-dist --optimize-autoloader || true

# Cambiar permisos
RUN chown -R laravel:laravel storage bootstrap/cache

USER laravel

EXPOSE 8000

CMD ["php-fpm"]
