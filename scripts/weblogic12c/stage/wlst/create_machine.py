#!/usr/bin/python
import sys

name=sys.argv[1]

connect()
edit()
startEdit()

cd('/')
cmo.createUnixMachine(name)

cd('/Machines/' + name + '/NodeManager/' + name)
cmo.setNMType('Plain')
cmo.setListenAddress('localhost')
cmo.setListenPort(5556)
cmo.setDebugEnabled(false)

# Add admin server to machine
cd('/Servers/AdminServer')
cmo.setMachine(getMBean('/Machines/' + name))

activate()
disconnect()
exit()
