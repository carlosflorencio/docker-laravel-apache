FROM php:7.2-apache-stretch

ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_DISPLAY_ERRORS=Off
ENV PHP_POST_MAX_SIZE=8M
ENV PHP_UPLOAD_MAX_FILESIZE=2M
ENV PHP_MAX_FILE_UPLOADS=20

# Add the PHP configuration file
COPY ./php.ini /usr/local/etc/php/

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
# (needed to solve some permissions issues when using volumes)
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data