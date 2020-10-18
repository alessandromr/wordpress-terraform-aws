FROM wordpress:5.5.1-php7.2-fpm

COPY ./redis.ini /$PHP_INI_DIR/conf.d/redis.ini

RUN apt-get update && apt-get install -y vim

RUN pecl install redis \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/pear 

WORKDIR /var/www/html
