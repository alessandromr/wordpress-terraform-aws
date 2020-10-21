FROM wordpress:5.5.1-php7.2-fpm-alpine

COPY ./redis.ini /$PHP_INI_DIR/conf.d/redis.ini

RUN apk add --no-cache --virtual pcre-dev autoconf g++ make yaml-dev \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del --purge pcre-dev autoconf g++ make yaml-dev \
    && rm -rf /tmp/pear

WORKDIR /var/www/html
