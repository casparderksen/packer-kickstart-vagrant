#!/bin/bash -eux

log() {
    echo "$*" >&2
}

# Check if user is root

if [ "$EUID" -ne "0" ]; then
  log "This script must be run as root."
  exit 1
fi

# Exit if Puppet is already installed

if which puppet > /dev/null 2>&1; then
  log "Puppet is already installed."
  exit 0
fi

# Enable the Puppet Collection 1 repository

log "Installing puppet repository"
version=$(rpm -q --queryformat '%{VERSION}' centos-release)
rpm -iv https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${version}.noarch.rpm

# Install Puppet

log "Installing Puppet"
yum -y install puppet

# Install hiera-eyaml
log "Installing hiera-eyaml"
/opt/puppetlabs/puppet/bin/gem install hiera-eyaml

# Install r10k (older version due to https://github.com/puppetlabs/r10k/issues/856)
log "Installing r10k"
/opt/puppetlabs/puppet/bin/gem install r10k:2.6.4