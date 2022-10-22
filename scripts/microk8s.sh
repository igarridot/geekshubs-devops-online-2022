#! /bin/bash

echo "Installing microk8s via snap"
sudo snap install microk8s --classic

echo "Checking the status"
sudo microk8s.status --wait-ready

echo "Turning on standard services"
sudo microk8s.enable dns registry

echo "Installing docker daemon"
sudo snap install docker

echo "Adding permissions to the user vagrant"
sudo usermod -a -G microk8s vagrant
sudo chown -f -R vagrant home/vagrant/.kube

echo "Alias kubectl"
sudo snap alias microk8s.kubectl kubectl
