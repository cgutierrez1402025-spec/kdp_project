FROM php:8.2-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Instalar extensiones PHP (sin ctype y json que ya vienen)
RUN docker-php-ext-install -j$(nproc) \
    pdo \
    pdo_mysql \
    zip \
    bcmath \
    mbstring \
    tokenizer

# Habilitar extensiones que vienen por defecto
RUN docker-php-ext-enable \
    pdo \
    pdo_mysql \
    zip \
    bcmath \
    mbstring \
    tokenizer

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Crear usuario laravel
RUN groupadd -g 1000 laravel && \
    useradd -G www-data,root -u 1000 -d /app laravel

WORKDIR /app

# Cambiar permisos
RUN chown -R laravel:laravel /app

USER laravel

EXPOSE 8000

CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]
