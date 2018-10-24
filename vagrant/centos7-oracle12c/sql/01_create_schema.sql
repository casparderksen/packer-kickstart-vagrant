SET ECHO OFF
SET VERIFY OFF

DEFINE user = myschema
DEFINE passwd = myschema
DEFINE tbs_data = myschema_data
DEFINE tbs_index = myschema_index
DEFINE tbs_temp = temp
DEFINE datafile  = '/u01/app/oracle/oradata/db1/myschema_data01.dbf'
DEFINE indexfile = '/u01/app/oracle/oradata/db1/myschema_index01.dbf'

-- Create tablespaces
CREATE TABLESPACE &tbs_data DATAFILE '&datafile' SIZE 50M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

CREATE TABLESPACE &tbs_index DATAFILE '&indexfile' SIZE 50M
    EXTENT MANAGEMENT LOCAL AUTOALLOCATE;

-- Create user
CREATE USER &user IDENTIFIED BY &passwd;

ALTER USER &user DEFAULT TABLESPACE &tbs_data
                  QUOTA UNLIMITED ON &tbs_data;

ALTER USER &user TEMPORARY TABLESPACE &tbs_temp;

GRANT CREATE SESSION, CREATE VIEW, ALTER SESSION, CREATE SEQUENCE TO &user;
GRANT CREATE SYNONYM, CREATE DATABASE LINK, RESOURCE TO &user;
