# Moodle-LMS
Moodle is a free and open-source learning management system written in PHP and distributed under the GNU General Public License. Moodle is used for blended learning, distance education, flipped classroom and other online learning projects in schools, universities, workplaces and other sectors.
# Moodle Learning Management System

### Moodle is a free, online Learning Management system enabling educators to create their own private website filled with dynamic courses that extend learning, any time, anywhere. 
## Whether you're a teacher, student or administrator, Moodle can meet your needs. Moodle’s extremely customisable core comes with many standard features. Take a look at a highlight of Moodle's core features below and download the file Moodle features for students (pdf) comparing the LMS, Moodle app and offline features.

### Here you can find out more about the features of Moodle:-https://docs.moodle.org/405/en/Features

### Download Moodle form here:- https://download.moodle.org/
More about Installation :- https://docs.moodle.org/405/en/Installing_Moodle#Start_Moodle_install

More about system Requirements:- https://docs.moodle.org/405/en/Installing_Moodle#Requirements

## Moodle installation on Docker container:

### Prerequisites:-
1. Docker installed on your system.
2. A domain name or IP address pointing to your server.
3. moodle.zip file should be there in directory. (you can download latest one.)
3. Create a entry in /etc/hosts file for local host domain.

### Local Domain setup:
#### 1. Edit Host file  
    - Linux :- /etc/hosts 
    - Windows :- c:/windows/system32/drivers/etc/hosts
#### 2. Add entry in hosts file:- 
    127.0.0.1   Your_domain_name

### Setup Moodle on Docker container:
#### 1. clone the repo 
    $ git clone https://github.com/akbhatisain/Moodle-LMS
#### 2. Go to the repo directory :
    $ cd repo_name
#### 3. Certificate generation:-
    $ cd ./certs
    $ openssl req -x509 -newkey rsa:4096 -keyout ./certs/moodle.key -out ./certs/moodle.crt -days 365 -nodes
    $ cd ../
#### 4. Update DB details in entrypoint.sh file:
    A. MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE
#### 5. Build your docker image:
    $ docker build --no-cache -t my-moodle .
#### 6. Spin up the container with your docker image:
    $ docker run -d -p 80:80 -p 443:443 --name moodle-container my-moodle
#### 7. Verify the Docker containers:
    $ docker ps -a
#### 8. To get into the conatiner: 
    $ docker exec -it moodle-container /bin/bash
Here you can see apache2 is running, you can check logs, DB services, moodle files are there in /var/www/html/

### steps to access moodle:-
https://Your_domain_name
Installation > 
        Choose Languange > next
        Paths > Confirm Paths > next
        Database > Choose database driver > MariaDB(native/mariadb) > next
        Database > Database settings > Username/Passwd > next  ##Check Entrypoint.sh file
        Copyright notice > continue  
        Server checks > Fix and Reload OR Continue (If everthing is ok)
        Now it will check entire system and show you the result then > Continue
General > Fill the form(USERNAME,PASSWORD,EMAIL,SITE NAME) > Update profile
Site home settings>  Sitename, Site description, timezone, language, etc. > Save Changes

We are ready to go!
____________________________________________________________________________________________________________________

# Moodle Installation on Ubuntu 24.04 LTS

### Update System and Install Apache, MariaDB:-
    $ sudo apt update
    $ sudo apt upgrade -y
    $ sudo apt install apache2 -y
    $ sudo systemctl enable apache2
    $ sudo systemctl start apache2
    $ sudo apt install mariadb-server -y
    $ sudo systemctl enable mariadb
    $ sudo systemctl start mariadb

### Install PHP and Required Extensions
    $ sudo apt install certbot python3-certbot-apache php php-soap libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl -y
    
### Create Moodle Database and User
    $ sudo mysql_secure_installation  
