echo -- Parando contenedores --
sudo docker container stop easylife_mysql

echo -- Eliminando contenedores --
sudo docker container rm easylife_mysql

echo -- Borrando carpetas --
sudo rm -rf /opt/easylife/mysql

echo -- Creando y dando permisos a carpetas --
sudo mkdir -m 777 /opt/easylife/mysql
sudo mkdir -m 777 /opt/easylife/clones

echo -- Creando contenedores --
sudo docker container run -d -p 10103:3306 -v /opt/easylife/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=easylife -e MYSQL_USER=easylife -e MYSQL_PASSWORD=easylife --net nginx-net --name easylife_mysql mariadb:10.1 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
