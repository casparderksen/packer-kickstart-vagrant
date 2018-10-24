#!/usr/bin/python

url='jdbc:oracle:thin:@192.168.33.11:1521:db1'
driverName='oracle.jdbc.xa.client.OracleXADataSource'
user='myschema'
password='myschema'
dsName='MyDS'
dsJNDIName='jdbc/MyDS'

connect()
edit()
startEdit()

cd('/')
cmo.createJDBCSystemResource(dsName)

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName)
cmo.setName(dsName)

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName)
set('JNDINames',jarray.array([String(dsJNDIName)], String))

cd('/JDBCSystemResources/MyDS/JDBCResource/MyDS/JDBCDriverParams/MyDS')
cmo.setUrl(url)
cmo.setDriverName(driverName)
set('Password', password)

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCConnectionPoolParams/' + dsName)
cmo.setTestTableName('SQL ISVALID')

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName)
cmo.createProperty('user')

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDriverParams/' + dsName + '/Properties/' + dsName + '/Properties/user')
cmo.setValue(user)

cd('/JDBCSystemResources/' + dsName + '/JDBCResource/' + dsName + '/JDBCDataSourceParams/' + dsName)
cmo.setGlobalTransactionsProtocol('TwoPhaseCommit')

cd('/SystemResources/' + dsName)
set('Targets',jarray.array([ObjectName('com.bea:Name=server1,Type=Server'), 
                            ObjectName('com.bea:Name=server2,Type=Server')], ObjectName))

print('Created data store ' + dsName)

activate()
disconnect()
exit()
