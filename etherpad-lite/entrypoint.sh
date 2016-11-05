#!/bin/bash
set -e

if [ -z "$DB_PORT" ]; then
	: DB_POST = '3306'
fi


if [ -z "$DB_HOST" ]; then
	: DB_HOST = 'localhost'
fi

if [ -z "$DB_TYPE" ]; then
	: DB_TYPE = 'mysql'
fi

# if we're linked to MySQL, and we're using the root user, and our linked
# container has a default "root" password set up and passed through... :)
: ${DB_USER:=root}
if [ "$DB_USER" = 'root' ]; then
	: ${B_PASSWORD:=$MYSQL_ENV_MYSQL_ROOT_PASSWORD}
fi
: ${DB_NAME:=etherpad}

DB_NAME=$( echo $DB_NAME | sed 's/\./_/g' )

if [ -z "$DB_PASSWORD" ]; then
	echo >&2 'error: missing required DB_PASSWORD environment variable'
	echo >&2 '  Did you forget to -e DB_PASSWORD=... ?'
	echo >&2
	echo >&2 '  (Also of interest might be DB_USER and DB_NAME.)'
	exit 1
fi

: ${ETHERPAD_TITLE:=Etherpad}
: ${ETHERPAD_PORT:=9001}
: ${ETHERPAD_SESSION_KEY:=$(
		node -p "require('crypto').randomBytes(32).toString('hex')")}

# Check if database already exists
RESULT=`mysql -u${DB_USER} -p${DB_PASSWORD} \
	-h${DB_HOST} --skip-column-names \
	-e "SHOW DATABASES LIKE '${DB_NAME}'"`

if [ "$RESULT" != $DB_NAME ]; then
	# mysql database does not exist, create it
	echo "Creating database ${DB_NAME}"

	mysql -u${DB_USER} -p${DB_PASSWORD} -hmysql \
	      -e "create database ${DB_NAME}"
fi

if [ ! -f settings.json ]; then

	cat <<- EOF > settings.json
	{
	  "title": "${ETHERPAD_TITLE}",
	  "ip": "0.0.0.0",
	  "port" :${ETHERPAD_PORT},
	  "sessionKey" : "${ETHERPAD_SESSION_KEY}",
	  "dbType" : "${DB_TYPE}",
	  "dbSettings" : {
			    "user"    : "${DB_USER}",
			    "host"    : "${DB_HOST}",
			    "password": "${DB_PASSWORD}",
			    "database": "${DB_NAME}"
			  },
	EOF

	if [ $ETHERPAD_ADMIN_PASSWORD ]; then

		: ${ETHERPAD_ADMIN_USER:=admin}

		cat <<- EOF >> settings.json
		  "users": {
		    "${ETHERPAD_ADMIN_USER}": {
		      "password": "${ETHERPAD_ADMIN_PASSWORD}",
		      "is_admin": true
		    }
		  },
		EOF
	fi

	cat <<- EOF >> settings.json
	}
	EOF
fi

exec "$@"
