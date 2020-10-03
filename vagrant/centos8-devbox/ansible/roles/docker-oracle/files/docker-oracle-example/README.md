# About

This project configures and deploys an Oracle database in a Docker container for personal development environments.

# Prerequisites

First build an Oracle container image as described in [https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance).
For Oracle Database 19.3.0 Enterprise Edition this involves the following steps:

1. Download `LINUX.X64_193000_db_home.zip` from OTN and store it in `dockerfiles/19.3.0`.
2. Go to `dockerfiles` and run `buildDockerImage.sh -v 19.3.0 -e`

After building the container return to this directory and run `make save` to export the image to file.

# Configuration

## Set-up scripts

The scripts in [docker/setup](docker/setup) are executed for initial setup of the database.
Edit [docker/setup/01\_create\_user.sql](docker/setup/01_create_user.sql) to setup a schema.

## Start-up scripts

The scripts in [docker/startup](docker/startup) are ran before starting the database.

## Dockerfile

Edit [docker/Dockerfile](docker/Dockerfile) to modify SID and PDB.

## Persistent volume

In the container, the database is located at `/opt/oracle/oradata`. The `run`
target in [Makefile](Makefile) mounts this directory on a volume `oradata`, in
order to persist the database between runs.

# Building an running the database

Use

    ORACLE_PWD=<password> make run
    
to build and run the database, and set the database password.  The first run
will will create a database in a volume `oradata`. Consequent runs will mount
the previously built database. If `ORACLE_PWD` is unset, the password will
not be changed.

Type `make logs` to view and follow the container log and see when the database is ready.

# Connecting to the database

Connect as user `system` (service):

	jdbc:oracle:thin:@//localhost:1521/ORCLCDB

Connect as user `myschema` (service):

	jdbc:oracle:thin:@//localhost:1521/ORCLPDB1
	
Connect via `sqlplus`:

    $ sqlplus myschema/myschema@ORCLPDB1

# Accessing the container

Lookup the container id with `docker ps`.

    docker exec -it <container-id> bash

# Caution: Oracle licensing

Check your Oracle license! A developer license only allows deployment on a
physical development PC.  In general, Oracle does not allow soft partitioning
and may require a license for the entire cluster on which an instance is deployed.
