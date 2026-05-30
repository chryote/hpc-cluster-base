# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    # Use official Debian 12 Cloud Image (qcow)
    config.vm.box = "debian/bookworm64"

    # 1. Slurm master node
    config.vm.define "master" do |master|
        master.vm.hostname = "master"
        master.vm.network "private_network", ip: "192.168.56.10"
        master.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus = 2
            vb.name = "slurm-master"
        end
    end

    # 2. Slurm worker nodes (loop)
    (1..2).each do |i|
        config.vm.define "worker#{i}" do |worker|
            worker.vm.hostname = "worker#{i}"
            worker.vm.network "private_network", ip: "192.168.56.1#{i}"
            worker.vm.provider "virtualbox" do |vb|
                vb.memory = 1024
                vb.cpus = 2
                vb.name = "slurm-worker#{i}"
            end
        end
    end

    # 3. Ceph storage node (secondary raw storage disk)
    config.vm.define "storage" do |storage|
        storage.vm.hostname = "storage"
        storage.vm.network "private_network", ip: "192.168.56.20"
        storage.vm.provider "virtualbox" do |vb|
            vb.memory = 4096
            vb.cpus = 4
            vb.name = "ceph-storage"
            
            disk_file = './ceph-osd-disk.vdi'
            unless File.exist?(disk_file)
                vb.customize ["createmedium", "disk", "--filename", disk_file, "--size", 20480] #20GB
            end
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--device", 0, "--type", "hdd", "--medium", disk_file]
        end
    end
end
