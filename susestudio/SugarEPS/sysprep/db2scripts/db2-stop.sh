#!/bin/sh
. /home/db2inst1/sqllib/db2profile
db2ts stop for text
db2 force application all
db2stop

