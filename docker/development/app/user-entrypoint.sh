#! /bin/sh

cd /var/www/pk

# Check if parameters are present
if [ ! -f app/config/parameters.php ]; then
	cp app/config/parameters.php.dist app/config/parameters.php
fi

# Run composer
composer install

# Simulare a setup run
if [ "x$PARTKEEPR_FORCE_UPDATE" = "xyes" ]; then
	
	# Clears the production cache
	php app/console cache:clear --env=prod
	
	# Executes the database migrations
	php app/console doctrine:migrations:migrate --no-interaction
	
	# Updates the database schema
	php app/console doctrine:schema:update --force
	
	# Builds all required files and warms up the cache
	./vendor/bin/phing
	
fi

# Runs all crons
php app/console partkeepr:cron:run

# Add phpinfo() file if requested
if [ -n "$ADD_PHPINFO_FILE" ]; then
	cp /var/www/html/phpinfo.php /var/www/pk/web
fi
