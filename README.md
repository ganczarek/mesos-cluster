This repository contains Ansible playbook to setup Mesos cluster. Follow [Mesosphere Advance Course](https://open.mesosphere.com/advanced-course/)
for some of the details. 

# Vagrant
Use Vagrant version `1.8.6+` because of [Vagrant authentication failure in v1.8.5](https://github.com/mitchellh/vagrant/issues/7610).

# Ansible
Vagrant uses Ansible playbooks to create cluster nodes. Ansible used on Vagrant host is used, so install it first

    yaourt -S ansible

# Mesos UI
Mesos UI is at [http://192.168.33.10:5050/#/](http://192.168.33.10:5050/#/). If you have connection issues, map `node1` to VM IP address in your `/etc/hosts`.

    sudo echo "192.168.33.10 node1" >> /etc/hosts
    
# Marathon REST API
For full documentation see [Marathon REST API doc](http://mesosphere.github.io/marathon/docs/rest-api.html). 
Below few useful commands:

* Metrics of running apps

        GET http://node1:8080/metrics

* Installed apps info
 
        GET http://node1:8080/v2/apps[/{app_name}]

* Kill the app

        DELETE http://node1:8080/v2/apps/{app_name}
      
# Mesos-DNS
[Mesos-DNS](https://mesosphere.github.io/mesos-dns/docs/) is built and deployed with Marathon, when master machine is provisioned.
Created `mesos-dns` app is constrained to run on node1, so that it's able to find mesos-dns binaries. 
See also [Mesos DNS REST API doc](https://mesosphere.github.io/mesos-dns/docs/http.html).

Add IP address of server running Mesos-DNS to your host's /etc/resolv.conf.

      echo "nameserver 192.168.33.10" >> /etc/resolv.conf

Afterwards, you can discover running Mesos tasks. For example, in order to get 'mesos-dns' IP address execute

      dig mesos-dns.marathon.mesos

The hostname follows the pattern `task.framework.domain`. In the above example, `mesos-dns` is the application id
managed by the `marathon` framework and the domain `mesos` comes from Mesos-DNS config file (`/home/vagrant/config.json`).
See [Service Naming documentation](https://mesosphere.github.io/mesos-dns/docs/naming.html) for more detail.

# Chronos
Similarly to Mesos-DNS, Marathon manages [Chronos](https://mesos.github.io/chronos/). 
See Chronos UI at [http://192.168.33.10:4400/](http://192.168.33.10:4400/). 