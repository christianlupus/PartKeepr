
ARG SRC_IMAGE=php:7.1-fpm-buster
FROM ${SRC_IMAGE}

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y sudo curl wget git unzip libldap2-dev libpng++-dev libicu-dev libcurl4-gnutls-dev libxml2-dev libpq-dev libfreetype6-dev && \
	docker-php-ext-configure ldap && docker-php-ext-install ldap && \
	docker-php-ext-configure bcmath && docker-php-ext-install bcmath && \
	docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --enable-gd-native-ttf && docker-php-ext-install gd && \
	docker-php-ext-install opcache intl dom pdo pdo_mysql pdo_pgsql && \
	pecl install apcu_bc-beta && docker-php-ext-enable apcu && \
	apt-get clean

RUN mkdir /var/www/pk && chown www-data /var/www/pk

WORKDIR /var/www/pk

# Install Composer
# See https://tecnstuff.net/how-to-install-composer-on-debian-10/
RUN cd /tmp && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	HASH="$(wget -q -O - https://composer.github.io/installer.sig)" && \
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1); } echo PHP_EOL;" && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer

