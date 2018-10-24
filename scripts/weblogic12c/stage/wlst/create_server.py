#!/usr/bin/python
import sys

name=sys.argv[1]
port=int(sys.argv[2])

connect()
edit()
startEdit()

cd('/')
cmo.createServer(name)

cd('/Servers/' + name)
cmo.setListenAddress('')
cmo.setListenPort(port)

activate()
disconnect()
exit()