Follow the prompts to set the root password and remove insecure default settings:-
Log into the MariaDB shell as the root user:
>     sudo mysql -u root -p
>     CREATE DATABASE moodle CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
>     CREATE USER 'moodleuser'@'localhost' IDENTIFIED BY 'moodle';
>     GRANT ALL PRIVILEGES ON moodle.* TO 'moodleuser'@'localhost';
>     FLUSH PRIVILEGES;
>     EXIT;

### Configure Apache
    $ sudo systemctl restart apache2
    $ echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

### Configure PHP for Moodle:-
    $ sudo nano /etc/php/8.3/apache2/php.ini
    max_input_vars = 5000
        
        OR

### Check the php configuration filelocation:
    $ sudo php --ini | grep "Loaded Configuration File"
    Loaded Configuration File:         /etc/php/8.3/cli/php.ini

    $ sudo nano /etc/php/8.3/cli/php.ini
    max_input_vars = 5000

    $ sudo systemctl restart php8.3-fpm
    $ sudo systemctl restart apache2

### Download and Install Moodle in /var/www/html
    $ sudo rm -rf /var/www/html/index.html

Download Or Copy moodle.zip file to /var/www/html/

### Create and Set Directory Permissions
    $ sudo chown -R www-data:www-data /var/www/html/
    $ sudo chmod -R 755 /var/www/html/

### Create Moodle Data Directory
    $ sudo mkdir /var/www/moodledata
    $ sudo chown -R www-data:www-data /var/www/moodledata
    $ sudo chmod -R 775 /var/www/moodledata

### Obtain SSL Certificate
    $ sudo certbot --apache -d your_domain.com

OR

### Configure self signed SSL certificate for your local domain:
    $ sudo mkdir -p /etc/ssl/certs
    $ sudo openssl req -x509 -newkey rsa:4096 -keyout /etc/ssl/certs/moodle.key -out /etc/ssl/certs/moodle.crt -days 365 -nodes

### Configure Apache for Moodle
    $ sudo nano /etc/apache2/sites-available/000-default.conf
    <VirtualHost *:443>
        ServerAdmin admin@wl-moodle.lms.com
        ServerName wl-moodle.zapto.org    # Change HERE
        DocumentRoot /var/www/html
    
        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/moodle.crt
        SSLCertificateKeyFile /etc/ssl/certs/moodle.key
    
        <Directory /var/www/html>
            AllowOverride All
        </Directory>
    
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>

    $ sudo a2enmod ssl
    $ sudo a2enmod rewrite
    $ sudo a2ensite moodle-ssl
    $ sudo systemctl restart apache2

### configure Moodle on the web browser:
https://your_domain_or_IP/
Installation > 
>        Choose Languange > next
>        Paths > Confirm Paths > next
>        Database > Choose database driver > MariaDB(native/mariadb) > next
>        Database > Database settings > Username/Passwd > next  ##Check Entrypoint.sh file
>        Copyright notice > continue  
>        Server checks > Fix and Reload OR Continue (If everthing is ok)
>        Now it will check entire system and show you the result then > Continue
>        General > Fill the form(USERNAME,PASSWORD,EMAIL,SITE NAME) > Update profile
>        Site home settings>  Sitename, Site description, timezone, language, etc. > Save Changes

We are ready to go!

$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$

## Additional Steps for Security and Performance:-

### Configure Moodle
    $ sudo nano /var/www/html/config.php
    Step 1: Verify Database Credentials in config.php
        $CFG->dbtype    = 'mariadb';
        $CFG->dblibrary = 'native';
        $CFG->dbhost    = 'localhost';
        $CFG->dbname    = 'moodle';
        $CFG->dbuser    = 'root';
        $CFG->dbpass    = 'your_root_password';  // Check this!
    Step 2: Configure Moodle Site
        $CFG->wwwroot   = 'https://your_domain_or_IP';

    $ sudo systemctl restart apache2

## Steps completed! feel free to use Moodle. Lets have a nice day.
