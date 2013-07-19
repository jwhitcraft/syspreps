#!/bin/sh
. /home/db2inst1/sqllib/db2profile
db2 connect to SUGARDB
db2 "Select 'DROP TABLE', TABLE_NAME from sysibm.tables WHERE TABLE_SCHEMA = UPPER('$USER')" | grep DROP | db2

