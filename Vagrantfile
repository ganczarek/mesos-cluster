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

  # install Apache Mesos and Marathon
  config.vm.provision "shell", inline: <<-SCRIPT
    rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    rpm -qa | grep -qw mesos || yum --assumeyes install mesos
    rpm -qa | grep -qw marathon || yum --assumeyes install marathon
  SCRIPT

  # install ans start Zookeeper
  config.vm.provision "shell", inline: <<-SCRIPT
    rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
    rpm -qa | grep -qw zookeeper || yum --assumeyes install zookeeper
    rpm -qa | grep -qw zookeeper-server || yum --assumeyes install zookeeper-server
    sudo -u zookeeper zookeeper-server-initialize --myid=1
    sudo service zookeeper-server start
  SCRIPT

  # start Mesos master and salve
  config.vm.provision "shell", inline: <<-SCRIPT
    service mesos-master start
    service mesos-slave start
    netstat -nlp | grep mesos
  SCRIPT

  # start Marathon
  config.vm.provision "shell", inline: <<-SCRIPT
    service marathon start
    ps aux | grep mesosphere.marathon.Main | awk '{print $2}' | head -n 1 | xargs -I{} sh -c 'netstat -nlp | grep {}/java'
  SCRIPT

end