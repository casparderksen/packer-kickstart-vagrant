# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos7-devbox"

    # Create a private network
    config.vm.network "private_network", ip: "192.168.33.10"

    # Host port mapped to one DC/OS master port
    config.vm.network :forwarded_port, guest: 8888, host: 8888

    # Oracle Net Listener port
    config.vm.network :forwarded_port, guest: 1521, host: 1521

  # VirtualBox provider configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = "CentOS 7"
    vb.memory = "10240"
    vb.cpus = 2
  end

  # Perform Ansible provisioning
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "devbox.yml"
    ansible.config_file = "ansible.cfg"
    ansible.provisioning_path = "/vagrant/ansible"
  end

end
