# -*- mode: ruby -*-
# vi: set ft=ruby :

$nodes = [
    {name: 'node1', ip: '192.168.33.10', role: 'master', cores: 2, memory: 4096},
    {name: 'node2', ip: '192.168.33.11', role: 'slave', cores: 1, memory: 2048},
    {name: 'node3', ip: '192.168.33.12', role: 'slave', cores: 1, memory: 2048},
    {name: 'node4', ip: '192.168.33.13', role: 'slave', cores: 1, memory: 2048}
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

    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/cluster.yml"
      ansible.host_vars = {
                                "node1" => $nodes[0],
                                "node2" => $nodes[1],
                                "node3" => $nodes[2],
                                "node4" => $nodes[3],
      }
      ansible.groups = {
        "nodes" => ["node1", "node2", "node3", "node4"],
        "master" => ["node1"],
        "slave" => ["node2", "node3", "node4"],
      }
      # Disable default limit to connect to all the machines
      ansible.limit = "all"
    end

  end
end