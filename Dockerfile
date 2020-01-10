FROM alpine:3.10

# Install packages
RUN apk --no-cache add php7 php7-fpm \
    php7-phar php7-json php-curl php7-iconv php7-openssl php7-ctype  php7-openssl \
    nginx supervisor curl

# Configure nginx
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY nginx/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY nginx/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ARG APPLICATION_DIR="/var/www/public"
WORKDIR ${APPLICATION_DIR}

COPY ./src/index.php ${ROOT_DIR} 
COPY ./src/sample.html ${ROOT_DIR} 

# run composer
#RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#RUN php composer-setup.php
#RUN php -r "unlink('composer-setup.php');" &&  mv composer.phar /usr/local/bin/composer

#RUN cd ${APPLICATION_DIR} && composer install && composer dump-autoload --optimize --classmap-authoritative

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]