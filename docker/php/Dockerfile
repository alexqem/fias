FROM php:8.3-fpm

ARG WWWUSER=1000
ARG WWWGROUP=1000

ENV USER=www
RUN apt-get update && apt-get install -y \
        git \
        curl \
        nano \
        vim \
        libxml2-dev \
        libzip-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libfreetype6-dev \
        libgmp-dev \
        libssl-dev \
        libbz2-dev \
        libxslt-dev \
        zip \
        unzip \
        pkg-config \
        supervisor \
    && docker-php-ext-install \
        pdo_pgsql \
        opcache \
        intl \
        zip \
        exif \
        bcmath \
        sockets \
        gettext \
        pcntl \
        xsl \
        soap \
    && pecl install redis xdebug \
    && docker-php-ext-enable xdebug redis \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --link --chown=${WWWUSER}:${WWWUSER} --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN mkdir -p /var/log && touch /var/log/xdebug.log && chmod 777 /var/log/xdebug.log

RUN userdel --remove --force www-data \
    && groupadd --force -g ${WWWGROUP} ${USER} \
    && useradd -ms /bin/bash --no-log-init --no-user-group -g ${WWWGROUP} -u ${WWWUSER} ${USER}


RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm pm2

RUN mkdir -p /var/www/html/storage/logs && \
    chown -R ${USER}:${USER} /var/www/html && \
    mkdir -p /var/run && \
    chown -R ${USER}:${USER} /var/run

RUN mkdir -p /var/log/supervisor /var/run/supervisor \
    && chown -R ${USER}:${USER} /var/log/supervisor /var/run/supervisor \
    && chmod -R 775 /var/log/supervisor /var/run/supervisor

COPY --link --chown=${WWWUSER}:${WWWUSER} ./php.ini /usr/local/etc/php/conf.d/custom.ini
COPY --link --chown=${WWWUSER}:${WWWUSER} ./xdebug.ini "${PHP_INI_DIR}"/conf.d
COPY --link --chown=${WWWUSER}:${WWWUSER} ./supervisord.conf /etc/
COPY --link --chown=${WWWUSER}:${WWWUSER} ./supervisord.worker.conf /etc/supervisor/conf.d/

RUN mkdir -p /var/www/html/storage/logs/ \
    /var/www/html/storage/framework/{sessions,views,cache,testing} \
    /var/www/html/bootstrap/cache \
    && touch /var/www/html/storage/logs/worker.log \
    && touch /var/www/html/storage/logs/scheduler.log \
    && chown -R ${USER}:${USER} /var/www/html \
    && chmod -R 775 /var/www/html/storage \

USER ${USER}

EXPOSE 9000

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]


