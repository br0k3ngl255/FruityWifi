#!/bin/bash


find FruityWifi -type d -exec chmod 755 {} \;
find FruityWifi -type f -exec chmod 644 {} \;

mkdir tmp-install
cd tmp-install

apt-get update

update-rc.d ssh defaults
update-rc.d nginx defaults
update-rc.d ntp defaults


cmd=`gcc --version|grep "4.7"`
if [[ $cmd == "" ]]
then
	echo "--------------------------------"
    echo "Installing gcc 4.7"
	echo "--------------------------------"
    #exit;
	
	apt-get -y install gettext make intltool build-essential automake autoconf uuid uuid-dev php5-curl php5-cli dos2unix curl
	update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.7 40 --slave /usr/bin/g++ g++ /usr/bin/g++-4.7

else
	echo "--------------------------------"
    echo "Dev Tools already installed"
	echo "--------------------------------"
	echo
	echo
fi


if [ ! -f "/usr/sbin/dnsmasq" ]
then
	echo "--------------------------------"
    echo "Installing dnsmasq"
	echo "--------------------------------"
    #exit;
	
    # INSTALL DNSMASQ
    apt-get -y install dnsmasq

else
	echo "--------------------------------"
    echo "dnsmasq already installed"
	echo "--------------------------------"
	echo
	echo
fi


if [ ! -f "/usr/sbin/hostapd" ]
then

	echo "--------------------------------"
    echo "Installing hostapd"
	echo "--------------------------------"
    #exit;

    # INSTALL HOSTAPD
    apt-get -y install hostapd

else
	echo "--------------------------------"
    echo "hostapd already installed"
	echo "--------------------------------"
	echo
	echo
fi


if [ ! -f "/usr/sbin/airmon-ng" ] &&  [ ! -f "/usr/local/sbin/airmon-ng" ]
then
	echo "--------------------------------"
    echo "Installing aircrack-ng"
	echo "--------------------------------"
	#exit;

    # INSTALL AIRCRACK-NG
    apt-get -y install libssl-dev
    wget http://download.aircrack-ng.org/aircrack-ng-1.2-beta1.tar.gz
    tar -zxvf aircrack-ng-1.2-beta1.tar.gz
    cd aircrack-ng-1.2-beta1
    make
	make install
    cd ../

else
	echo "--------------------------------"
    echo "aircrack-ng already installed"
	echo "--------------------------------"
	echo
	echo
fi


if [ ! -f "/usr/sbin/nginx" ]
then
	echo "--------------------------------"
    echo "Installing nginx"
	echo "--------------------------------"
    #exit;

    # NGINX SETUP
    apt-get -y install nginx php5-fpm php-apc sqlite3 php5-sqlite

else
	echo "--------------------------------"
    echo "nginx already installed"
	echo "--------------------------------"
	echo
	echo
fi

cmd=`date +"%Y-%m-%d-%k-%M-%S"`
cd ../
mv /usr/share/FruityWifi FruityWifi.BAK.$cmd
rm /var/www/FruityWifi
mkdir /FruityWifi
cp -a FruityWifi /usr/share/FruityWifi
ln -s /usr/share/FruityWifi/www /FruityWifi
ln -s /usr/share/FruityWifi/logs /FruityWifi/logs
mkdir /var/www/tmp
chown www-data:www-data /var/www/tmp
chmod  777 /var/www/tmp
chmod 755 /usr/share/FruityWifi/squid.inject/poison.pl
ln -s /usr/share/FruityWifi/www.site /var/www/site
chown -R www-data.www-data /usr/share/FruityWifi/www.site
chmod 777 /usr/share/FruityWifi/www.site/data.txt
chmod 777 /usr/share/FruityWifi/www.site/inject/data.txt

#mkdir /FruityWifi/logs/kismet
#mkdir /FruityWifi/logs/sslstrip

# BIN
cd /usr/share/FruityWifi/bin/
gcc danger.c -o danger
chmod 4755 danger

/etc/init.d/apache2 start

###update-rc.d -f squid3 remove
apt-get -y remove ifplugd

echo "ENJOY!"
echo ""

