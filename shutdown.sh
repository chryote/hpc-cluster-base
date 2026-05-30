# 1. Shut down worker1
ssh -i /home/vagrant/.ssh/cluster_keys/worker1_key vagrant@192.168.56.11 "sudo shutdown -h now"

# 2. Shut down worker2
ssh -i /home/vagrant/.ssh/cluster_keys/worker2_key vagrant@192.168.56.12 "sudo shutdown -h now"

# 3. Shut down the Ceph storage node
ssh -i /home/vagrant/.ssh/cluster_keys/storage_key vagrant@192.168.56.20 "sudo shutdown -h now"

# 4. Finally, shut down the master node itself
sudo shutdown -h now
