# Etapa 1: Composición de PHP
FROM php:fpm-alpine AS base

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Crear directorio de trabajo
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Instalar dependencias y herramientas necesarias para Laravel 11
RUN apk update && apk add --no-cache \
    bash \
    supervisor \
    tzdata \
    postgresql-dev \
    php-fpm \
    php-pdo \
    php-opcache \
    php-mbstring \
    php-json \
    php-xml

# Configurar zona horaria
ENV TZ=America/Lima

# Instalar extensiones de PHP
RUN docker-php-ext-install pdo pdo_mysql

# Cambiar shell por defecto
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Crear usuario y grupo
RUN addgroup -g ${GID} --system laravel && \
    adduser -G laravel --system -D -s /bin/bash -u ${UID} laravel

# Cambiar configuración de PHP-FPM
RUN sed -i "s/user = www-data/user = laravel/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/group = www-data/group = laravel/g" /usr/local/etc/php-fpm.d/www.conf

# Configurar supervisor
RUN mkdir -p /etc/supervisor.d/

# Copiar Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Etapa 2: Copiar el código fuente y la configuración
FROM base AS final

USER laravel

# Copiar código fuente
COPY ./src .

# Copiar la configuración de php-init.development
# COPY ./path/to/php-init.development /usr/local/etc/php/conf.d/php-init.development

# Copiar configuración de supervisor
COPY ./docker/php/supervisord.conf /etc/supervisor.d/supervisord.conf

# Configurar el punto de entrada
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor.d/supervisord.conf"]
