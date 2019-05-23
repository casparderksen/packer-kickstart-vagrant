# Contents

- [About](#about)
- [Prequisites](#prequisites)
- [Makefile for Packer builds](#makefile-for-packer-builds)
- [Boxes created with Packer](#boxes-created-with-packer)
  - [CentOS-7 base box](#centos-7-base-box)
  - [Ansible box](#ansible-box)
  - [Development box](#development-box)
  - [Puppet box](#puppet-box)
  - [Oracle 12c database](#oracle-12c-database)
  - [Weblogic 12c](#weblogic-12c)
- [Vagrant examples](#vagrant-examples)
  - [Centos7 base box](#centos7-base-box)
  - [Centos7 Ansible box](#centos7-ansible-box)
  - [Centos7 Development box](#centos7-development-box)
  - [Centos7 Oracle 12c box](#centos7-oracle-12c-box)
  - [Centos7 Weblogic 12c box](#centos7-weblogic-12c-box)
  - [Centos7 Puppet box](#centos7-puppet-box)

# About

This project builds CentOS boxes with Packer and Kickstart for use with Vagrant.
Packer templates are provided for creating a minimal base box, and other boxes
based on this base box. By reusing base boxes instead of provisioning each box from scratch, 
build time is significantly reduced (similar to layered Docker images). 

# Prequisites

Download the following files to the `iso` directory:

- [`CentOS-7-x86_64-Minimal-1810.iso`](http://isoredirect.centos.org/centos/7/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
- [`VBoxGuestAdditions_5.1.26.iso`](https://download.virtualbox.org/virtualbox/5.2.26/VBoxGuestAdditions_5.2.26.iso)

When using different versions, adapt the file names and SHA256 checksums in `templates/centos7-basebox` accordingly.

# Makefile for Packer builds

A GNU Makefile is provided for convenience and for managing dependencies between images and source files.
The Makefile provides the following targets:

	all:     build all boxes and add to vagrant
	boxes:   build all boxes
	basebox: build mimimal base box
	add:     add boxes to vagrant
	remove:  remove boxes from vagrant
	list:    list vagrant boxes
	clean:   remove generated boxes
	clobber: remove generated boxes and caches

Type 'make help' for this help. Type 'make boxes' to build al boxes.

# Boxes created with Packer

## CentOS-7 base box

The base box is a minimal image created from an ISO image installer
with Packer and Kickstart. The following software is installed:

- Latest system updates
- VirtualBox Guest Additions
- Vagrant user and insecure key for vagrant provisioning
- Local packages and customizations (specified in the `scripts` directory)

Root password is `vagrant`.

The image contains small filesystems `/`, `/home`, `/tmp`, `/var` and `swap`.
Post-provisioning scripts should create or extend filesystems before
installing large software packages. Alternatively, modify the partition
layout in `http/ks.cfg`.

System updates are performed from the Kickstart provisioning process, in order to compile
VirtualBox guest additions against the latest kernel from the from Packer shell
provisioning scripts.

## Ansible box

This image contains a base box with Ansible installed.

An Ansible provisiong run is executed from Packer for configuring the image,
using the Ansible playbook from the Vagrant example Ansible configuration.
This allows development and testing of manifests in the Vagrant box and
packaging the final result with Packer.

## Development box

This image is based on the Ansible box. It contains a Java / Angular / Docker / DC/OS 
development environment, with a number of pulled images.

An Ansible provisioning run is executed from Packer for configuring the image,
using the Ansible code base from the Vagrant development box example configuration.
This allows development and testing of playbooks in the Vagrant box and
packaging the final result with packer.
The resulting box is suited for offline use (behind the corporate firewall).

## Puppet box

This image is a based on the base box. The following software is installed:
- Puppet Open Source for masterless configuration
- R10K code manager
- Hiera EYaml for encrypting sensitive data

A Puppet provisiong run is executed from Packer for configuring the image,
using the Puppet code base from the Vagrant example Puppet configuration.
This allows development and testing of manifests in the Vagrant box and
packaging the final result with Packer.

## Oracle 12c database

Pre-packaged box with Oracle 12c Enterprise Edition database server.

### External dependencies

As a prerequisite, download the file `linuxx64_12201_database.zip` to 
the directory`oracle12c/stage`.

## Weblogic 12c

Pre-packaged Weblogic server with an admin server and two managed hosts.
The domain configuration can be adjusted from the WLST scripts.
The following software is installed:
- Java JDK8
- Weblogic 12c AdminServer
- A domain with name 'mydomain'
- Standalone managed servers 'server1' and 'server2'
- Systemd services definitions for nodemanager, adminserver, server1, server2
- Apache Maven
- Apache Maven Weblogic plugin

### External dependencies

As a prerequisite, download and add the following binaries to the directory `weblogic12c/stage`

- `jdk-8u192-linux-x64.rpm`
- `apache-maven-3.5.4-bin.tar.gz`
- `fmw_12.2.1.2.0_wls_quick.jar`

### Weblogic Maven plugin

To test the weblogic-maven plugin as user oracle:

    mvn help:describe -DgroupId=com.oracle.weblogic -DartifactId=weblogic-maven-plugin -Dversion=12.2.1-2-0

Configure Maven to install artifacts to a repository manager, or simply
copy the contents of the .m2 directory to your own local repository. 

See https://docs.oracle.com/middleware/1221/wls/WLPRG/maven.htm#WLPRG585 for using Maven with Weblogic.

# Vagrant examples

The directory `vagrant` contains example Vagrant configurations
for running the Packer generated boxes with Vagrant.

## Centos7 base box

The directory `vagrant/centos7-basebox` contains a Vagranfile for running the Centos7 base box.

## Centos7 Ansible box

The directory `vagrant/centos7-ansible` contains a Vagranfile for provisioning boxes with Ansible.

## Centos7 Development box

The directory `vagrant/centos7-devbox` contains a Vagranfile for provisioning development environments.

The following playbooks are available:
- `devbox`: Java / Angular / Docker development environment and tools
- `minidcos`: Runs minidcos on Docker
- `oracle`: Loads Oracle docker images for legacy development. See [README.md](vagrant/centos7-devbox/files/README.md) for external dependencies.

## Centos7 Oracle 12c box

The directory `vagrant/centos7-oracle12c` contains a Vagranfile for running the Oracle 12c database box.

## Centos7 Weblogic 12c box

The directory `vagrant/centos7-weblogic12c` contains a Vagranfile for running the Weblogic 12c box.

## Centos7 Puppet box

The directory `vagrant/centos7-puppet` contains a Vagranfile for provisioning boxes with Puppet.

The following roles are available:
- `default`: simple server configuration baseline
- `development`: installs PDK and misc tools
