#!/bin/bash -eux

# Install local Ansible roles

ansible-galaxy install nginxinc.nginx
ansible-galaxy install geerlingguy.nginx
ansible-galaxy install dev-sec.nginx-hardening
ansible-galaxy install redhatofficial.rhel8_ospp