
System configuration overview:
------------------------------

Available users:
- root / root

Installed software:
- Oracle Java JDK 1.7.0_21
- ElasticSearch 0.90.3

Elastic Search:
    * Cluster name: elasticsearch
    * Node name:    auto-generated
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


Have fun !

