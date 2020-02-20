#! /bin/bash

if [ ! "x$RESET_DATABASE" = "xyes" ]; then
	echo "No reset of database was requested. Skpping."
	exit 0
fi

if [ -z "$DB_HOST" ]; then
	DB_HOST=db
fi

if [ -z "$DB_PORT" ]; then
	DB_PORT=3306
fi

while ! nc -z "$DB_HOST" "$DB_PORT"
do
	echo "sleeping..."
	sleep 1
done

echo "MySQL server should now be reachable"

function sql () {
	mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -h "$DB_HOST" "$MYSQL_DATABASE"
}

echo "Dropping old database tables (housekeeping)"

echo "SHOW TABLES;" | sql | tail -n +2 | while read tab
do
	echo "DROP TABLE $tab;"
done | sql

sql < /dump.sql

echo "Dumping completed"

echo "Resetting data folder"
mkdir /tmp/data
cd /tmp/data

tar xzf /data.tar.gz

chown "$GITHUB_DEBUG_UID" -R .

cp -a . /data

echo "Data folder was reset"
