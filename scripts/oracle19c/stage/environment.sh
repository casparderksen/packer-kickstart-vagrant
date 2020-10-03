# Oracle environment settings

export TMP=/tmp
export TMPDIR=$TMP

export ORACLE_HOSTNAME=$HOSTNAME
export ORACLE_UNQNAME=ORCLCDB
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/19c/dbhome_1
export ORA_INVENTORY=${ORACLE_BASE}/oraInventory
export DATA_DIR=${ORACLE_BASE}/oradata
export ORACLE_SID=ORCLCDB
export PDB_NAME=ORCLPDB1

export PATH=$ORACLE_HOME/bin:/usr/sbin:$PATH

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib