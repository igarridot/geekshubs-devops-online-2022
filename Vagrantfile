# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
    vb.linked_clone = true
    vb.name = "geekshub-bootcamp"

    # Customize the amount of memory on the VM:
    vb.memory = 1024 * 4
    vb.cpus = 2
  end

  config.vm.provision "shell", run: "up", inline: <<-SHELL
    apt-get update
  SHELL

  config.vm.provision "microk8s", type: "shell", run: "never", path: "./scripts/microk8s.sh"

  config.vm.provision "docker", type: "shell", run: "never", path: "./scripts/docker.sh"

end
