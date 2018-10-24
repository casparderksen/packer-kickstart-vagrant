#!/usr/bin/python
import sys

adminUser=sys.argv[1]
adminPassword=sys.argv[2]
adminUrl=sys.argv[3]

connect(adminUser, adminPassword, adminUrl)

storeUserConfig()

disconnect()
exit()
