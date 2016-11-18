This repository contains scripts to setup Mesos cluster. Follow from [Mesosphere Advance Course](https://open.mesosphere.com/advanced-course/) 
for more details. 

# Vagrant
Use version `1.8.6+` due to [Vagrant authentication failure in v1.8.5](https://github.com/mitchellh/vagrant/issues/7610).

# Mesos UI
Map `node1` to VM IP address in your `/etc/hosts`, if you get connection issues when visiting [Mesos UI](http://192.168.33.10:5050/#/).

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