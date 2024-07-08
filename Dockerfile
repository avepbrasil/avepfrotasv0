# Usar Ubuntu 22.04 como base
FROM ubuntu:22.04

# Instalar dependências necessárias, incluindo PHP 8.1, cron e outras ferramentas

RUN apt update && apt install -y \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common \
    apt-utils

RUN add-apt-repository ppa:ondrej/php

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    libapache2-mod-php8.0 \
    php8.0 \
    php8.0-intl \
    php8.0-cli \
    php8.0-fpm \
    php8.0-mysql \
    php8.0-xml \
    php8.0-zip \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-curl \
    php8.0-imap \
    php8.0-bcmath \
    curl \
    unzip \
    cron \
    curl \
    git \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Configurar Apache e PHP
RUN a2enmod rewrite && a2enmod php8.0


# Adicionar o repositório do Node.js e instalar o Node.js e npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.9 | bash - && \
    apt-get install -y nodejs

# Install PHP Composer
RUN cd /root && curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php /root/composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer self-update

# Definir o fuso horário no php.ini
RUN echo "date.timezone = America/Sao_Paulo" >> /etc/php/8.0/apache2/php.ini \
    && echo "date.timezone = America/Sao_Paulo" >> /etc/php/8.0/cli/php.ini

# Config php.ini

RUN sed -i 's/allow_url_fopen = Off/allow_url_fopen = On/' /etc/php/8.0/apache2/php.ini
RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/' /etc/php/8.0/apache2/php.ini
RUN sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/' /etc/php/8.0/apache2/php.ini
RUN sed -i 's/max_execution_time = 30/max_execution_time = 600/' /etc/php/8.0/apache2/php.ini
RUN sed -i 's/post_max_size = 8M/post_max_size = 64M/' /etc/php/8.0/apache2/php.ini

# Adicionar configurar APACHE
#COPY mautic.conf /etc/apache2/sites-available/mautic.conf

#RUN ln -s /etc/apache2/sites-available/mautic.conf /etc/apache2/sites-enabled/

RUN echo "ServerName 127.0.0.1" >> /etc/apache2/apache2.conf

