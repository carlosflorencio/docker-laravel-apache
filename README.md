# docker-laravel-apache

Docker image to serve Laravel apps using Apache and PHP 7

Target Laravel version: >= 5.6

## Example Dockerfile
Add a Dockerfile to your laravel project folder:
```
FROM iamfreee/docker-laravel-apache:latest

# Copy files
WORKDIR /var/www/html/
COPY . .
```

## Command line
From your laravel project folder run:

`docker run -d --name laravel-app -v $(pwd):/var/www/html -p 80:80 iamfreee/docker-laravel-apache:latest`

## PHP Options
Environment variables that can be overriden:

```
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_DISPLAY_ERRORS=Off
ENV PHP_POST_MAX_SIZE=8M
ENV PHP_UPLOAD_MAX_FILESIZE=2M
ENV PHP_MAX_FILE_UPLOADS=20
```

This image is using the latest production [php.ini](http://git.php.net/?p=php-src.git;a=blob;f=php.ini-production;hb=HEAD) file.

## Image information
- Image size: `~455MB`
- Container memory when running: `~50MB` (after some requests)
