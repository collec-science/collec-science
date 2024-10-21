#!/bin/bash
PHPOLDVERSION=`ls /etc/apache2/mods-enabled/|grep php.*load|cut -c 4-6`
PHPVER=8.3
if [ $PHPOLDVERSION = $PHPVER ]
then
	echo "Your web server works with the version $PHPOLDVERSION of PHP."
	echo "It's ok, you don't have anything to do"
else
	echo "Warning: you must have a backup of your server before run this upgrade."
	read -p "Your web server works with the version $PHPOLDVERSION of PHP. Do you want to upgrade to $PHPVER [y/n]?" response
	if [ "$response" = "y" ]
	then
	  # installing php repository
	  apt -y install lsb-release apt-transport-https ca-certificates
	  DISTRIBCODE=`lsb_release -sc`
	  DISTRIBNAME=`lsb_release -si`
	  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
	  if [ $DISTRIBNAME == 'Ubuntu' ]
	  then
	    # Ubuntu
	    apt-get -y install software-properties-common
	    add-apt-repository -y ppa:ondrej/php
	    add-apt-repository -y ppa:ondrej/apache2
	  else
	  # Debian
	    wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
	    echo "deb https://packages.sury.org/php/ $DISTRIBCODE main" | tee /etc/apt/sources.list.d/php.list
	    apt-get update
	  fi
	  apt-get -y install libapache2-mod-php$PHPVER php$PHPVER php$PHPVER-ldap php$PHPVER-pgsql php$PHPVER-mbstring php$PHPVER-xml php$PHPVER-zip php$PHPVER-imagick php$PHPVER-gd php$PHPVER-curl  $PHPVER-intl
	  /usr/sbin/a2dismod php$PHPOLDVERSION
	  /usr/sbin/a2enmod php$PHPVER
	  # update php.ini
	  PHPINIFILE="/etc/php/$PHPVER/apache2/php.ini"
	  upload_max_filesize="=100M"
	  post_max_size="=50M"
	  max_execution_time="=120"
	  max_input_time="=240"
	  memory_limit="=1024M"
	  max_input_vars="10000"
	  for key in upload_max_filesize post_max_size max_execution_time max_input_time memory_limit
	  do
	    sed -i "s/^\($key\).*/\1 $(eval echo \${$key})/" $PHPINIFILE
	  done
	  sed -i "s/; max_input_vars = .*/max_input_vars=$max_input_vars/" $PHPINIFILE
	  systemctl restart apache2
	fi
fi
