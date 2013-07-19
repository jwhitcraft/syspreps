#!/bin/bash
. /home/db2inst1/sqllib/db2profile
if [ $# -eq 1 ]; then
    db=$1
else
    db=SUGARDB
fi
basedir="/home/db2inst1/snapshots"
ts=`date +%Y%m%d-%H%M%S`
dir="$basedir/$db-$ts"
mkdir -p $dir
echo "*** Connecting to db"
db2 connect to $db
echo "*** Setting up monitor switches"
db2 update monitor switches using bufferpool on lock on uow on sort on table on statement on timestamp on
echo "*** Taking before snapshot"
db2 get snapshot for all on $db > $dir/$db-before.snap
echo "*** Hit enter for next snapshot"
read -n 1
echo "*** Taking after snapshot"
db2 get snapshot for all on $db > $dir/$db-after.snap
echo "*** Cleanup monitor switches"
db2 update monitor switches using bufferpool off lock off uow off sort off table off statement off timestamp off
echo "*** Done --> $dir"
cd $dir
