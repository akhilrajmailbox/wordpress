#!/bin/bash
A=$(tput sgr0)

if [ "$(ls -A /etc/apache2/)" ]; then
echo " '/etc/apache2' found"
else
cp -r /root/apache2/. /etc/apache2
fi
chown -R :www-data /etc/apache2


if [ ! -e /var/www/html/wordpress/bootstrapped ]; then
echo "configuring wordpress for first run"

echo ""
[ -z "$MYSQL_DATABASE" ] && echo -e '\E[32m'"varable error : MYSQL_DATABASE $A"
[ -z "$MYSQL_USER" ] && echo -e '\E[32m'"varable error : MYSQL_USER $A"
[ -z "$MYSQL_PASSWORD" ] && echo -e '\E[32m'"varable error : MYSQL_PASSWORD $A"
[ -z "$MYSQL_HOST" ] && echo -e '\E[32m'"optional varable is empty, so it will use docker-compose mysql : MYSQL_HOST $A"
echo ""

sleep 3

 if [[ "$MYSQL_DATABASE" = "" || "$MYSQL_USER" = "" || "$MYSQL_PASSWORD" = "" ]]; then
echo ""
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|      mandatory docker variable       | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|       1) MYSQL_DATABASE              | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|       2) MYSQL_USER                  | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|       3) MYSQL_PASSWORD              | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo ""
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|      Optional docker variable        | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo -e '\E[33m'"|        4) MYSQL_HOST                 | $A"
echo -e '\E[33m'"---------------------------------------- $A"
echo ""
echo -e '\E[32m'"###################################### $A"
echo -e '\E[32m'"###        MYSQL_DATABASE          ### $A"
echo -e '\E[32m'"###################################### $A"
echo -e '\E[33m'"You need to provide the database name for wordpress $A"
echo ""
echo -e '\E[32m'"###################################### $A"
echo -e '\E[32m'"###          MYSQL_USER            ### $A"
echo -e '\E[32m'"###################################### $A"
echo -e '\E[33m'"You need to provide the mysql user for access the wordpress user $A"
echo ""
echo -e '\E[32m'"###################################### $A"
echo -e '\E[32m'"###         MYSQL_PASSWORD         ### $A"
echo -e '\E[32m'"###################################### $A"
echo -e '\E[33m'"Need to provide the wordpress user password $A"
echo ""
echo -e '\E[32m'"###################################### $A"
echo -e '\E[32m'"###            MYSQL_HOST          ### $A"
echo -e '\E[32m'"###################################### $A"
echo -e '\E[33m'"You need to provide the host ip of mysql server if you want to connect with remote mysql server $A"
echo ""
echo ""
echo -e '\E[32m'"provide all environment variable with -e option in 'docker run command' $A"
echo "aborting....!"
echo ""
exit 0
 else
echo ""
 fi

sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/html/wordpress|g" /etc/apache2/sites-available/000-default.conf
unzip -q /tmp/latest.zip -d /var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress
mkdir -p /var/www/html/wordpress/wp-content/uploads
chown -R :www-data /var/www/html/wordpress/wp-content/uploads

cd /var/www/html/wordpress/
cp wp-config-sample.php wp-config.php
sed -i "s|define('DB_NAME', 'database_name_here');|define('DB_NAME', '$MYSQL_DATABASE');|g" wp-config.php
sed -i "s|define('DB_USER', 'username_here');|define('DB_USER', '$MYSQL_USER');|g" wp-config.php
sed -i "s|define('DB_PASSWORD', 'password_here');|define('DB_PASSWORD', '$MYSQL_PASSWORD');|g" wp-config.php

   if [ "$MYSQL_HOST" = "" ]; then
sed -i "s|define('DB_HOST', 'localhost');|define('DB_HOST', 'wp-mysql-servce');|g" wp-config.php
   else
sed -i "s|define('DB_HOST', 'localhost');|define('DB_HOST', '$MYSQL_HOST');|g" wp-config.php
   fi

touch /var/www/html/wordpress/bootstrapped
else
echo "found already-configured wordpress"
fi

    if [ "$MYSQL_HOST" = "" ]; then
until (mysql -h wp-mysql-servce -u $MYSQL_USER -p$MYSQL_PASSWORD -e 'show databases;' 2>/dev/null | grep $MYSQL_DATABASE)
do
sleep 2
echo "'$MYSQL_USER' can't able to connected to '$MYSQL_DATABASE' on wp-mysql-servce"
done
    else
until (mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e 'show databases;' 2>/dev/null | grep $MYSQL_DATABASE)
do
sleep 2
echo "'$MYSQL_USER' can't able to connected to '$MYSQL_DATABASE' on '$MYSQL_HOST' "
done
    fi

export TERM=xterm
a2ensite 000-default.conf
/etc/init.d/apache2 restart
tailf /root/start.sh
