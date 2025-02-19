#!/bin/bash
DATADIR='/var/lib/mysql'
SOCKET=/var/lib/mysql/mysql.sock

setup_db() {
    # let's create the wordpress user/db and perform more or less the same setup as the interactive
    #  mysql_secure_installation script does not to shoot ourselves in the foot
    echo "Creating database ${MYSQL_DATABASE} with user ${MYSQL_USER} and passwords"

	mariadb --protocol=socket -uroot -hlocalhost --socket="${SOCKET}" --binary-mode --database=mysql <<-EOSQL
		SET @orig_sql_log_bin= @@SESSION.SQL_LOG_BIN;
		SET @@SESSION.SQL_LOG_BIN=0;
		SET @@SESSION.SQL_MODE=REPLACE(@@SESSION.SQL_MODE, 'NO_BACKSLASH_ESCAPES', '');

		DROP USER IF EXISTS root@'127.0.0.1', root@'::1', root@'localhost';
		EXECUTE IMMEDIATE CONCAT('DROP USER IF EXISTS root@\'', @@hostname,'\'');

		CREATE USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' ;
		GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION ;

		DROP DATABASE IF EXISTS test ;
		SET @@SESSION.SQL_LOG_BIN=@orig_sql_log_bin;

		CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

		CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
		GRANT ALL ON ${MYSQL_DATABASE//_/\\_}.* TO '$MYSQL_USER'@'%';
	EOSQL

    echo "Database and user created"
}


if [ ! -d "$DATADIR/mysql" ]; then

    echo "Initializing MariaDB data directory.."
    mysql_install_db --user=mysql --datadir="$DATADIR"

    # Now let's start mariadb in background first, perform initialization / db setup for wordpress, and then move
    # it to foreground when everything is done
    
    # Start mariadb in background
    echo "Starting mariadb in background.."
    mysqld_safe --datadir=/var/lib/mysql &

    # Wait for mariadb to accept connections
    until mysqladmin ping --silent; do
        echo "Waiting for mariadb to start.."
        sleep 5     
    done
    
    # Initialize
    echo "Installing MariaDB..."
    setup_db

    # Bring to foreground
    wait
else
    echo "Starting MariaDB without user init that has been done before"
    mysqld_safe --datadir=/var/lib/mysql
fi
