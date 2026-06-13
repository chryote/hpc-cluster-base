# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    # Use official Debian 12 Cloud Image (qcow)
    config.vm.box = "debian/bookworm64"

    # 1. Slurm master node
    config.vm.define "master" do |master|
        master.vm.hostname = "master"
        # TUNED: Added virtio nictype to prevent soft lockups during intense IO compilation loops
        master.vm.network "private_network", ip: "192.168.56.10", nictype: "virtio"
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
            # TUNED: Added virtio nictype to ensure distributed storage streams don't choke ksoftirqd
            worker.vm.network "private_network", ip: "192.168.56.1#{i}", nictype: "virtio"
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
        # TUNED: Added virtio nictype to maximize block device and network synchronization performance
        storage.vm.network "private_network", ip: "192.168.56.20", nictype: "virtio"
        storage.vm.provider "virtualbox" do |vb|
            storage.vm.boot_timeout = 600
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