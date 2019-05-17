# Prerequisites

Download the Weblogic Docker image from the Oracle Container Registry and save it to `weblogic-12213-dev.tgz`.

Login to Oracle Container Registry:
    
    $ docker login container-registry.oracle.com

Pull image:

    $ docker pull container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev

Save image:

    $ docker save container-registry.oracle.com/middleware/weblogic:12.2.1.3-dev | gzip - > weblogic-12213-dev.tgz

Load image:

    $ docker load -i weblogic-12213-dev.tgz
    
# References

## Oracle Container Registry

See `https://container-registry.oracle.com/` for the Oracle Container Registry.
See `https://docs.oracle.com/cd/E37670_01/E75728/html/oracle-registry-server.html` for using the Oracle Container Registry.

## Weblogic on Docker

See `https://github.com/oracle/docker-images/tree/master/OracleWebLogic`
