#!/usr/bin/env bash

cd /var/www/project/magento

mkdir -p /var/www/project/magento/var/composer_home
cp /var/www/.composer/auth.json /var/www/project/magento/var/composer_home/

echo "Download magento"
/usr/local/bin/composer install

chmod +x ./bin/magento

echo "Install finished"
exit 1;
