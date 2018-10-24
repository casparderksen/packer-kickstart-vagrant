# Oracle environment settings

export TMP=/tmp
export TMPDIR=$TMP

export ORACLE_HOSTNAME=vagrant.localdomain
export ORACLE_UNQNAME=db1.localdomain
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.2.0.1/db_1
export ORACLE_SID=db1

export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH

export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib
