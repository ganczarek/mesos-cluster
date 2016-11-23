#!/usr/bin/env bash

echo "Building mesos-dns. It will take a while..."
mkdir /home/vagrant/go
export GOPATH=/home/vagrant/go
export PATH=$PATH:$GOPATH/bin
go get github.com/tools/godep
go get github.com/mesosphere/mesos-dns
cd $GOPATH/src/github.com/mesosphere/mesos-dns
godep go build .