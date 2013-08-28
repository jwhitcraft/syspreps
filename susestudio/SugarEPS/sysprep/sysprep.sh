#!/bin/bash

SYSLOG=/opt/install/sysprep/sysprep.log
touch $SYSLOG

# Java installation
echo -e "Installing Java ... \c"
chown -R root:root /opt/install/jdk1.7.0_21
mv /opt/install/jdk1.7.0_21/ /usr/lib64/
ln -s -T /usr/lib64/jdk1.7.0_21/ /usr/lib64/jdk_Oracle
# intall and config alternatives
/usr/sbin/update-alternatives --install /usr/bin/java java /usr/lib64/jdk_Oracle/bin/java 3 >> $SYSLOG 2>&1
/usr/sbin/update-alternatives --install /usr/bin/javac javac /usr/lib64/jdk_Oracle/bin/javac 3 >> $SYSLOG 2>&1
/usr/sbin/update-alternatives --install /usr/lib64/browser-plugins/javaplugin.so javaplugin /usr/lib64/jdk_Oracle/jre/lib/amd64/libnpjp2.so 3 --slave /usr/bin/javaws javaws /usr/lib64/jdk_Oracle/bin/javaws >> $SYSLOG 2>&1
/usr/sbin/update-alternatives --config java >> $SYSLOG 2>&1
/usr/sbin/update-alternatives --config javac >> $SYSLOG 2>&1
/usr/sbin/update-alternatives --config javaplugin >> $SYSLOG 2>&1
echo "done"

# Install DB2 using response file - set hostname to prevent db2 setup failure
echo -e "Installing DB2 (can take a while, please be patient) ... \c"
hostname sugardb2.site >> $SYSLOG 2>&1
echo "sugardb2.site" > /etc/HOSTNAME
echo "127.0.0.2 sugardb2.site sugardb2" >> /etc/hosts
/opt/install/special_27924_linuxamd64_expc/db2setup -f sysreq -r /opt/install/sysprep/db2/db2expc.rsp >> $SYSLOG 2>&1
# wrong permission on .fenced preventing text search to function
chown db2inst1:db2iadm1 /home/db2inst1/sqllib/adm/.fenced
# db2scripts
cp /opt/install/sysprep/db2scripts/* /home/db2inst1/bin
chown db2inst1:users /home/db2inst1/bin/*.sh
chmod +x /home/db2inst1/bin/*.sh
echo "done"

# DB2 setup (starts DB2 and creates database)
echo -e "Configuring DB2 (can take a while, please be patient) ... \c"
su - db2inst1 -c "/home/db2inst1/bin/create_oltp.sh" >> $SYSLOG 2>&1
echo "done"

# DB2 php driver
echo -e "Compiling PHP DB2 connector ... \c"
cp /opt/install/ibm_db2-1.9.2.tgz /usr/local/src >> $SYSLOG 2>&1
cd /usr/local >> $SYSLOG 2>&1
tar xfz src/ibm_db2-1.9.2.tgz >> $SYSLOG 2>&1
cd /usr/local/ibm_db2-1.9.2 >> $SYSLOG 2>&1
phpize --clean >> $SYSLOG 2>&1
phpize >> $SYSLOG 2>&1
./configure --with-IBM_DB2=/opt/ibm/db2/V9.7 >> $SYSLOG 2>&1
make >> $SYSLOG 2>&1
make install >> $SYSLOG 2>&1
# php setup
cp /opt/install/sysprep/php/ibm_db2.ini /etc/php5/conf.d
cp /opt/install/sysprep/php/php.ini /etc/php5/apache2
echo "done"
  
# Start mysql and Apache by default
echo -e "Setting up Apache2 and MySQL ... \c"
cp /opt/install/sysprep/apache/listen.conf /etc/apache2
cp /opt/install/sysprep/apache/uid.conf /etc/apache2
cp /opt/install/sysprep/apache/default.conf /etc/apache2/vhosts.d
chown dev:users /var/lib/php5
chkconfig -a apache2 >> $SYSLOG 2>&1
chkconfig -a mysql >> $SYSLOG 2>&1
rcapache2 restart >> $SYSLOG 2>&1
rcmysql restart >> $SYSLOG 2>&1
chown dev:users /var/lib/php5
chown -R dev:users /srv/www/htdocs
echo "done"

# Elastic Search
echo -e "Installing Elastic Search ... \c"
rpm -U /opt/install/elasticsearch-0.90.3.noarch.rpm >> $SYSLOG 2>&1
cp /etc/rc.d/init.d/elasticsearch /etc/init.d
ln -s /etc/init.d/elasticsearch /sbin/rcelasticsearch
cp /opt/install/sysprep/elastic/elasticsearch.yml /etc/elasticsearch
cp /opt/install/sysprep/elastic/elasticsearch /etc/sysconfig
cp /opt/install/sysprep/elastic/elasticsearch.service /etc/systemd/system
systemctl --system daemon-reload >> $SYSLOG 2>&1
echo "done"

# ES plugins (internet connection required)
echo -e "Installing ES plugins ... \c"
ping -c 3 www.github.com >> $SYSLOG 2>&1
if [ $? -eq 0 ]; then
    /opt/install/sysprep/es-plugins-install.sh >> $SYSLOG 2>&1
    echo "done"
else
    echo "skipped"
fi

# ES startup
echo -e "Startup Elastic Search ... \c"
/sbin/rcelasticsearch restart >> $SYSLOG 2>&1
echo "done"

echo ""
echo "************************************************************"
echo "*** See /opt/install/sysprep/readme.txt for more details ***"
echo "************************************************************"
echo ""

