#!/bin/sh -eux

# Load configuration parameters from environment
source ${STAGING_DIR}/environment.sh

# Install the Oracle Maven sync plug-in and run the push goal
sudo -i -u oracle << EOF
cd $ORACLE_HOME/oracle_common/plugins/maven/com/oracle/maven/oracle-maven-sync/12.2.1
mvn install:install-file -DpomFile=oracle-maven-sync-12.2.1.pom -Dfile=oracle-maven-sync-12.2.1.jar > /dev/null
mvn com.oracle.maven:oracle-maven-sync:push -DoracleHome=$ORACLE_HOME > /dev/null
EOF
