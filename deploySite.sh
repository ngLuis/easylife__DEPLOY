#!/usr/bin/env bash

TYPE=$1

echo -- Parando contenedores --
sudo docker container stop easylife_www

echo -- Eliminando contenedores --
sudo docker container rm easylife_www

echo -- Borrando carpetas --
sudo rm -rf ./www

echo -- Creando y dando permisos a carpetas --
sudo rm -rf ./clones
sudo rm -rf ./www
sudo mkdir -m 777 ./www
sudo mkdir -m 777 ./clones

echo -- Bajando codigo fuente --
sudo git clone --branch deploySite https://github.com/ngLuis/easylife__SITE ./clones/easylife__SITE

echo -- Compilando codigo --
sudo npm install --prefix ./clones/easylife__SITE/
sudo npm run build --prefix ./clones/easylife__SITE/

echo -- Copiando ficheros... --
sudo cp -R ./clones/easylife__SITE/dist/* ./www

echo -- Creando contenedores de $TYPE --
if [ $TYPE = 'produccion' ]; then
    sudo docker container run -d --expose 80 -v /opt/easylife/www:/usr/local/apache2/htdocs/ -e VIRTUAL_HOST=www.easylife.pve2.fpmislata.com -e LETSENCRYPT_HOST=www.easylife.pve2.fpmislata.com --net nginx-net --name easylife_www httpd:latest
elif [ $TYPE = 'preproduccion' ]; then
    sudo docker container run -d -p 10101:80 -v /opt/easylife/www:/usr/local/apache2/htdocs/ -e VIRTUAL_HOST=www.easylife.pve2.fpmislata.com -e LETSENCRYPT_HOST=www.easylife.pve2.fpmislata.com --net nginx-net --name easylife_www httpd:latest
fi
