# Minimal Multi-Node Slurm & CephFS Hybrid Cluster Sandbox

This repository contains a fully automated, infrastructure-as-code blueprint to spin up a 4-node High-Performance Computing (HPC) batch-scheduling and distributed parallel storage sandbox. It is specifically optimized to build local architectures for streaming big-data analysis (e.g., 50 GB FASTQ genomics pipelines) on resource-constrained host machines.

## Cluster Topology & Network Map

All nodes run minimal **Debian 12 (Bookworm)** setups over an isolated VirtualBox private host-only network.

| Hostname | Role | Virtual IP | Assigned Resources | Key Components |
| --- | --- | --- | --- | --- |
| **master** | Slurm Workload Controller 

 | <br>`192.168.56.10` 

 | 2 vCPUs, 2GB RAM 

 | <br>`slurmctld`, `munge`, Ansible Engine 

 |
| **worker1** | Compute Engine Node 

 | <br>`192.168.56.11` 

 | 2 vCPUs, 2GB RAM 

 | <br>`slurmd`, `munge`, Docker Daemon 

 |
| **worker2** | Compute Engine Node 

 | <br>`192.168.56.12` 

 | 2 vCPUs, 2GB RAM 

 | <br>`slurmd`, `munge`, Docker Daemon 

 |
| **storage** | Distributed Storage Pool 

 | <br>`192.168.56.20` 

 | 2 vCPUs, 3GB RAM 

 | <br>`cephadm` (MON/MGR/OSD), 20GB raw volume 

 |

* Shared Parallel Filesystem Target: `/mnt/slurm_shared` (Mounted natively via CephFS on Master & Workers).



---

## Prerequisites (Windows 11 Home Environment)

Because the host execution environment is Windows 11 Home edition, traditional QEMU/KVM (`libvirt`) engines are substituted natively with **VirtualBox**.

1. Install **VirtualBox** (Ensure Virtualization extensions are toggled active in host BIOS).
2. Install **Vagrant**.
3. 
**Hypervisor Collision Precaution:** Disable Windows *Core Isolation / Memory Integrity* or heavy features that attempt to aggressively claim nested virtualization locks exclusively.

## If ansible yet baked to vagrant
sudo apt update
sudo apt install -y pipx python3-venv
pipx install --include-deps ansible
pipx ensurepath
source ~/.bashrc

---

## Deployment Workflow

### 1. Fire up the Hardware Lifecycle

Open a PowerShell terminal **as Administrator** (required for Vagrant to bind structural cross-node host-only networking layers seamlessly) and execute:

```bash
vagrant up

```

This commands prompts Vagrant to download the official Debian cloud image base, construct the 4 internal virtual instances, and create a raw unformatted secondary storage volume medium (`ceph-osd-disk.vdi`) attached to the storage box.

### 2. Isolate and Extract Local Security Keys

Vagrant establishes unique, secure identity validation tokens for every VM upon instantiation. Because Windows folders lack native Unix security permission mapping bits (`0777`), you must store them inside the Master VM's local filesystem to bypass OpenSSH protection boundaries.

Run `vagrant ssh master` to step into the orchestrator dashboard. Then execute the extraction scripts:

```bash
# Prepare a protected local directory path
mkdir -p /home/vagrant/.ssh/cluster_keys

sudo chown -R vagrant:vagrant /home/vagrant/.ssh

# Extract the individual node private authentication tokens natively
cp /vagrant/.vagrant/machines/master/virtualbox/private_key /home/vagrant/.ssh/cluster_keys/master_key
cp /vagrant/.vagrant/machines/worker1/virtualbox/private_key /home/vagrant/.ssh/cluster_keys/worker1_key
cp /vagrant/.vagrant/machines/worker2/virtualbox/private_key /home/vagrant/.ssh/cluster_keys/worker2_key
cp /vagrant/.vagrant/machines/storage/virtualbox/private_key /home/vagrant/.ssh/cluster_keys/storage_key

# Enforce strict Unix cryptographic permission standards
chmod 700 /home/vagrant/.ssh/cluster_keys
chmod 600 /home/vagrant/.ssh/cluster_keys/*

```

### 3. Run Pre-Flight Validation Pings

Ensure your Ansible local path definitions inside `/vagrant/inventory.ini` point explicitly to the native `/home/vagrant/.ssh/cluster_keys/` directories. Test connectivity via:

```bash
cd /vagrant
ansible -i inventory.ini all -m ping

```

Ensure all four items respond with a clean green verification message before proceeding.

### 4. Execute the Main Configuration Pipeline

```bash
export ANSIBLE_HOST_KEY_CHECKING=False

export ANSIBLE_CONFIG=/vagrant/ansible.cfg
ansible-playbook -i inventory.ini playbook.yml

```

```USE submit_local_job_parallel.sh```

---

## Engineering Operations Rules & Sandbox "War Stories"

When updating or maintaining this architecture, remember these structural edge cases that were solved during the cluster's initial setup:

### 1. Naming Collisions in Ansible Lists

Never share exact strings between individual host declarations and group classifications in `inventory.ini`. For example, naming both an explicit server and a parent collection `master` causes Ansible variable translation maps to break. Use `[slurm_master]` for the group wrapper instead.

### 2. Containerized Binary Path Resolution via `cephadm`

Modern implementations of `cephadm` isolate the daemon command infrastructure cleanly inside a container runtime instead of scattering binaries into the standard host OS `/usr/bin` paths. Orchestration scripts targeting Ceph pool actions must be wrapped safely using the shell syntax engine hook:

```yaml
# Correct pattern:
command: cephadm shell -- ceph orch apply osd --all-available-devices

```

### 3. Sandbox Storage Constraints (Overriding Default Replication Alerts)

Because this testing environment deploys a single dedicated storage engine node containing 1 active OSD disk, Ceph will natively throw a `HEALTH_WARN` alerting that `OSD count 1 < osd_pool_default_size 2`. To clear this warning in a sandbox environment and return the cluster health map to `HEALTH_OK`, invoke this global parameter patch:

```bash
sudo cephadm shell -- ceph config set global osd_pool_default_size 1

```

---

## Verification & Status Health Tracking

To instantly check if the full distributed scheduler stack and data storage node systems are talking to each other natively, use these quick verification commands from the `master` node:

* 
**Check Slurm Cluster Nodes:** `sinfo` 

* 
**Check ansible ping-pong:** `ansible -i inventory.ini all -m ping`

* 
**Check storage node remotely:** `ansible -i inventory.ini storage -m command -a "cephadm shell -- ceph status" --become`

* 
**Verify Ceph Array Storage Integrity:** `sudo cephadm shell -- ceph status` 

* 
**/mnt/slurm_shared sanitation checking pass** `echo "Cluster Storage Verification Token: Pass" | sudo tee /mnt/slurm_shared/test_cluster.txt`

then `ansible -i inventory.ini slurm_cluster -m command -a "cat /mnt/slurm_shared/test_cluster.txt"`

it should output 
`master | CHANGED | rc=0 >>`
`Cluster Storage Verification Token: Pass`

`worker1 | CHANGED | rc=0 >>`
`Cluster Storage Verification Token: Pass`

`worker2 | CHANGED | rc=0 >>`
`Cluster Storage Verification Token: Pass`

Do change ownership!
```ansible -i inventory.ini slurm_cluster -m file -a "path=/mnt/slurm_shared owner=vagrant group=vagrant recurse=yes" --become```