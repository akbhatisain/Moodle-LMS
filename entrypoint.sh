#!/bin/bash

# Set MariaDB credentials from environment variables
MYSQL_USER=${MYSQL_USER:-"moodleuser"}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-"moodlepass"}
MYSQL_DATABASE=${MYSQL_DATABASE:-"moodle"}

# Set domain and SSL certificate paths
DOMAIN_NAME=${DOMAIN_NAME:-"moodle.zapto.org"}
SSL_CERT_FILE=${SSL_CERT_FILE:-"/etc/apache2/certs/moodle.crt"}
SSL_KEY_FILE=${SSL_KEY_FILE:-"/etc/apache2/certs/moodle.key"}

# Start MariaDB service
echo "Starting MariaDB..."
service mariadb start

# Wait for MariaDB to be fully ready
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done

# Secure MariaDB and create database if not exists
echo "Configuring MariaDB..."
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -uroot -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"
mysql -uroot -e "FLUSH PRIVILEGES;"

# Create Apache virtual host config
echo "Setting up Apache virtual host..."
cat > /etc/apache2/sites-available/moodle.conf <<EOF
<VirtualHost *:443>
    ServerAdmin admin@$DOMAIN_NAME
    ServerName $DOMAIN_NAME
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile $SSL_CERT_FILE
    SSLCertificateKeyFile $SSL_KEY_FILE

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Enable necessary modules and restart Apache
echo "Configuring Apache..."
rm -rf /var/www/html/index.html
a2enmod rewrite ssl
a2ensite moodle.conf
service apache2 restart
service php8.3-fpm restart

# Keep the container running
echo "Moodle container setup complete. Monitoring logs..."
tail -f /var/log/apache2/access.log
