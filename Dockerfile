# Clear distribution and tag settings
ARG DISTRO=alpine
ARG DISTRO_VARIANT=""

# Correctly pulls nginx:1.26.3-alpine (which uses the newest underlying Alpine version)
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

RUN source /assets/functions/00-container && \
    set -x && \
    addgroup -g 1000 ${APP_USER} && \
    adduser -S -D -H -h /data -s /sbin/nologin -G ${APP_USER} -u 1000 ${APP_USER} && \
    # Explicitly keep edge/testing repository for novnc/websockify compilation packages
    echo 'http://alpinelinux.org' >> /etc/apk/repositories && \
    package update && \
    package upgrade && \
    package add .x-run-deps \
                            binutils \
                            dbus \
                            gcompat \
                            git \
                            openbox \
                            novnc \
                            websockify \
                            xvfb \
                            x11vnc \
                            && \
    package add .base-fonts \
                            font-noto \
                            font-noto-extra \
                            terminus-font \
                            ttf-dejavu \
                            ttf-font-awesome \
                            ttf-inconsolata \
                            && \
    package add -t .xeyes-run-deps \
                            xeyes \
                            && \
    mkdir -p /data && \
    chown -R ${APP_USER}:${APP_USER} && \
    package cleanup

EXPOSE 8080
WORKDIR /data

COPY install/ /

