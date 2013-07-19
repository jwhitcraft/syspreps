#!/bin/sh
. /home/db2inst1/sqllib/db2profile
export DB2DBDFT=SUGARDB     # set sugarult as the default branch
echo "*** force app disconnect"
db2 "FORCE APPLICATION ALL" # flush all connections
db2stop    # stop DB2
db2start    # start DB2
db2 "FORCE APPLICATION ALL" # flush all connections
echo "*** disable text search"
db2ts DISABLE DATABASE FOR TEXT CONNECT TO SUGARDB
echo "*** stop text service"
db2ts STOP FOR TEXT
echo "*** dropping db"
db2 "DROP DATABASE SUGARDB" # drop the previously existing database if it exists
echo "*** creating db"
db2 "CREATE DATABASE SUGARDB USING CODESET UTF-8 TERRITORY US COLLATE USING UCA500R1_LEN_S2 PAGESIZE 32 K"
echo "*** connecting to db"
db2 connect to SUGARDB  # To update the parameters below
echo "*** settings -> applheapsz"
db2 "UPDATE database configuration for SUGARDB using applheapsz automatic"
echo "*** settings -> stmtheap"
db2 "UPDATE database configuration for SUGARDB using stmtheap automatic"
echo "*** settings -> locklist"
db2 "UPDATE database configuration for SUGARDB using locklist automatic"
echo "*** settings -> indexrec"
db2 "UPDATE database configuration for SUGARDB using indexrec RESTART"
echo "*** settings -> maxlocks"
db2 "UPDATE database configuration for SUGARDB using maxlocks automatic"
echo "*** settings -> util_heap_sz"
db2 "UPDATE database configuration for SUGARDB using util_heap_sz 15015"
echo "*** settings -> logfilsiz"
db2 "UPDATE database configuration for SUGARDB using logfilsiz 4096"
echo "*** settings -> logprimary"
db2 "UPDATE database configuration for SUGARDB using logprimary 12"
echo "*** settings -> logsecond"
db2 "UPDATE database configuration for SUGARDB using logsecond 243"
echo "*** settings -> database_memory"
db2 "UPDATE database configuration for SUGARDB using DATABASE_MEMORY AUTOMATIC"
echo "*** settings -> java_heap_sz"
db2 "UPDATE database manager configuration using java_heap_sz 16384"
echo "*** settings -> mon_heap_sz"
db2 "UPDATE database manager configuration using mon_heap_sz automatic"

# Initial config
echo "*** create buffer pool"
db2 "CREATE BUFFERPOOL SUGARBP IMMEDIATE  SIZE 1000 AUTOMATIC PAGESIZE 32 K"
echo "*** create tablespace"
db2 "CREATE  LARGE  TABLESPACE SUGARTS PAGESIZE 32 K  MANAGED BY AUTOMATIC STORAGE EXTENTSIZE 32 OVERHEAD 10.5 PREFETCHSIZE 32 TRANSFERRATE 0.14 BUFFERPOOL SUGARBP"
echo "*** force app disconnect"
db2 "FORCE APPLICATION ALL" # close all conections to restart DB2 below

# compatibility vector
echo "*** setting -> compat vector"
db2set DB2_COMPATIBILITY_VECTOR=4008

# text search
echo "*** stop/restart db and connect"
db2stop
db2start
db2 "CONNECT TO SUGARDB"
echo "*** enable text search"
db2ts ENABLE DATABASE FOR TEXT AUTOGRANT CONNECT TO SUGARDB
echo "*** start text search"
db2ts START FOR TEXT

