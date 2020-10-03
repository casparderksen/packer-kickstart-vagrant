# About

This project provisions CentOS 8 based development environments with Ansible
for running in Vagrant/VirtualBox. The Vagrantfile uses a base box from
[casparderksen/packer-kickstart-vagrant](https://github.com/casparderksen/packer-kickstart-vagrant),
but any Centos 8 image with Ansible pre-installed should work.  See also this
project for pre-packaging a development environment as Vagrant box (ideal when
your corporate processes fail to provide a satisfactory development environment).

The `devbox.yml` playbook installs the following software:
- Docker daemon
- DVC (Data Version Control)
- Apache Maven
- Minikube
- Angular CLI
- OpenJDK 11
- NodeJS / NPM
- Python3
- Misc command line tools (git, jq, httpie, make, ...)

The `local.yml` playbook applies the following configuration (adapt variables to your environment):
- Angular CLI installation
- Docker daemon configured with private registry (for example Nexus3 pull through cache)
- Git client configuration
- Oracle Instantclient with `tnsnames.ora` configuration
- Maven, fully configured `settings.xml` for Nexus3 repository with encrypted password
- Node and NPM configured with Nexus as proxy
- Local CA trust stores for Linux and Java. See [roles/local_certs/files/README.md](roles/local_certs/files/README.md)
  for setting up your certificate chain.
- Configuration for CNTLM and running cntlmd daemon for corporate proxy integration.

The `gnome.yml` playbook installs the following software:
- GNOME desktop

The `minikube.yml` playbook installs the following software:
- Minikube command line tool (`minikube`)
- Kubernetes `kubectl` command line tool
- Minikube cluster on Docker

The `docker-oracle.yml` playbook installs the following software
- Oracle 12c RDBMS Docker image and example project
- Oracle Instantclient (`sqlplus`) and `tnsnames.ora` configuration

# Usage

Clone [casparderksen/packer-kickstart-vagrant](https://github.com/casparderksen/packer-kickstart-vagrant)
and create an Ansible box. Alternatively, adapt the Vagrant file for using another box and installing Ansible.

Start the box, and enter it with SSH:

    $ vagrant up
    $ vagrant ssh
	
Adapt `local.yml` to yourn environment and needs. Then apply the confiuration as follows:

    $ cd /vagrant/ansible
    $ ansible-playbook local.yml
	
You will be prompter for full name, e-mail, user-id and password to configure Git, Maven, and CNTLM.
Your password will be stored encrypted, but do keep the configured box and files private.
Start a new shell to load configured environment and path settings.

When running Vagrant from Windows, the `/vagrant/ansible` folder is
world-writable, causing Ansible to refuse work for security issues.  To fix
this, mount the `ansible` folder with restricted permissions Tip: the generated
Maven settings.xml and settings-security.xml should be portable to your Windows
box.

# Oracle database in Docker

See [Dependencies](#dependencies) for creating Docker images for Oracle.

SSH into the box. To load the Docker image run:

    $ cd /vagrant/ansible
    $ ansible-playbook docker-oracle.yml
	
To start the databse in the background:

    $ cd ~/docker-oracle-example
    $ make run
	
The first run will take a lot of time to create the database in a Docker volume. Type

    $ make logs
	
to follow progress. Wait until the database is ready to use (abort watching the logs with Ctrl-C).
To access the database via `sqlplus`:

	$ sqlplus myschema/myschema@ORCLPDB1

The JDBC URL is `jdbc:oracle:thin:@//localhost:1521/ORCLPDB1` (use a service connection).

Edit the scripts in `docker-oracle-example/docker/setup` to change the configured users.
See `local.yml` for `tnsnames.ora` configuration.

# Minikube in Docker

SSH into the box abd run:

    $ cd /vagrant/ansible
    $ ansible-playbook minikube.yml
    
Wait for the cluster to be ready. Run

    $ sudo kubectl proxy --address='0.0.0.0'

to expose the Kubernets API outside the box. Access the Kubernetes dashboard at
[http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/)

# Dependencies

## CNTLM

Download the CNTLM RPM package from [http://cntlm.sourceforge.net](http://cntlm.sourceforge.net):

    files/cntlm/cntlm-0.92.3-1.x86_64.rpm

## Oracle 19c Database

Required file for Oracle database:

    files/docker-oracle/oradb-193000-ee.tgz

Download the Oracle Database 19.3.0 Enterprise Edition installer from Oracle.
Then build an Oracle container image as described in
[https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance).
Finally, save the docker image to file. Steps:

1. Clone the Oracle docker-images repo: `git clone https://github.com/oracle/docker-images`
2. Place `LINUX.X64_193000_db_home.zip` in `docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0`.
3. Go to `dockerfiles` and run `buildDockerImage.sh -v 19.3.0 -e`
4. Save the image to file: `docker save oracle/database:19.3.0-ee | gzip - > oradb-193000-ee.tgz`

## Oracle Instantclient

Download the following files from [https://www.oracle.com/nl/database/technologies/instant-client/linux-x86-64-downloads.html](https://www.oracle.com/nl/database/technologies/instant-client/linux-x86-64-downloads.html)

    files/instantclient/oracle-instantclient19.8-basic-19.8.0.0.0-1.x86_64.rpm
    files/instantclient/oracle-instantclient19.8-sqlplus-19.8.0.0.0-1.x86_64.rpm

## Warning: Oracle licensing

Check your Oracle license! A developer license only allows deployment on a
physical development PC.  In general, Oracle does not allow soft partitioning
and may require a license for the entire cluster on which an instance is deployed.
