#!/usr/bin/env bash

if [ ! -f magento/app/etc/local.xml ]; then
    cp magento/app/etc/local.xml.dev magento/app/etc/local.xml
fi

if [ ! -f ./.env ]; then
    cp -f ./.env.dist ./.env
    sed -i "" -e "s/<uid>/$UID/g" ./.env
fi

source ./.env

if ! grep -F "$APP_SERVER_NAME" /etc/hosts
then
    sudo sh -c "echo '#########  $APP_PROJECT_DIR_NAME  #########' >> /etc/hosts"
    sudo sh -c "echo '127.0.0.1       $APP_SERVER_NAME' >> /etc/hosts"
fi

docker-compose up -d