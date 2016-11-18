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
  SCRIPT

  # start Marathon
  config.vm.provision "shell", inline: <<-SCRIPT
    service marathon start
  SCRIPT

  # build mesos-dns
  config.vm.provision "shell", inline: <<-SCRIPT
    rpm -qa | grep -qw golang || yum --assumeyes install golang
    rpm -qa | grep -qw git || yum --assumeyes install git
    rpm -qa | grep -qw bind-utils || yum --assumeyes install bind-utils

    echo "Building mesos-dns. It will take a while..."
    mkdir /home/vagrant/go
    export GOPATH=/home/vagrant/go
    export PATH=$PATH:$GOPATH/bin
    go get github.com/tools/godep
    go get github.com/mesosphere/mesos-dns
    cd $GOPATH/src/github.com/mesosphere/mesos-dns
    godep go build .

    # start mesos-dns with Marathon
    curl -X POST -H "Content-Type: application/json; charset=utf-8" http://0.0.0.0:8080/v2/apps -d @/vagrant/mesos-dns/marathon-create-app-request.json

    echo "nameserver 192.168.33.10" >> /etc/resolv.conf

  SCRIPT

end