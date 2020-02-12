#!/usr/bin/env bash

TYPE=$1

echo -- Parando contenedores --
sudo docker container stop easylife_api

echo -- Eliminando contenedores --
sudo docker container rm easylife_api

echo -- Borrando carpetas --
sudo rm -rf ./api

echo -- Creando y dando permisos a carpetas --
sudo rm -rf ./clones
sudo rm -rf ./clones
sudo mkdir -m 777 ./api
sudo mkdir -m 777 ./clones

echo -- Bajando codigo fuente --
sudo git clone --branch despliegueAPI https://github.com/ngLuis/easylife__API ./clones/easylife__API

echo -- Copiando ficheros... --
sudo cp -R ./clones/easylife__API/src/* ./api
sudo cp -R ./clones/easylife__API/src/.* ./api

echo -- Creando contenedores en $TYPE --

if [ $TYPE = 'produccion' ]; then
    sudo docker container run -d --expose 80 -v /opt/easylife/api:/var/www/html -e VIRTUAL_HOST=api.easylife.pve2.fpmislata.com -e LETSENCRYPT_HOST=api.easylife.pve2.fpmislata.com --net nginx-net --name easylife_api php:7.3-apache
elif [ $TYPE = 'preproduccion' ]; then
    sudo docker container run -d -p 10102:80 -v /opt/easylife/api:/var/www/html -e VIRTUAL_HOST=api.easylife.pve2.fpmislata.com -e LETSENCRYPT_HOST=api.easylife.pve2.fpmislata.com --net nginx-net --name easylife_api php:7.3-apache
fi
sudo chmod -R 777 ./api

echo -- Configurando contenedor --
sudo docker exec -it easylife_api a2enmod rewrite
sudo docker exec -it easylife_api docker-php-ext-install pdo pdo_mysql
sudo docker restart easylife_api

echo -- Crear las migraciones para la estructura de la base de datos  --
sudo docker exec -it easylife_api bash -c "php artisan migrate:fresh"

echo -- Insertando datos en la base de datos --
sudo docker exec -i easylife_mysql sh -c 'exec mysql -uroot -p"root"' < ./clones/easylife__API/db/insertData.sql
