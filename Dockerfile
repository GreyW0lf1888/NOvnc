ARG DISTRO=alpine
ARG DISTRO_VARIANT=""

# Pulls the official stable NGINX image
FROM nginx:1.26.3-${DISTRO}${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ENV APP_USER=app \
    XDG_RUNTIME_DIR=/data \
    CONTAINER_ENABLE_PERMISSIONS=TRUE \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_SITE_ENABLED="novnc" \
    NGINX_WEBROOT=/usr/share/novnc \
    NGINX_WORKER_PROCESSES=1 \
    IMAGE_NAME=tiredofit/firefox \
    IMAGE_REPO_URL=https://github.com

RUN set -x && \
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /data -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
    # Append the edge repository for specialized virtual display/vnc utilities
    echo 'http://alpinelinux.org' >> /etc/apk/repositories && \
    # Standard native alpine package update and upgrade
    apk update && \
    apk upgrade && \
    # Native package installation
    apk add --no-cache \
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
    mkdir -p /data && \
    chown -R app:app /data

EXPOSE 8080
WORKDIR /data

COPY install/ /

