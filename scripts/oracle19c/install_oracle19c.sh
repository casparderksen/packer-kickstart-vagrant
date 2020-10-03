#!/bin/sh -eux

# Install software
dnf -y localinstall ${STAGING_DIR}/oracle-database-ee-19c-1.0-1.x86_64.rpm

# Add vagrant user to Oracle group
usermod -a -G oinstall,dba,oper vagrant

# Create database
/etc/init.d/oracledb_ORCLCDB-19c configure

# Add systemctl service
cp "${STAGING_DIR}/oracle19c.service" /etc/systemd/system
systemctl daemon-reload
systemctl enable oracle19c

# Configure automatic restart of database instance
sed -e 's/:N$/:Y/' -i /etc/oratab

# Setup Oracle environment settings for user oracle
cat "${STAGING_DIR}/environment.sh" >> /home/oracle/.bash_profile
echo 'alias sysdba="sqlplus / as sysdba"' >> /home/oracle/.bashrc
echo 'alias so="sudo -i -u oracle"' >> /home/vagrant/.bashrc

# Enable Oracle Managed Files (OMF) and make sure the PDB is open when the instance starts
source "${STAGING_DIR}/environment.sh"
sudo -i -u oracle sqlplus / as sysdba <<EOF
ALTER SYSTEM SET DB_CREATE_FILE_DEST="${DATA_DIR}";
ALTER PLUGGABLE DATABASE ALL OPEN;
ALTER PLUGGABLE DATABASE "${PDB_NAME}" SAVE STATE;
EOF

# Remove staging area
rm -r "${STAGING_DIR}"
