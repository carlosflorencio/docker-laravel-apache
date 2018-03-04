FROM php:7-apache-stretch

# Install PHP extensions
RUN apt-get update -yqq \
    # Install libs for building PHP exts
    && apt-get install -yqq --no-install-recommends \
        libicu-dev \
        libpq-dev \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        unzip \
        nano \
        mysql-client \
    # Install PHP Exts
    && docker-php-ext-install \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        zip \
        opcache \
        ctype \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    # Remove dev packages
    && apt-get remove --purge -yyq libicu-dev \
        libpq-dev \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
    && rm -r /var/lib/apt/lists/*

# Add apache and php config for Laravel
COPY ./vhost.conf /etc/apache2/sites-available/site.conf
RUN a2dissite 000-default.conf && a2ensite site.conf && a2enmod rewrite

# Change uid and gid of apache to docker user uid/gid
# RUN usermod -u 1000 www-data && groupmod -g 1000 www-data