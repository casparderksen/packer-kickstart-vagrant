# Contents

- [About](#about)
- [Prequisites](#prequisites)
- [Makefile for Packer builds](#makefile-for-packer-builds)
- [Boxes created with Packer](#boxes-created-with-packer)
  - [CentOS 8 base box](#centos-8-base-box)
  - [Ansible box](#ansible-box)
  - [Development box](#development-box)
  - [Oracle 19c database](#oracle-19c-database)
- [Vagrant examples](#vagrant-examples)
  - [CentOS 8 base box](#centos-8-base-box)
  - [CentOS 8 Ansible box](#centos-8-ansible-box)
  - [CentOS 8 Development box](#centos-8-development-box)
  - [CentOS 8 Oracle 19c box](#centos-8-oracle-19c-box)
- [References](#references)

# About

This project builds CentOS boxes with Packer and Kickstart for use with Vagrant.
Packer templates are provided for creating a minimal base box, and other boxes
based on this base box. By reusing base boxes instead of provisioning each box from scratch, 
build time is significantly reduced (similar to layered Docker image builds).

An interesting box to build is a development environment that is provisioned with Ansible.
The resulting box is suited for offline use (behind the corporate firewall).

See the `centos7` branch for Puppet, Weblogic 12c and Oracle 12c boxes (development is discontinued by me).

# Prequisites

Download the following files to the `iso` directory:

- [`CentOS-8.2.2004-x86_64-minimal.iso`](http://isoredirect.centos.org/centos/8.2.2004/isos/x86_64/CentOS-8.2.2004-x86_64-minimal.iso)
- [`VBoxGuestAdditions_6.1.26.iso`](https://download.virtualbox.org/virtualbox/6.1.26/VBoxGuestAdditions_6.1.26.iso)

When using different versions, adapt the file names and SHA256 checksums in `templates/centos8-basebox.json` accordingly.

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

Type `make help` for this help. Type 

    $ make boxes
    
to build all boxes.

# Boxes created with Packer

## CentOS 8 base box

The base box is a minimal image created from an ISO image installer
with Packer and Kickstart. See also [Kickstart tjps](doc/kickstart.md). 

The following software is installed:
- Latest system updates
- VirtualBox Guest Additions
- Vagrant user and insecure key for vagrant provisioning
- Local packages and customizations (specified in the `scripts` directory)

Password for root and vagrant users is `vagrant`. 

The image contains small filesystems `/`, `/home`, `/tmp`, `/var` and `swap`.
Post-provisioning scripts should create or extend filesystems before
installing large software packages (see [LVM tips](doc/lvm.md). Alternatively, modify the partition
layout in `http/centos8-basebox.ks`.

System updates are performed from the Kickstart provisioning process, in order to compile
VirtualBox guest additions against the latest kernel from the from Packer shell
provisioning scripts.

## Ansible box

This image contains a base box with Ansible installed.

An Ansible provisiong run is executed from Packer for configuring the image,
using the Ansible playbook from the Vagrant example Ansible configuration.
This allows development and testing of manifests in the Vagrant box and
packaging the final result with Packer.

Run a playbook from the command line as as follows:

    $ cd /vagrant/ansible
    $ ansible-playbook playbook.yml
    
See the [development box](#development-box) for a more elaborate Ansible example.

## Development box

This image is based on the Ansible box. It contains a Java / Angular / Python / Docker / Minikube
development environment.

An Ansible provisioning run is executed from Packer for configuring the image and tooling
using the Ansible code base from the Vagrant development box example configuration.
This allows development and testing of playbooks in the Vagrant box and
packaging the final result with packer.

### External dependencies

See [README.md](vagrant/centos8-devbox/README.md) for providing external dependencies of the development box.

## Oracle 19c database

Pre-packaged box with Oracle 19c Enterprise Edition database server. 
See [Oracle tips](doc/oracle19c.md) for details.

### External dependencies

Go to 
[Oracle 19c database donwloads (OTN)](https://www.oracle.com/database/technologies/oracle19c-linux-downloads.html)
and download the file `oracle-database-ee-19c-1.0-1.x86_64.rpm` from to the directory`oracle19c/stage`.

# Vagrant examples

The directory `vagrant` contains example Vagrant configurations
for running the Packer generated boxes with Vagrant.

## CentOS 8 base box

The directory `vagrant/centos8-basebox` contains a Vagranfile for running the CentOS 8 base box.

## CentOS 8 Ansible box

The directory `vagrant/centos8-ansible` contains a Vagranfile for provisioning boxes with Ansible.

## CentOS 8 Development box

The directory `vagrant/centos8-devbox` contains a Vagranfile for provisioning development environments.

The following example playbooks are available:
- `devbox.yml`: Java / Angular / Python / Docker development environment and misc tools
- `docker.yml`: install Docker and donwload images
- `docker-oracle.yml`: loads Oracle docker images for Oracle RDBMS development.
- `gnome.yml`: configure graphical environment
- `local.yml`: customize certificates, network access and tooling
- `minikube.yml`: runs Minikube Kubernetes cluster on Docker 
- `nginx.yml`: configure Nginx

## CentOS 8 Oracle 19c box

The directory `vagrant/centos8-oracle19c` contains a Vagrantfile for running the Oracle 19c database box.

# References

- [CentOS 8 cloud build](https://github.com/CentOS/sig-cloud-instance-build/blob/master/vagrant/centos8.ks)
- [Oracle Database 19c Installation On Oracle Linux 8 (OL8)](https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8)
