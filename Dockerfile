ARG DISTRO=alpine
ARG DISTRO_VARIANT=""

# Pulls the official stable NGINX image
FROM nginx:1.26.3-${DISTRO}${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (://github.com)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED="novnc" \
    NGINX_WEBROOT=/usr/share/novnc \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/firefox \
    IMAGE_REPO_URL=https://://github.com/docker-firefox

RUN set -x && \
    # Clean system upgrade using native repositories
    apk update && \
    apk upgrade && \
    # Create application user and group matching UID 1000
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /data -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
    # Install core utilities plus edge-testing tools cleanly in one execution layer
    apk add --no-cache \
        --repository=http://alpinelinux.org \
        binutils \
        dbus \
        gcompat \
        git \
        openbox \
        novnc \
        websockify \
        xvfb \
        x11vnc \
        font-noto \
        font-noto-extra \
        terminus-font \
        ttf-dejavu \
        ttf-font-awesome \
        ttf-inconsolata \
        xeyes \
        && \
    # Initialize workspace permissions securely
    mkdir -p /data && \
    chown -R 1000:1000 /data

EXPOSE 8080
WORKDIR /data

COPY install/ /
