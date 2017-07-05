from akhilrajmailbox/ubuntu:14.04
maintainer Akhil Raj <akhilrajmailbox@gmail.com>

run apt-get -y update && apt-get upgrade -y && apt-get -y install apache2 php5 libapache2-mod-php5 unzip mysql-client \
	php5-curl libssh2-php rsync php5-mysql php5-fpm openssh-server openssh-client git unzip nano sudo wget php5-imagick php5-gd


#run sed -i "s|expose_php = On|expose_php = Off|g" /etc/php5/apache2/php.ini
#run sed -i "s|allow_url_fopen = On|allow_url_fopen = Off|g" /etc/php5/apache2/php.ini

workdir /tmp
run wget http://wordpress.org/latest.zip

run chown -R www-data:www-data /var/www/html/
run chmod 755 -R /var/www/html/
run cp -r /etc/apache2 /root/apache2
workdir /var/www/html/
copy start.sh /root/start.sh
run chmod 777 /root/start.sh
#entrypoint service apache2 restart && service php5-fpm restart && tail -f /dev/null && bash
entrypoint "/root/start.sh"
