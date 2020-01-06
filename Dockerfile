FROM php:7.3-cli

ARG APCU_VERSION=5.1.11
ARG MEMCACHED_VERSION=3.1.3

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN  set -xe \
    && apt-get update \
    && apt-get install -y libzip-dev libicu-dev libgmp-dev git \
    && pecl install apcu-${APCU_VERSION} \
    && pecl install memcached-${MEMCACHED_VERSION} \
    && pecl install -o -f redis \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-install mbstring  \
    && docker-php-ext-install gmp  \
    && docker-php-ext-install opcache \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable apcu \
    && docker-php-ext-enable memcached \
    && echo "apc.enable_cli = 1" >> $PHP_INI_DIR/conf.d/docker-php-ext-apcu.ini \
    && rm -rf /var/lib/apt/lists/*
