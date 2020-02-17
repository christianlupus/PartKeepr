#!/bin/sh

sed '/www-data/s@www-data:x:\([0-9]*\)@www-data:x:'"$GITHUB_DEBUG_UID@" -i /etc/passwd

cd /var/www/pk

# Check if parameters are present
if [ ! -f app/config/parameters.php ]; then
	sudo -u www-data cp app/config/parameters.php.dist app/config/parameters.php
fi

sudo -u www-data composer install

if [ -n "$ADD_PHPINFO_FILE" ]; then
	sudo -u www-data cp /var/www/html/phpinfo.php /var/www/pk/web
fi

exec "$@"
