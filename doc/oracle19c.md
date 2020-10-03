# About

For quick provisioning of dev boxes, we pre-package a basebox with
Oracle 19c RDBMS.  The following software is installed:
- Prerequisite packages, kernel parameters, limits and volume resizing
- Oracle database software (EE)
- Systemd script for automatic startup
- Database ORCLCBD with container ORCLPDB1

After installation, Enterprise Manager Database Express can be
accessed at https://localhost:5500/em (user 'SYSTEM', password 'Welcome01',
leave container name empty). 

The listener can be accessed at localhost port 1521.

# References

Oracle database installation guide:
- https://oracle-base.com/articles/19c/oracle-db-19c-installation-on-oracle-linux-8
