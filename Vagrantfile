# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/centos-7.1"

  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "node1"


  config.vm.provision "shell", inline: <<-SCRIPT
    # delete localhost mapping
    sudo sed -i '/127.0.0.1\s*node1/d' /etc/hosts
    # add mapping, if doesn't exist already
    grep "192.168.33.10 node1" /etc/hosts
    if [ ! $? -eq 0 ]; then
        echo "192.168.33.10 node1" >> /etc/hosts
    fi
  SCRIPT

  config.vm.provision "shell", inline: <<-SCRIPT
    rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    yum --assumeyes install mesos marathon
  SCRIPT

end