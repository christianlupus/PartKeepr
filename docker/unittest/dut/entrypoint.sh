#! /bin/bash

# set -x

if [ $# -gt 0 ]; then
	exec "$@"
fi

set -e

echo "Cloning the test files"
time rsync -a /image/ /var/www/pk --exclude=/docker --exclude=/.git --delete --delete-delay --delete-excluded
echo "done"

# Setting some basic constants
export SYMFONY__TESTDB=mysql
export DB=mysql

# env

# echo "Who am I?"
# whoami

# exit 1

echo "Prepare the configuration"
cp app/config/parameters.php.dist app/config/parameters.php
patch -Np3 -i /test-data/config_test.patch

function finish() {
	echo "Reverse patching"
	patch -Rp3 -i /test-data/config_test.patch
}

trap finish EXIT

echo "Reset database"
mysql -h mariadb -u root -proot << EOF
DROP DATABASE IF EXISTS partkeepr_test;
CREATE DATABASE partkeepr_test;
GRANT ALL ON partkeepr_test.* TO partkeepr;
FLUSH PRIVILEGES;
EOF

echo "Prepare composer"
composer self-update

echo "Install all dependencies"
composer install --prefer-source --no-interaction

echo "Warm-up the cache"
app/console cache:warmup --env=test

echo "Create the schema"
app/console doctrine:schema:create --env=test

echo "Run the test file"
if [ -n "$DEBUG_VARS" ]; then
	echo "Enabling debuging with XDEBUG_CONFIG=\"$DEBUG_VARS\""
	export XDEBUG_CONFIG="$DEBUG_VARS"
fi
vendor/bin/phpunit -c app/ --coverage-html build/logs/code-coverage $FILTER_STRING

