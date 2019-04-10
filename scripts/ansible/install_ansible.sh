#!/bin/bash -eux

log() {
    echo "$*" >&2
}

# Check if user is root

if [ "$EUID" -ne "0" ]; then
  log "This script must be run as root."
  exit 1
fi

# Exit if Ansible is already installed

if which ansible > /dev/null 2>&1; then
  log "Ansible is already installed."
  exit 0
fi

# Install Ansible

log "Installing Ansible"
yum -y install ansible