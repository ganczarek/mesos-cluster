This repository contains Ansible playbook that sets up Mesos cluster on Vagrant virtual machines. Most of the configuration comes from [Mesosphere Advanced Course](https://open.mesosphere.com/advanced-course/).

# Vagrant
Use Vagrant version `1.8.6+` because of [Vagrant authentication failure in v1.8.5](https://github.com/mitchellh/vagrant/issues/7610).

# Ansible
Vagrant Ansible provisioner is used, therefore install Ansible on your Vagrant host. For example, on Arch Linux run:

    yaourt -S ansible

For more information refer to [Vagrant Ansible provisioner documentation](https://www.vagrantup.com/docs/provisioning/ansible.html).

# Mesos UI
Mesos UI is at [http://192.168.33.10:5050/#/](http://192.168.33.10:5050/#/). If you see pop-ups about connection issues, map `node1` to VM IP address in your host's `/etc/hosts`.

    sudo echo "192.168.33.10 node1" >> /etc/hosts
    
# Marathon REST API
Full documentation of Marathon REST API can be found [here](http://mesosphere.github.io/marathon/docs/rest-api.html). 
Couple useful requests:

* Metrics of running apps

        GET http://node1:8080/metrics

* Installed apps info
 
        GET http://node1:8080/v2/apps[/{app_name}]

* Kill the app

        DELETE http://node1:8080/v2/apps/{app_name}
      
# Mesos-DNS
[Mesos-DNS](https://mesosphere.github.io/mesos-dns/docs/) is built and deployed with Marathon, when master machine is provisioned.
Created `mesos-dns` app is constrained to run on `node1`, so that it's able to find mesos-dns binaries. 

If you want to use `mesos-dns` on your Vagrant host, add IP address of master machine running Mesos-DNS to your /etc/resolv.conf.

      echo "nameserver 192.168.33.10" >> /etc/resolv.conf

Afterwards, you can discover running Mesos tasks. For example, in order to get 'mesos-dns' IP address execute

      dig mesos-dns.marathon.mesos

The hostname follows the pattern `task.framework.domain`. In the above example, `mesos-dns` is the application id
managed by the `marathon` framework and the domain `mesos` comes from Mesos-DNS config file (`/home/vagrant/config.json`).
See [Service Naming documentation](https://mesosphere.github.io/mesos-dns/docs/naming.html) for more details.

You can also use [Mesos DNS REST API](https://mesosphere.github.io/mesos-dns/docs/http.html) for service discovery.

# Chronos
Similarly to Mesos-DNS, Marathon manages [Chronos](https://mesos.github.io/chronos/). Chronos UI is at [http://192.168.33.10:4400/](http://192.168.33.10:4400/). 