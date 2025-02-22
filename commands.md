     sudo apt install apache2 -y
     sudo apt install mariadb-server -y
     sudo systemctl enable mariadb
     sudo systemctl start mariadb
     sudo mysql_secure_installation
     sudo mysql -u root -p
     sudo apt install php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl -y
     sudo systemctl restart apache2
     sudo apt install php php-soap libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl -y
     sudo systemctl restart apache2
     mv /home/ubuntu/moodle-latest-405.zip /var/www/html/
     cd /var/www/html/
     unzip moodle-latest-405.zip
     sudo chown -R www-data:www-data /var/www/html/
     sudo chmod -R 755 /var/www/html/
     sudo mkdir /var/www/moodledata
     sudo chown -R www-data:www-data /var/www/moodledata
     sudo chmod -R 775 /var/www/moodledata
     sudo apt install certbot python3-certbot-apache -y
     vim /etc/apache2/sites-available/000-default.conf
     sudo a2enmod ssl
     sudo a2enmod rewrite
     sudo a2ensite moodle-ssl
     sudo systemctl restart apache2
     vim /etc/php/8.3/apache2/php.ini
     sudo mkdir -p /etc/ssl/certs
     sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/certs/moodle.key -out /etc/ssl/certs/moodle.crt -days 365 -nodes
     sudo systemctl restart php8.3-fpm
     echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
     php --ini | grep "Loaded Configuration File"
     vim /etc/php/8.3/cli/php.ini
     sudo systemctl restart php8.3-fpm
     sudo systemctl restart apache2
