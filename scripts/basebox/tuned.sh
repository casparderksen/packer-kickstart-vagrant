#!/bin/sh -eux

# Install system tuning daemon
yum -y install tuned

# Configure virtual guest profile
tuned-adm profile virtual-guest
