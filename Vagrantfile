# -*- mode: ruby -*-
# vi: set ft=ruby :

#set no parallel to ensure k8s master should up and running first
ENV['VAGRANT_NO_PARALLEL'] = 'yes'
NodeCount = 1

Vagrant.configure(2) do |config|
  config.vm.provision "shell", path: "vagrant_scripts/bootstrap.sh"
  # Kubernetes Master
  config.vm.define "master" do |node|
    # Image to use in this lab ubuntu/focal64 or ubuntu/bionic64
    node.vm.box               = "ubuntu/bionic64"
    node.vm.box_check_update  = false
    node.vm.hostname          = "master.lab.com"
    node.vm.network "private_network", ip: "10.0.0.80"
    node.vm.provider :virtualbox do |vb|
      vb.name    = "master"
      vb.memory = 2048
      vb.cpus = 2
    end
    node.vm.provider :libvirt do |vb|
      vb.memory  = 2048
      vb.nested  = true
      vb.cpus    = 2
    end
    # Synced Kubernetes Manifest
    config.vm.synced_folder "kubernetes_manifest/", "/deployments",
      owner: "root", group: "root"
    # Execute script
    node.vm.provision "shell", path: "vagrant_scripts/master.sh"
  end


  # Kubernetes Worker Node
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |node|
     # Image to use in this lab ubuntu/focal64 or ubuntu/bionic64
      node.vm.box               = "ubuntu/bionic64"
      node.vm.hostname          = "worker#{i}.lab.com"
      node.vm.network "private_network", ip: "10.0.0.8#{i}"
      node.vm.network "forwarded_port", guest: 31731, host: 8081 # Flask API Access
      node.vm.network "forwarded_port", guest: 31731, host: 8080 # Flask API Access
      node.vm.provider :virtualbox do |v|
        v.name    = "worker#{i}"
        v.memory  = 1024
        v.cpus    = 1
      end
      node.vm.provider :libvirt do |v|
        v.memory  = 1024
        v.nested  = true
        v.cpus    = 1
      end
      # Execute script
      node.vm.provision "shell", path: "vagrant_scripts/worker.sh"
    end
  end
end

