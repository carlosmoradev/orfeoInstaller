#!/bin/sh

# Script para realizar la instalacion base de orfeo
#Contacto@carlosmora.biz

###############################################################################

REPOSITORIO="https://github.com/cmmora/orfeo384.git"    #Repositorio github
LOCAL="/var/www/html"
DBNAME="dborfeo384"
DBUSER="orfeo_user"
DBPASSWORD="0rf30**$$"
INSTALLDIR="$LOCAL/orfeo384/instalacion"
PHPDIR="/etc/php/5.6/apache2"
POSTGRESQLDIR="/etc/postgresql/9.5/main"

###############################################################################

apt-get update
apt-get upgrade -y

echo  "Por favor lea con mucha atencion el siguiente mensaje: \n"

cat advertencia.txt 


sleep 10

add-apt-repository ppa:ondrej/php; apt-get update; apt-get install php5.6-pgsql postgresql apache2 libgda-5.0-postgres   postgresql-common  postgresql-client-common libpg-perl postgresql postgresql-client php5.6 libapache2-mod-php5.6 php5.6-curl php5.6-gd php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml php5.6-xmlrpc php5.6-pgsql php5.6-xsl  php5.6-imap php5.6-sqlite3 php5.6-ldap php5.6-zip zip git -y

cd $LOCAL

echo  "Comienza la descarga del repositorio $REPOSITORIO"
git clone $REPOSITORIO
sleep 2
chown www-data:www-data $LOCAL -Rv
cp index.html index.html.preOrfeo

cat $INSTALLDIR/index.html > $LOCAL/index.html


echo  "A continuacion se va a crear la base de datos"
sleep 3
cd /tmp
sudo -u postgres psql -c "CREATE USER $DBUSER;"
sudo -u postgres psql -c "alter user $DBUSER with password '$DBPASSWORD';"
sudo -u postgres psql -c "CREATE DATABASE $DBNAME WITH OWNER $DBUSER;"

echo  "Cargando la base de datos inicial"
sleep 3

sudo -u postgres psql $DBNAME -c "\i $INSTALLDIR/dborfeo384.sql;"
sudo -u postgres psql $DBNAME -c "update usuario set usua_nuevo=0 where usua_login='ADMON';"

cp $PHPDIR/php.ini $PHPDIR/php.ini.preOrfeo
cat $INSTALLDIR/phpBase.ini > $PHPDIR/php.ini; /etc/init.d/apache2 restart

cp $POSTGRESQLDIR/pg_hba.conf	$POSTGRESQLDIR/pg_hba.conf.preOrfeo
cat $INSTALLDIR/pg_hba.conf > $POSTGRESQLDIR/pg_hba.conf; /etc/init.d/postgresql restart
cd
clear
echo  "Instalacion de orfeo Finalizada."
echo
echo
SERVIDOR=$(ifconfig  | grep inet| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}' |head -n 1)
echo "Ingrese a su servidor en la direccion: http://$SERVIDOR"