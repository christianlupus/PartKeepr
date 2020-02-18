#!/bin/sh

sed '/www-data/s@www-data:x:\([0-9]*\)@www-data:x:'"$GITHUB_DEBUG_UID@" -i /etc/passwd

cd /var/www/pk

# Check if parameters are present
if [ ! -f app/config/parameters.php ]; then
	sudo -u www-data cp app/config/parameters.php.dist app/config/parameters.php
fi

sudo -u www-data composer install

if [ "x$PARTKEEPR_FORCE_UPDATE" = "xyes" ]; then
	
	# Clears the production cache
	sudo -u www-data php app/console cache:clear --env=prod
	
	# Executes the database migrations
	sudo -u www-data php app/console doctrine:migrations:migrate --no-interaction
	
	# Updates the database schema
	sudo -u www-data php app/console doctrine:schema:update --force
	
	# Builds all required files and warms up the cache
	sudo -u www-data ./vendor/bin/phing
	
	# Runs all crons
	sudo -u www-data php app/console partkeepr:cron:run
	
fi

if [ -n "$ADD_PHPINFO_FILE" ]; then
	sudo -u www-data cp /var/www/html/phpinfo.php /var/www/pk/web
fi

exec "$@"
