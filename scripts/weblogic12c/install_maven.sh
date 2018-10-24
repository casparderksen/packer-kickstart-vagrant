#!/bin/sh -eux

# Install Apache Maven
tar -C /opt -xf ${STAGING_DIR}/apache-maven-3.5.4-bin.tar.gz
MAVEN_HOME=/opt/apache-maven-3.5.4

# Add Maven environment settings to profile.d scripts
cat << --- > /etc/profile.d/maven.sh
MAVEN_HOME=$MAVEN_HOME
export PATH=\$PATH:\$MAVEN_HOME/bin
---

# Configure Maven settings
cat << --- > /etc/mavenrc
M2_HOME=$MAVEN_HOME
MAVEN_OPTS="-Xmx512m"
---
