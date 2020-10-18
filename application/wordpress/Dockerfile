FROM wordpress:5.5.1-php7.2-fpm-alpine

WORKDIR /usr/src/wordpress

#Remove useless file
RUN rm -rf \
	readme.html \
	wp-config-sample.php \
    license.txt

#Remove default plugins
RUN rm -rf \
    wp-content/plugins/akismet/ \
    wp-content/plugins/hello.php

#Remove default unused themes 
RUN rm -rf \
    wp-content/themes/twentynineteen \
    wp-content/themes/twentyseventeen

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]