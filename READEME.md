This repository contains scripts to setup Mesos cluster. Follow from [Mesosphere Advance Course](https://open.mesosphere.com/advanced-course/) 
for more details. 

# Vagrant
Use version `1.8.6+` due to [Vagrant authentication failure in v1.8.5](https://github.com/mitchellh/vagrant/issues/7610).

# Mesos UI
Map `node1` to VM IP address in your `/etc/hosts`, if you get connection issues when visiting [Mesos UI](http://192.168.33.10:5050/#/).

    sudo echo "192.168.33.10 node1" >> /etc/hosts