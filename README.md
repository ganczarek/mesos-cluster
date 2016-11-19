This repository contains scripts to setup Mesos cluster. Follow [Mesosphere Advance Course](https://open.mesosphere.com/advanced-course/)
for more details. 

# Vagrant
Use Vagrant version `1.8.6+` because of [Vagrant authentication failure in v1.8.5](https://github.com/mitchellh/vagrant/issues/7610).

# VirtualBox
As of `1.8.7`, the Vagrant VirtualBox provider doesn't support parallel execution (see [docs for more details](https://www.vagrantup.com/docs/virtualbox/usage.html)).
In order to speed things up, the `parallel_provision.sh` script provisions machines in parallel, but still creates them sequentially.
See creator's [blog post](https://dzone.com/articles/parallel-provisioning-speeding) for more information, but be careful, it makes errors less visible.

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

# Chronos
Similarly to Mesos-DNS, Marathon manages [Chronos](https://mesos.github.io/chronos/). 
See Chronos UI at [http://192.168.33.10:4400/](http://192.168.33.10:4400/). 