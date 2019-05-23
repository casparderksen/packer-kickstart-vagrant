# Dependencies

## Oracle 12c Database

Required file for Oracle database:

    docker-oracle/oradb-12201-ee.tgz

Download the Oracle Database 12.2.0.1 Enterprise Edition installer from Oracle.
Then build an Oracle container image as described in [https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance](https://github.com/oracle/docker-images/tree/master/OracleDatabase/SingleInstance). 
Finally, save the docker image to file. Steps:

1. Clone the Oracle docker-images repo: `git clone https://github.com/oracle/docker-images`
2. Place `linuxx64_12201_database.zip` in `docker-images/OracleDatabase/SingleInstance/dockerfiles/12.2.0.1`.
3. Go to `dockerfiles` and run `buildDockerImage.sh -v 12.2.0.1 -e`
4. Save the image to file: `docker save oracle/database:12.2.0.1-ee | gzip - > oradb-12201-ee.tgz`

## Oracle Weblogic

Required file for Weblogic:

    docker-weblogic/weblogic-12213-dev.tgz
    
Download the Weblogic image from the Oracle Container Registry and save it to file as follows:

1. Login to the Oracle Container Registry: `docker login container-registry.oracle.com`
2. Pull the image: `docker pull container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev`
3. Re-tag the image: `docker tag container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev oracle/weblogic:12.2.1.3-dev`
4. Save the image to file: `docker save oracle/weblogic:12.2.1.3-dev | gzip - > weblogic-12213-dev.tgz`

## Oracle Instantclient

Download the following files from [https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html](https://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html).

    instantclient/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm
    instantclient/oracle-instantclient12.2-jdbc-12.2.0.1.0-1.x86_64.rpm
    instantclient/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm

# Warning: Oracle licensing

Check your Oracle license! A developer license only allows deployment on a
physical development PC.  In general, Oracle does not allow soft partitioning
and may require a license for the entire cluster on which an instance is deployed.