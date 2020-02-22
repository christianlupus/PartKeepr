#!/bin/sh

sed '/www-data/s@www-data:x:\([0-9]*\)@www-data:x:'"$GITHUB_DEBUG_UID@" -i /etc/passwd

cd /var/www/pk

# Allow www-data to use composer
mkdir /var/www/.composer && chown www-data: /var/www/.composer

if [ "$1" = "docker-php-entrypoint" ]; then
	# Do the preparation as user www-data
	sudo -u www-data --preserve-env=COMPOSER_AUTH /user-entrypoint.sh
	
	exec "$@"
else
	echo "Calling manual command $@ as user www-data"
	
	sudo -u www-data -E "$@"
fi
