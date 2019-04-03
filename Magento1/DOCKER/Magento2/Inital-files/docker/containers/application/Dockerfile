FROM debian:stretch

MAINTAINER SensDigital <c.savi@sensdigital.fr>

ARG APP_PROJECT_DIR_NAME

VOLUME /var/www/project

RUN echo Europe/Paris | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
