#!/usr/bin/python
import os, sys

adminUser=sys.argv[1]
adminPassword=sys.argv[2]
domainHome=sys.argv[3]

selectTemplate("Basic WebLogic Server Domain", "12.2.1.2.0")
loadTemplates()

# Create admin user
cd('/Security/base_domain/User/' + adminUser)
cmo.setPassword(adminPassword)

# Create admin server
cd('/Server/AdminServer')
cmo.setName('AdminServer')
cmo.setListenPort(7001)
cmo.setListenAddress('')

# Enable SSL on admin server
create('AdminServer','SSL')
cd('/Servers/AdminServer/SSL/AdminServer')
cmo.setEnabled(true)
cmo.setListenPort(7002)

# Write domain
writeDomain(domainHome)
closeTemplate()
exit()
