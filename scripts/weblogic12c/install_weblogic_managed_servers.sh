#!/bin/sh -eux

# Function generate_password(): generate random password
generate_password() {
    echo $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
}

# Function wlst(script, arg, ...): execute wlst script
wlst() {
    script=$1
    shift
    sudo -i -u oracle ${ORACLE_HOME}/oracle_common/common/bin/wlst.sh \
        ${script} $*
}

# Function create_server(name, port): create managed server
create_server() {
    wlst ${STAGING_DIR}/wlst/create_server.py "$1" "$2"
}

# Function create_admin_user(user, password, description): create new admin user
create_admin_user() {
    wlst ${STAGING_DIR}/wlst/create_admin_user.py "$1" "$2" "$3"
}

# Source Oracle environment settings
source ${STAGING_DIR}/environment.sh

# Create daemon user in admin group for booting servers
daemon_user="weblogic_daemon"
daemon_password=$(generate_password)
create_admin_user "${daemon_user}" "${daemon_password}" \
    "This user boots servers"

# Create managed servers
servers=( server1 server2 )
port=7010
for server in "${servers[@]}"; do

    # Create managed server at next port number
    create_server "${server}" $((++port))

    # Create boot.properties file
    server_dir=${DOMAIN_HOME}/servers/${server}
    mkdir -m 0750 ${server_dir}
    security_dir=${server_dir}/security
    mkdir -m 0750 ${security_dir}
    boot_properties_file=${security_dir}/boot.properties
    echo "username=${daemon_user}" > ${boot_properties_file}
    echo "password=${daemon_password}" >> ${boot_properties_file}
    chmod 640 ${boot_properties_file}
    chown -R oracle:oinstall ${server_dir}

    # Create upstart job
    sed -e "s|@DOMAIN_HOME|${DOMAIN_HOME}|" \
        -e "s|@SERVER|${server}|" \
        ${STAGING_DIR}/systemd/managedserver.service > /etc/systemd/system/${server}.service
    systemctl enable ${server}

    # Start managed server
    systemctl start ${server}

done
