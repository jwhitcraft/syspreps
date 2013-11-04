#!/bin/bash

SYSLOG=/root/sysprep.log
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

# Elastic Search
echo -e "Installing Elastic Search ... \c"
rpm -U /opt/install/elasticsearch-0.90.6.noarch.rpm >> $SYSLOG 2>&1
cp /etc/rc.d/init.d/elasticsearch /etc/init.d
ln -s /etc/init.d/elasticsearch /sbin/rcelasticsearch
cp /opt/install/sysprep/elastic/elasticsearch.yml /etc/elasticsearch
cp /opt/install/sysprep/elastic/elasticsearch /etc/sysconfig
cp /opt/install/sysprep/elastic/elasticsearch.service /etc/systemd/system
echo "done"

echo ""
echo "************************************************************"
echo "*** See /opt/install/sysprep/readme.txt for more details ***"
echo "************************************************************"
echo ""

