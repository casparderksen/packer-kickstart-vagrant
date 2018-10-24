#!/bin/bash

ORAENV_ASK=NO
. oraenv
ORAENV_ASK=YES

# Start Listener
lsnrctl start

# Start Database
sqlplus / as sysdba << EOF
STARTUP;
EXIT;
EOF
