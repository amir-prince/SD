# projectname - Magento 2

#### Nginx 1.10 + PHP-FPM 7.1 + OPCache + MySql + Varnish + N98 Magerun 2 + XDebug + Redis

* [Installation du projet](#installation-du-projet)
* [Infos utiles](#infos-utiles)
    * [Purge Varnish](#purge-varnish)
    * [XDebug](#xdebug)
* [Magento](#magento)
* [Erreurs possibles](#erreurs-possibles)

## Important

Changement du système de fichier pour Docker (utilisation du native NFS). 
Cette action n'est à effectuer qu'une fois pour tout projet confondu (seulement sur MAC):
```
./setup_native_nfs_docker_osx.sh
```

## Installation du projet
A exécuter la première fois que l'on installe le projet:
```
chmod +x init.sh
./init.sh
```

Puis on importe la bdd : `mysql -uroot -proot -h127.0.0.1 dyneff < docker/dumps/dump-init.sql`

## Infos utiles

#### Lister les containers. 
```
docker-compose ps
```

#### Se connecter à un container. 
```
docker-compose exec php /bin/bash
docker-compose exec nginx /bin/bash
docker-compose exec db /bin/bash
docker-compose exec redis /bin/bash
docker-compose exec varnish /bin/bash
...
```

#### Relancer un container en le forçant à se reconstruire avant
```
docker-compose up --build -d nginx
```

#### Recréer le container totalement
```
docker-compose build --no-cache nginx
```

#### Purge Varnish
Flush le Varnish Magento du front
```
./purgevarnish <url-à-purger>
./purgevarnish / #purge tout le varnish
./purgevarnish /toto #purge toutes les pages dont l'url démarre par toto
```

#### Xdebug

Xdebug est désactivé par défaut. Pour l'activer il suffit de taper:
``` 
./xdebug enable
```
Autres commandes dispos:
``` 
./xdebug disable
./xdebug status
```

Il suffit ensuite de le configurer dans PHPStorm:

Languages & Frameworks > PHP > Debug`

`=>Xdebug => Debug port : 9009`

Languages & Frameworks > PHP > Debug > DBGp Proxy

```
=> IDE key : PHPSTORM
=> Port : 9009
```

##Magento

### Magento Frontend 

Frontend Developer Guide :
* http://devdocs.magento.com/guides/v2.2/frontend-dev-guide/bk-frontend-dev-guide.html
* http://devdocs.magento.com/guides/v2.2/frontend-dev-guide/css-guide/css_quick_guide_approach.html


### Infos

#### Accès admin LOCAL

<https://dyneff.local/admin>

admin / Magent0

#### Gestion des mails

Tous les mails sont envoyés à Mailhog et sont accessible via l'url:

<http://dyneff.local:8025>


### Les commandes utiles 

Vider les caches sur container php
```
php bin/magento cache:clean
```

Activer un module
```
php bin/magento module:enable Wlc_Export
```

Lancer les setup magento après l'ajout d'un module 
```
php bin/magento setup:upgrade --keep-generated
```

Clean the cache and compiled code directories
```
cd <your Magento install dir>
rm -rf var/cache/* var/page_cache/* generated/* 
```

### N98-magerun2

L'outil est pré-installé sur le container php

### Erreurs possibles

#### Failure EADDRINUSE
En cas d'erreur lors du lancement du Docker, il se peut que certains ports soient utilisés (par un autre container Docker ou un daemon sur la machine).
Exemple :

```
ERROR: for varnish  Cannot start service varnish: driver failed programming external connectivity on endpoint yves-salomon_varnish_1 (b70821b718ab8c2c21418ac02207dd2144cc2d98c72c0be307b902814c35eab7): Error starting userland proxy: Bind for 0.0.0.0:80: unexpected error (Failure EADDRINUSE)
Encountered errors while bringing up the project.
```

Il faut alors fermer les applis tournant sur votre machine et utilisant les ports en question.

Pour les lister c'est pas compliqué :
```
sudo lsof -n -i4TCP:<num_port> | grep LISTEN
```
