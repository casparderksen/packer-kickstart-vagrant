#!/bin/sh -eux

# Install Java JDK 1.8
rpm -iv ${STAGING_DIR}/jdk-8u192-linux-x64.rpm

cat << --- > /etc/profile.d/java.sh
export JAVA_HOME=/usr/java/latest
export PATH=\$PATH:\$JAVA_HOME/bin
---
