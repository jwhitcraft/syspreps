
System configuration overview:
------------------------------

Available users:
- root / root
- dev / dev
- db2inst1 / db2inst1

Installed software:
- IBM DB2 Express-C 9.7.5
- Oracle Java JDK 1.7.0_21
- ElasticSearch 0.90.3
- MySQL 5.5.30
- PHP 5.3.17

Apache:
    * Root dir: /srv/www/htdocs
    * User:     dev
    * Group:    users

IBM DB2:
    * Credentials:  db2inst1/db2inst1
    * Database:     SUGARDB
    * Port:         50001
    * Autostart:    no

Mysql:
    * Credentials:  root/root
    * phpMyAdmin:   http://host/phpMyAdmin
    * Autostart:    yes

Elastic Search:
    * Cluster name: elasticsearch
    * Node name:    sugarcrm
    * Logs:         /var/log/elasticsearch
    * Storage:      /var/lib/elasticsearch
    * Config:       /etc/elasticsearch
    * Sysconfig:    /etc/sysconfig/elasticsearch
    * Autostart:    yes

ES site plugins: (*)
    * Head:         http://host:9200/_plugin/head/
    * Bigdesk:      http://host:9200/_plugin/bigdesk/
    * SegmentSpy:   http://host:9200/_plugin/segmentspy/
    * ElasticHQ:    http://host:9200/_plugin/HQ/

ES scripting plugins: (*)
    * Python
    * Jscript


(*) Those were only installed by the sysprep script if an
    Internet connection was available. If this step was
    skipped, run /opt/install/sysprep/es-plugins-install.sh

Additional DB2 scripts:
-----------------------

The following commands are available for db2inst1 user:

1) create_oltp.sh

    Drops and recreates the SUGARDB database with the required
    settings for SugarCRM.

2) drop_tables.sh

    Drops all tables from SUGARDB. A faster way to empty the 
    database when reinstalling SugarCRM.

3) db2-start.sh and db2-stop.sh

    Start/stop DB2. Note that DB2 is NOT automatically started
    during boot. 

4) prep_for_explain.sh

    Creates the necessary DDL for SUGARDB database to be able
    to execute explain queries.

5) snapshot.sh

    Create database snapshot to trace events, (dead)locks, ...



Have fun !

