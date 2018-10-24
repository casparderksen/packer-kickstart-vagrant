#!/usr/bin/python
import sys

user=sys.argv[1]
password=sys.argv[2]
description=sys.argv[3]

connect()

atnr=cmo.getSecurityConfiguration().getDefaultRealm().lookupAuthenticationProvider("DefaultAuthenticator")
atnr.createUser(user, password, description)
atnr.addMemberToGroup('Administrators', user)

disconnect()
exit()
