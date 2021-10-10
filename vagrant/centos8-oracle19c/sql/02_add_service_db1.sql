DEFINE container = ORCLPDB1

-- Select container
ALTER SESSION SET CONTAINER=&container;

BEGIN
  DBMS_SERVICE.create_service('db1','db1');
  DBMS_SERVICE.start_service('db1');
END;
/