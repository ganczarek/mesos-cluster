# -*- mode: ruby -*-
# vi: set ft=ruby :

$nodes = [
    {name: 'node1', ip: '192.168.33.10', role: 'master', cores: 1, memory: 2048},
    {name: 'node2', ip: '192.168.33.11', role: 'slave', cores: 1, memory: 1024},
    {name: 'node3', ip: '192.168.33.12', role: 'slave', cores: 1, memory: 1024},
    {name: 'node4', ip: '192.168.33.13', role: 'slave', cores: 1, memory: 1024}
]

Vagrant.configure("2") do |config|
  $nodes.each do |node_spec|
    create_node(config, node_spec)
  end
end

def create_node(config, node_spec)
  name = node_spec[:name]
  role = node_spec[:role]
  ip = node_spec[:ip]
  cores = node_spec[:cores]
  memory = node_spec[:memory]

  config.vm.define name do |node|
    node.vm.box = "bento/centos-7.1"
    node.vm.network :private_network, :ip => ip
    node.vm.hostname = name

    node.vm.provider :virtualbox do |vb|
      vb.memory = memory
      vb.cpus = cores
    end

    case role
      when 'master'
        setup_master(node, node_spec)
      when 'slave'
        setup_slave(node, node_spec)
      else
        raise "Unknown role #{role}"
    end

    update_hosts_file(node, $nodes)
    # delete localhost mappings for cluster nodes
    node.vm.provision :shell, inline: <<-SCRIPT
      sed -i '/127.0.0.1\s*node/d' /etc/hosts
    SCRIPT

  end
end

def setup_master(config, node_spec)
  config.vm.provision :shell, inline: $install_mesos
  config.vm.provision :shell, inline: $install_marathon
  config.vm.provision :shell, inline: $install_and_start_zookeeper
  config.vm.provision :shell, inline: "service mesos-master start"
  config.vm.provision :shell, inline: "service marathon start"
  config.vm.provision :shell, inline: $install_mesos_dns
  config.vm.provision :shell, inline: $install_chronos
end

def setup_slave(config, node_spec)
  config.vm.provision :shell, inline: $install_mesos
  config.vm.provision :shell, inline: "service mesos-slave start"
end

$install_mesos = <<-SCRIPT
    rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    rpm -qa | grep -qw mesos || yum --assumeyes install mesos
SCRIPT

$install_marathon = <<-SCRIPT
    rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
    rpm -qa | grep -qw marathon || yum --assumeyes install marathon
SCRIPT

$install_and_start_zookeeper = <<-SCRIPT
    rpm -Uvh http://archive.cloudera.com/cdh4/one-click-install/redhat/6/x86_64/cloudera-cdh-4-0.x86_64.rpm
    rpm -qa | grep -qw zookeeper || yum --assumeyes install zookeeper
    rpm -qa | grep -qw zookeeper-server || yum --assumeyes install zookeeper-server
    sudo -u zookeeper zookeeper-server-initialize --myid=1
    sudo service zookeeper-server start
SCRIPT

$install_chronos = <<-SCRIPT
    rpm -qa | grep -qw chronos || yum --assumeyes install chronos
    curl -X POST -H "Content-Type: application/json; charset=utf-8" http://0.0.0.0:8080/v2/apps -d @/vagrant/chronos/marathon-create-app-request.json
SCRIPT

$install_mesos_dns = <<-SCRIPT
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

    grep "nameserver 192.168.33.10" /etc/resolv.conf
    if [ ! $? -eq 0 ]; then
      echo "nameserver 192.168.33.10" >> /etc/resolv.conf
    fi
SCRIPT

def update_hosts_file(config, nodes)
  nodes.each do |node_spec|
    name = node_spec[:name]
    ip = node_spec[:ip]
    config.vm.provision :shell, inline: <<-SCRIPT
      # add mapping, if doesn't exist already
      grep "#{ip} #{name}" /etc/hosts
      if [ ! $? -eq 0 ]; then
        echo "#{ip} #{name}" >> /etc/hosts
      fi
    SCRIPT
  end
end