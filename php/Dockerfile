# Verwende das neueste Debian-Image 
FROM debian:bookworm
 
 
# Setze das Arbeitsverzeichnis 
WORKDIR /code 
 
# Installiere grundlegende Werkzeuge und PHP mit Erweiterungen 
RUN apt update && apt-get install -y curl \
    git \ 
    unzip \ 
    vim \ 
    php \ 
    php-cli \ 
    php-mbstring \ 
    php-xml \ 
    php-curl \ 
    php-zip \ 
    php-mysql \ 
    php-pgsql \
    php-sqlite3 \ 
    php-intl \ 
    php-gd \ 
    php-bcmath \ 
    php-xdebug \
    php-soap \
    php-ldap \
    && apt-get clean 

RUN sed -i 's/^\;max_input_vars.*/max_input_vars = 5000/' /etc/php/8.2/cli/php.ini

# Install NodeJS v20
COPY setup-nodev20.sh /tmp/setup-nodev20.sh
RUN bash /tmp/setup-nodev20.sh
RUN apt update && apt install -y nodejs
RUN npm install -g grunt-cli

# Watch required by grunt watch
RUN apt install -y watchman

# Enable xDebug
# Based on: https://docs.devsense.com/en/vscode/debug/xdebug-linux
RUN echo -e "zend_extension=\"xdebug.so\"\nxdebug.mode=debug" >> /etc/php/8.2/cli/conf.d/20-xdebug.in

# Create Moodle data dir
RUN mkdir -p /moodledata
 
# Füge Composer hinzu 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer 
RUN composer global config --no-plugins allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
RUN composer global require moodlehq/moodle-cs -W

# COPY home/* /home/devuser/
# USER devuser
 
# Exponiere den Standard-PHP-Port für den eingebauten Server 
EXPOSE 8000 
 
CMD ["/bin/bash"]
