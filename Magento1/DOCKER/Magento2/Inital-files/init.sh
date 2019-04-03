#!/usr/bin/env bash

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

if [ ! -d magento/vendor ]; then
    docker-compose exec php sh -c "install.sh"
fi

if [ ! -f magento/app/etc/env.php ]; then
    cp magento/app/etc/env.php.dev magento/app/etc/env.php
fi
