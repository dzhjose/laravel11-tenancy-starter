# Etapa 1: Construcción de Nginx
FROM nginx:alpine AS base

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# Instalar bash y supervisor
RUN apk update && apk --no-cache add bash supervisor

# Cambiar el shell por defecto
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Crear grupo y usuario
RUN addgroup -g ${GID} --system laravel && \
    adduser -G laravel --system -D -s /bin/bash -u ${UID} laravel

# Cambiar el usuario en la configuración de Nginx
RUN sed -i "s/user  nginx/user laravel/g" /etc/nginx/nginx.conf

# Redirigir logs a stdout y stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

# Crear directorio de trabajo
RUN mkdir -p /var/www/html

# Copiar configuración de Supervisor
COPY ./docker/nginx/supervisord.conf /etc/supervisord.conf

# Etapa 2: Configuración final
FROM base AS final

# Establecer el punto de entrada
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
