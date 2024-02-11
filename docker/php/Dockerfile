# TODO setup with Nginx and test app

# Testing build:
#
# docker build --file docker/php/Dockerfile -t php-slim .
# docker run -di --name php-slim php-slim
#
# docker exec -it php-slim /bin/bash
#
# docker stop php-slim && docker rm php-slim && docker rmi php-slim

#
# INSTALL PHP DEPENDENCIES
#

FROM php:8.3 AS installer

WORKDIR /build

COPY --from=composer/composer:2-bin /composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt update -y \
  # Required for composer
  && apt install -y git unzip

COPY composer.* /build/

RUN composer install --no-interaction --no-progress -o --no-dev

#
# BUILD APP
#

FROM php:8.3-fpm

WORKDIR /var/www/html

RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini
# If you add your custom PHP config file:
# COPY docker/php/app-php.ini /usr/local/etc/php/conf.d/

# TODO logging

COPY src/ /var/www/html/src
COPY public/ /var/www/html/public
COPY --from=installer /build /var/www/html/

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

ENTRYPOINT [ "php-fpm", "-F" ]
