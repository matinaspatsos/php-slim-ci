FROM php:8.3-alpine

COPY --from=composer/composer:2-bin /composer /usr/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apk update \
  # Required for composer
  && apk add git unzip

CMD ["composer"]
