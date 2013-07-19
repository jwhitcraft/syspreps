#!/bin/bash
. /home/db2inst1/sqllib/db2profile
# create ddl file starting with EXPLAIN ALL FOR .... ;
# db2 -tf oppty_contact_qs.ddl 
# db2exfmt -d SUGARDB

echo "Preparing db for explains ..."
db2 connect to SUGARDB
db2 -tf /home/db2inst1/sqllib/misc/EXPLAIN.DDL

