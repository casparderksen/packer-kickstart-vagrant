#!/usr/bin/python
import sys

fileStoreName='MyFileStore'
targetName='server1'
jmsServerName='MyJmsServer'
jmsModuleName='MyJmsModule'
subDeploymentName='MySubDeployment'
connectionFactoryName='MyConnectionFactory'
inputQueueName='MyInputQueue'
outputQueueName='MyOutputQueue'

connect()
edit()
startEdit()

cd('/')

# Create file based persistent store in default location (<server>/data/store)
fileStore = cmo.createFileStore(fileStoreName)
target = getMBean("/Servers/" + targetName)
fileStore.addTarget(target)
print('Created persistence store ' + fileStoreName)

# Create JMS Server with persistence store
jmsServer = cmo.createJMSServer(jmsServerName);
jmsServer.setPersistentStore(fileStore);
jmsServer.addTarget(target);
print('Created JMS Server ' + jmsServerName)

# Create JMS module targeted to cluster
jmsModule = cmo.createJMSSystemResource(jmsModuleName)
jmsModule.addTarget(target)
print('Created JMS Module ' + jmsModuleName)

# Create sub-deployment targeted to JMS server
subDeployment = jmsModule.createSubDeployment(subDeploymentName)
subDeployment.addTarget(jmsServer)
print('Created SubDeployment ' + subDeploymentName)

# Create ConnectionFactory
jmsResource = jmsModule.getJMSResource();
connectionFactory = jmsResource.createConnectionFactory(connectionFactoryName);
connectionFactory.setJNDIName('jms/' + connectionFactoryName);
connectionFactory.setSubDeploymentName(subDeploymentName);
# TODO XA
print('Created ConnectionFactory ' + connectionFactoryName)
 
# Create input queue
inputQueue = jmsResource.createQueue(inputQueueName);
inputQueue.setJNDIName('jms/' + inputQueueName);
inputQueue.setSubDeploymentName(subDeploymentName);
print('Created Queue ' + inputQueueName)

# Create output queue
outputQueue = jmsResource.createQueue(outputQueueName);
outputQueue.setJNDIName('jms/' + outputQueueName);
outputQueue.setSubDeploymentName(subDeploymentName);
print('Created Queue ' + outputQueueName)

activate()
disconnect()
exit()
