# About

For quick provisioning of dev boxes, we pre-package a basebox with
Oracle 12cR2 RDBMS.  The following software is installed:
- Prerequisite packages, kernel parameters, limits and volume resizing
- Oracle database software (EE)
- A database instance with SID 'db1'
- Init script for automatic startup

After installation, Enterprise Manager Database Express can be
accessed at https://localhost:5500/em.
System and sys passwords are 'Welcome01'.
The listener can be accessed at localhost port 1521.

Example of how to run SQL scripts:

   [oracle@vagrant ~]$ sysdba < /vagrant/sql/db_create.sql 

# External dependencies

Download and add the following binaries:

- oracle12c/linuxx64_12201_database.zip

# References

Oracle database installation guide:
- https://docs.oracle.com/database/122/LADBI/toc.htm

Summarized guides from internet:
- https://oracle-base.com/articles/12c/oracle-db-12cr2-installation-on-oracle-linux-6-and-7
- https://oracle-base.com/articles/linux/automating-database-startup-and-shutdown-on-linux#oracle-12c-update
- https://oracle-base.com/articles/linux/configuring-huge-pages-for-oracle-on-linux-64#disabling-transparent-hugepages