
FROM php:7.1-apache-buster

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y sudo curl wget git unzip libldap2-dev libpng++-dev libicu-dev libcurl4-gnutls-dev libxml2-dev libpq-dev && \
	docker-php-ext-configure ldap && docker-php-ext-install ldap && \
	docker-php-ext-configure bcmath && docker-php-ext-install bcmath && \
	docker-php-ext-configure gd && docker-php-ext-install gd && \
	docker-php-ext-install opcache intl dom pdo pdo_mysql pdo_pgsql && \
	pecl install apcu_bc-beta && docker-php-ext-enable apcu && \
	pecl install xdebug && docker-php-ext-enable xdebug
# RUN docker-php-ext-configure mbstring && docker-php-ext-install mbstring

RUN apt-get install -y less nano vim

# Setup Apache and PHP settings
RUN a2enmod rewrite
RUN find /etc/apache2 -type f -exec sed 's@/var/www/html@/var/www/pk/web@g' -i \{\} +
RUN sed 's@;date.timezone =@date.timezone = UTC@;s@max_execution_time = .*@max_execution_time = 72000@;s@memory_limit = .*@memory_limit = 512M@' /usr/local/etc/php/php.ini-development > /usr/local/etc/php/php.ini

COPY xdebug.config /tmp
RUN cat /tmp/xdebug.config >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
	rm /tmp/xdebug.config

# Install Composer
# See https://tecnstuff.net/how-to-install-composer-on-debian-10/
RUN cd /tmp && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	HASH="$(wget -q -O - https://composer.github.io/installer.sig)" && \
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); } echo PHP_EOL;" && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer


# RUN apt-get install -y libicu-dev libcurl4-gnutls-dev libxml2-dev libpq-dev
# RUN docker-php-ext-configure intl && docker-php-ext-install intl



COPY entrypoint.sh /entrypoint.sh
COPY phpinfo.php /var/www/html/phpinfo.php

# VOLUME /var/www/pk
WORKDIR /var/www/pk

ENTRYPOINT ["/entrypoint.sh"]
CMD ["docker-php-entrypoint", "apache2-foreground"]
