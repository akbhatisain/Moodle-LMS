# Use Ubuntu 24.04 as the base image
FROM ubuntu:24.04

# Set noninteractive mode to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    apache2 mariadb-server wget curl unzip vim \
    php8.3 php8.3-mysql php8.3-xml php8.3-fpm php8.3-curl php8.3-gd php8.3-intl \
    php8.3-mbstring php-ldap php8.3-soap php8.3-zip php8.3-xmlrpc php-bcmath libapache2-mod-php \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /var/www/html

# Copy Moodle source code and scripts
COPY moodle.zip /tmp/
COPY entrypoint.sh /entrypoint.sh
COPY ./certs/* /etc/apache2/certs/

# Ensure MariaDB and Moodle data persist
VOLUME ["./mysql", "./moodledata"]

# Unzip Moodle, set proper permissions
RUN unzip /tmp/moodle.zip -d /var/www/html/ && \
    cp -R /var/www/html/moodle/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# Create Moodle data directory with proper permissions
RUN mkdir -p /var/www/moodledata && \
    chown -R www-data:www-data /var/www/moodledata && \
    chmod -R 775 /var/www/moodledata && \
    chmod +x /entrypoint.sh

# Ensure entrypoint script is executable
RUN sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.3/apache2/php.ini && \
    sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.3/cli/php.ini


# Expose required ports
EXPOSE 80 443

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
