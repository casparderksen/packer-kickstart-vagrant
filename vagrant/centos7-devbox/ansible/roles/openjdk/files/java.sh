# /etc/profile.d/java.sh - Managed by Ansible - do not change
export JAVA_HOME=$(type -p java | xargs readlink -f | xargs dirname | xargs dirname)