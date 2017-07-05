
# wordpress-server

compose command ::

```
docker-compose -f docker-compose.yml up

```

docker run command ::

```
docker run --env-file env-file -v /path/to/folder-1:/etc/apache2 -v /path/to/folder-2:/var/www/html -p <<host port>>:80 -it --name <<container-name>> --hostname <<hostname>> akhilrajmailbox/wordpress-server:latest

```

environment variable ::

Create a file with the following variable (for docker compose command)

```
# mandatory docker variable

PORT_NO			=	port number for accessing from browser (http://host_ip:PORT_NO)
MYSQL_ROOT_PASSWORD	=	mysql root password
MYSQL_DATABASE		=	wordpress database for storing data	
MYSQL_USER		=	wordpress username
MYSQL_PASSWORD		=	password for wordpress user
```


Create a file with the following variable (for docker run command)


```
# for remote database by docker run command
# mandatory docker variable

MYSQL_DATABASE          =       wordpress database for storing data
MYSQL_USER              =       wordpress username
MYSQL_PASSWORD          =       password for wordpress user
MYSQL_HOST		=	ip address of mysql server
```


NOTE :::

Possible values of 'docker variable'

	*	PORT_NO			=	<<port_number>>
	*	MYSQL_ROOT_PASSWORD	=	<<string>>
	*	MYSQL_DATABASE		=	<<string>>
	*	MYSQL_USER		=	<<string>>
	*	MYSQL_PASSWORD		=	<<string>>
	*	MYSQL_HOST		=	<<ip_address>>


example environment file  :: (for docker compose command)

```
# mandatory docker variable

PORT_NO=9875

MYSQL_ROOT_PASSWORD=wordpress@root
MYSQL_DATABASE=worddata
MYSQL_USER=wordpress
MYSQL_PASSWORD=wordpress@user

```
example environment file  :: (for docker run command)

```
# for remote database by docker run command
# mandatory docker variable

MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=wordpress
MYSQL_HOST=192.168.1.106
```


NOTE ::

If these directories are not empty then the server will not overwirte the configuration, it will choose the existing one.

```
here we are mounting these directory to host,

        /etc/apache2            =       for apache2 configuration
        /var/www/html           =       for web page
        /var/lib/mysql          =       for mysql data

```

