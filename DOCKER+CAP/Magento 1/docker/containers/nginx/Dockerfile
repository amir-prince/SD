FROM debian:jessie

MAINTAINER SensDigital <c.savi@sensdigital.fr>

RUN apt-get update && apt-get install -y nginx nginx-extras vim supervisor procps

RUN mkdir /etc/nginx/cert

ADD cert/* /etc/nginx/ssl/

ARG APP_PROJECT_TYPE

ADD bin/* /usr/local/bin/
ADD vhost.magento.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/vhost.magento.conf /etc/nginx/sites-enabled/magento
RUN rm /etc/nginx/sites-enabled/default

EXPOSE 80
EXPOSE 443

#Copy supervisord.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV UPLOAD_MAX_FILESIZE 64M
ENV FPM_HOST php
ENV FPM_PORT 9000
ENV MAGENTO_ROOT /var/www/project/magento
ENV MAGENTO_RUN_MODE developer

RUN ["chmod", "+x", "/usr/local/bin/docker-environment"]

ENTRYPOINT ["/usr/local/bin/docker-environment"]

RUN usermod -u 1000 www-data

RUN echo Europe/Paris | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

CMD ["/usr/bin/supervisord"]
