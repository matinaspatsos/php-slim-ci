FROM php:8.3

COPY --from=composer/composer:2-bin /composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt update -y \
  # Required for composer
  && apt install -y git unzip

CMD ["composer"]
