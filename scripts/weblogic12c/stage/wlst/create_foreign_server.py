#!/usr/bin/python
import sys

targetName='server1'
jmsModuleName='MyJmsModule'
foreignServerName='MyForeignServer'
initialContectFactory='weblogic.jndi.WLInitialContextFactory'
connectionURL='t3://192.168.33.11:7011'
jndiPropertiesPrincipal='weblogic'
jndiPropertiesCredential='welcome01'
foreignDestinationName='MyForeignDestination'
foreignConnectionFactoryName='MyForeignConnectionFactory'
connectionFactoryName='MyConnectionFactory'
inputQueueName='MyInputQueue'

connect()
edit()
startEdit()

cd('/')

# Create JMS module targeted to managed servers
jmsModule = cmo.createJMSSystemResource(jmsModuleName)
# TODO all managed servers as array
target = getMBean("/Servers/" + targetName)
jmsModule.addTarget(target)
print('Created JMS Module ' + jmsModuleName)

# Create foreign server
foreignServer = jmsModule.createForeignServer(foreignServerName)
foreignServer.setDefaultTargetingEnabled(true)
foreignServer.setInitialContextFactory(initialContextFactory)
foreignServer.setConnectionURL(connectionURL)
foreignServer.JNDIPropertiesCredential(jndiPropertiesCredential)
foreignServer.createJNDIProperty('java.naming.security.principal').setValue(jndiPropertiesPrincipal)
foreignServer.createJNDIProperty('xa').setValue('true')
print('Created ForeignServer ' + foreignServerName)

# Create ForeignDestination
foreignDestination = foreignServer.createForeignDestination(foreignDestinationName)
foreignDestination.setLocalJNDIName('jms/' + inputQueueName)
foreignDestination.setRemoteJNDIName('jms/' + inputQueueName)
print('Created ForeignDestination ' + foreignDestinationName)

# Create ForeignConnectionFactory
foreignCF = foreignServer.createForeignConnectionFactory(foreignConnectionFactoryName)
foreignCF.setLocalJNDIName('jms/' + connectionFactoryName)
foreignCF.setRemoteJNDIName('jms/' + connectionFactoryName)
print('Created ForeignConnectionFactory ' + foreignConnectionFactoryName)
 
activate()
disconnect()
exit()
