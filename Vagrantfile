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

    # Provision master nodes first
    masters = $nodes.select{|node| node[:role] == 'master'}
    if node_spec == masters.last
      run_ansible_provisioner(node, masters)
    end

    # Provision slaves, but only when all created
    if node_spec == $nodes.last
      run_ansible_provisioner(node, $nodes)
    end

  end
end

def run_ansible_provisioner(config, node_specs)
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "ansible/cluster.yml"
    ansible.host_vars = Hash[node_specs.map { |node| [node[:name], node] }]
    ansible.groups = {
      "nodes" => node_specs.map { |node| node[:name] },
      "master" => node_specs.select { |node| node[:role] == 'master' }.map { |node| node[:name] },
      "slave" => node_specs.select { |node| node[:role] == 'slave' }.map { |node| node[:name] },
    }
    # Disable default limit to connect to all the machines
    ansible.limit = "all"
  end
end