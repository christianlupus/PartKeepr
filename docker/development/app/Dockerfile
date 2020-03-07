
ARG SRC_IMAGE=partkeepr/base:latest
FROM ${SRC_IMAGE}

RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN apt-get update && apt-get install -y less nano vim

# Setup PHP settings
RUN sed 's@;date.timezone =@date.timezone = UTC@;s@max_execution_time = .*@max_execution_time = 72000@;s@memory_limit = .*@memory_limit = 512M@' /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

COPY xdebug.config /tmp
RUN cat /tmp/xdebug.config >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
	rm /tmp/xdebug.config

COPY entrypoint.sh /entrypoint.sh
COPY user-entrypoint.sh /user-entrypoint.sh
COPY phpinfo.php /var/www/html/phpinfo.php

WORKDIR /var/www/pk

ENTRYPOINT ["/entrypoint.sh"]
CMD ["docker-php-entrypoint", "apache2-foreground"]
