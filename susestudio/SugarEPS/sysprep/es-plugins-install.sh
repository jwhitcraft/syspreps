#!/bin/bash
cd /usr/share/elasticsearch
echo -e "Installing ES plugins ... \c"
bin/plugin --install mobz/elasticsearch-head &> /dev/null
bin/plugin --install lukas-vlcek/bigdesk/2.2.0 &> /dev/null
bin/plugin --install polyfractal/elasticsearch-segmentspy &> /dev/null
bin/plugin --install elasticsearch/elasticsearch-lang-python/1.2.0 &> /dev/null
bin/plugin --install elasticsearch/elasticsearch-lang-javascript/1.4.0 &> /dev/null
echo "done"

