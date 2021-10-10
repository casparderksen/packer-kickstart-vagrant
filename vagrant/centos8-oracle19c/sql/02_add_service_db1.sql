BEGIN
  DBMS_SERVICE.create_service('db1','db1');
  DBMS_SERVICE.start_service('db1');
END;