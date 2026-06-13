[Bugs and more mismatch]

vagrant@master:/vagrant$ sudo journalctl -u slurmctld -n 50 --no-pager
Jun 13 06:46:14 master slurmctld[21285]: slurmctld: Terminate signal (SIGINT or SIGTERM) received
Jun 13 06:46:14 master systemd[1]: Stopping slurmctld.service - Slurm controller daemon...
Jun 13 06:46:14 master slurmctld[21285]: slurmctld: Saving all slurm state
Jun 13 06:46:14 master systemd[1]: slurmctld.service: Deactivated successfully.
Jun 13 06:46:14 master systemd[1]: Stopped slurmctld.service - Slurm controller daemon.
Jun 13 06:46:14 master systemd[1]: slurmctld.service: Consumed 12.295s CPU time.
-- Boot 144435e6021d495fa8d6c384eee8e66c --
Jun 13 06:47:25 master systemd[1]: Started slurmctld.service - Slurm controller daemon.
Jun 13 06:47:26 master slurmctld[483]: slurmctld: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 06:47:26 master slurmctld[483]: slurmctld: No parameter for mcs plugin, default values set
Jun 13 06:47:26 master slurmctld[483]: slurmctld: mcs: MCSParameters = (null). ondemand set.
Jun 13 06:47:31 master slurmctld[483]: slurmctld: SchedulerParameters=default_queue_depth=100,max_rpc_cnt=0,max_sched_time=2,partition_job_depth=0,sched_max_job_start=0,sched_min_interval=2
Jun 13 06:48:47 master slurmctld[483]: slurmctld: validate_node_specs: Node worker1 unexpectedly rebooted boot_time=1781333310 last response=1781333250
Jun 13 06:50:13 master slurmctld[483]: slurmctld: validate_node_specs: Node worker2 unexpectedly rebooted boot_time=1781333395 last response=1781333250
Jun 13 06:54:02 master slurmctld[483]: slurmctld: update_node: node worker1 state set to IDLE
Jun 13 06:54:02 master slurmctld[483]: slurmctld: update_node: node worker2 state set to IDLE
Jun 13 06:54:03 master slurmctld[483]: slurmctld: Node worker1 now responding
Jun 13 06:54:03 master slurmctld[483]: slurmctld: Node worker2 now responding
Jun 13 06:57:25 master slurmctld[483]: slurmctld: _slurm_rpc_submit_batch_job: JobId=6 InitPrio=4294901754 usec=817
Jun 13 06:57:25 master slurmctld[483]: slurmctld: sched: Allocate JobId=6 NodeList=worker[1-2] #CPUs=4 Partition=debug
Jun 13 06:57:25 master slurmctld[483]: slurmctld: error: slurmd error running JobId=6 on node(s)=worker1: Plugin initialization failed
Jun 13 06:57:25 master slurmctld[483]: slurmctld: drain_nodes: node worker1 state set to DRAIN
Jun 13 06:57:25 master slurmctld[483]: slurmctld: _job_complete: JobId=6 WEXITSTATUS 0
Jun 13 06:57:25 master slurmctld[483]: slurmctld: _job_complete: JobId=6 done
Jun 13 07:08:42 master systemd[1]: Stopping slurmctld.service - Slurm controller daemon...
Jun 13 07:08:42 master slurmctld[483]: slurmctld: Terminate signal (SIGINT or SIGTERM) received
Jun 13 07:08:42 master slurmctld[483]: slurmctld: Saving all slurm state
Jun 13 07:08:42 master systemd[1]: slurmctld.service: Deactivated successfully.
Jun 13 07:08:42 master systemd[1]: Stopped slurmctld.service - Slurm controller daemon.
Jun 13 07:08:42 master systemd[1]: slurmctld.service: Consumed 2.589s CPU time.
Jun 13 07:08:42 master systemd[1]: Started slurmctld.service - Slurm controller daemon.
Jun 13 07:08:42 master slurmctld[1160]: slurmctld: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 07:08:42 master slurmctld[1160]: slurmctld: No parameter for mcs plugin, default values set
Jun 13 07:08:42 master slurmctld[1160]: slurmctld: mcs: MCSParameters = (null). ondemand set.
Jun 13 07:08:46 master slurmctld[1160]: slurmctld: error: Node worker2 appears to have a different slurm.conf than the slurmctld.  This could cause issues with communication and functionality.  Please review both files and make sure they are the same.  If this is expected ignore, and set DebugFlags=NO_CONF_HASH in my slurm.conf.
Jun 13 07:08:46 master slurmctld[1160]: slurmctld: error: Node worker1 appears to have a different slurm.conf than the slurmctld.  This could cause issues with communication and functionality.  Please review both files and make sure they are the same.  If this is expected ignore, and set DebugFlags=NO_CONF_HASH in my slurm.conf.
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: update_node: node worker1 state set to IDLE
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: Invalid node state transition requested for node worker2 from=IDLE to=RESUME
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: _slurm_rpc_update_node for worker[1-2]: Invalid node state specified
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: SchedulerParameters=default_queue_depth=100,max_rpc_cnt=0,max_sched_time=2,partition_job_depth=0,sched_max_job_start=0,sched_min_interval=2
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: error: Node worker1 appears to have a different slurm.conf than the slurmctld.  This could cause issues with communication and functionality.  Please review both files and make sure they are the same.  If this is expected ignore, and set DebugFlags=NO_CONF_HASH in my slurm.conf.
Jun 13 07:08:47 master slurmctld[1160]: slurmctld: Node worker1 now responding
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: _slurm_rpc_submit_batch_job: JobId=7 InitPrio=4294901759 usec=352
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: sched: Allocate JobId=7 NodeList=worker[1-2] #CPUs=4 Partition=debug
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: error: slurmd error running JobId=7 on node(s)=worker1: Plugin initialization failed
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: drain_nodes: node worker1 state set to DRAIN
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: _job_complete: JobId=7 WEXITSTATUS 0
Jun 13 07:09:38 master slurmctld[1160]: slurmctld: _job_complete: JobId=7 done
Jun 13 07:11:40 master slurmctld[1160]: slurmctld: update_node: node worker1 state set to IDLE
Jun 13 07:11:41 master slurmctld[1160]: slurmctld: error: Node worker1 appears to have a different slurm.conf than the slurmctld.  This could cause issues with communication and functionality.  Please review both files and make sure they are the same.  If this is expected ignore, and set DebugFlags=NO_CONF_HASH in my slurm.conf.
Jun 13 07:11:41 master slurmctld[1160]: slurmctld: Node worker1 now responding

1. The Config File Hash Mismatch (The Warning)
```slurmctld: error: Node worker1 appears to have a different slurm.conf than the slurmctld. This could cause issues...```

    When Slurm daemons boot up, the master (slurmctld) and the workers (slurmd) read their local /etc/slurm/slurm.conf files, calculate an internal cryptographic MD5 hash of the file contents, and compare them during network handshakes.

    Because slurm.conf manually updated the RealMemory=960 variable inside the master node's slurm.conf, the master's configuration hash changed. However, worker1 and worker2 are still holding onto the old configuration file in memory or on their local disks. Because the hashes don't match, the master controller flags an error. While it didn't kill the node instantly, it can cause unpredictable job routing drops.

```bash
vagrant@master:/vagrant$ ansible -i inventory.ini workers -m copy -a "src=/etc/slurm/slurm.conf dest=/etc/slurm/slurm.conf" --become

vagrant@master:/vagrant$ ansible -i inventory.ini workers -m systemd -a "name=slurmd state=restarted" --become
```

2. The Core Killer: Plugin initialization failed (The Job Crash)
```bash 
slurmctld: sched: Allocate JobId=7 NodeList=worker[1-2] #CPUs=4 Partition=debug
slurmctld: error: slurmd error running JobId=7 on node(s)=worker1: Plugin initialization failed
slurmctld: drain_nodes: node worker1 state set to DRAIN 
```

    My script didn't fail mid-run. The moment slurmctld told worker1 to spin up its task fork for Job 7, worker1's local agent crashed instantly with Plugin initialization failed. Because the node's task launcher layer choked before it could even execute my bash commands, it couldn't map the standard error file descriptors—which is exactly why my local_job_7.err file was completely missing from the directory!

```slurmctld: error: mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library```

    The slurm.conf file is trying to enforce a cluster-wide Message Passing Interface (MPI) job tracking standard (specifically PMIx or Cray/pmi), but the underlying Debian packages or shared object C-libraries (libpmix) are completely missing from the fresh operating system image on the worker nodes.

    since submit_local_job.sh using standard linux pipes and binaries, I don't need complex MPI orchestration frameworks.

```bash
srun --mpi=none /mnt/slurm_shared/fastq_parser
```

3. CPU Topology Mismatch

vagrant@master:/vagrant$ ansible -i /vagrant/inventory.ini worker1 -m command -a "sudo journalctl -u slurmd -n 20 --no-pager"
[WARNING]: Ansible is being run in a world writable directory (/vagrant), ignoring it as an ansible.cfg source. For more information see https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir
[WARNING]: Host 'worker1' is using the discovered Python interpreter at '/usr/bin/python3.11', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.19/reference_appendices/interpreter_discovery.html for more information.
worker1 | CHANGED | rc=0 >>
Jun 13 07:18:48 worker1 systemd[1]: Stopping slurmd.service - Slurm node daemon...
Jun 13 07:18:48 worker1 systemd[1]: slurmd.service: Deactivated successfully.
Jun 13 07:18:48 worker1 systemd[1]: Stopped slurmd.service - Slurm node daemon.
Jun 13 07:18:48 worker1 systemd[1]: Started slurmd.service - Slurm node daemon.
Jun 13 07:18:48 worker1 slurmd[1234]: slurmd-worker1: error: Node configuration differs from hardware: CPUs=2:2(hw) Boards=1:1(hw) SocketsPerBoard=2:1(hw) CoresPerSocket=1:2(hw) ThreadsPerCore=1:1(hw)
Jun 13 07:18:48 worker1 slurmd[1234]: slurmd-worker1: slurmd version 22.05.8 started
Jun 13 07:18:48 worker1 slurmd[1234]: slurmd-worker1: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 07:18:48 worker1 slurmd[1234]: slurmd-worker1: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 07:18:48 worker1 slurmd[1234]: slurmd-worker1: CPUs=2 Boards=1 Sockets=2 Cores=1 Threads=1 Memory=960 TmpDisk=100219 Uptime=1818 CPUSpecList=(null) FeaturesAvail=(null) FeaturesActive=(null)
Jun 13 07:27:24 worker1 slurmd[1234]: slurmd-worker1: launch task StepId=8.0 request from UID:1000 GID:1000 HOST:192.168.56.10 PORT:54184
Jun 13 07:29:27 worker1 systemd[1]: Stopping slurmd.service - Slurm node daemon...
Jun 13 07:29:27 worker1 systemd[1]: slurmd.service: Deactivated successfully.
Jun 13 07:29:27 worker1 systemd[1]: Stopped slurmd.service - Slurm node daemon.
Jun 13 07:29:27 worker1 systemd[1]: Started slurmd.service - Slurm node daemon.
Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: error: Node configuration differs from hardware: CPUs=2:2(hw) Boards=1:1(hw) SocketsPerBoard=2:1(hw) CoresPerSocket=1:2(hw) ThreadsPerCore=1:1(hw)
Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: slurmd version 22.05.8 started
Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: error:  mpi/pmix_v4: init: (null) [0]: mpi_pmix.c:195: pmi/pmix: can not load PMIx library
Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: CPUs=2 Boards=1 Sockets=2 Cores=1 Threads=1 Memory=960 TmpDisk=100219 Uptime=2457 CPUSpecList=(null) FeaturesAvail=(null) FeaturesActive=(null)
Jun 13 07:30:44 worker1 slurmd[34908]: slurmd-worker1: launch task StepId=9.0 request from UID:1000 GID:1000 HOST:192.168.56.10 PORT:33944

```Jun 13 07:29:27 worker1 slurmd[34908]: slurmd-worker1: error: Node configuration differs from hardware: CPUs=2:2(hw) Boards=1:1(hw) SocketsPerBoard=2:1(hw) CoresPerSocket=1:2(hw) ThreadsPerCore=1:1(hw)```

    This is culprit causing the Plugin initialization failed execution crash.
    When a job is sent via srun, Slurm's process tracking and task affinity plugins (task/cgroup or task/affinity) immediately attempt to bind the Go process to physical hardware CPU threads using the layout specified in slurm.conf.

    my slurm.conf explicitly told the cluster that the worker nodes look like this:

        Sockets=2

        Cores=1

    But when VirtualBox booted up the VM with my updated virtio profiles, the Linux kernel registered the hardware layout entirely differently:

        SocketsPerBoard=1 (1 physical CPU socket)

        CoresPerSocket=2 (2 distinct processing cores inside that single socket)

    Because the virtual geometry does not align, the task containment plugin hits an OS boundary violation when it tries to map the process affinity mask across non-existent hardware sockets. The task initialization throws a critical exception, drops the run immediately, and flags the node as corrupt (DRAIN).

Add it on slurm.conf
```bash
NodeName=worker1 NodeAddr=192.168.56.11 CPUs=2 Sockets=1 CoresPerSocket=2 ThreadsPerCore=1 RealMemory=960 State=UNKNOWN
NodeName=worker2 NodeAddr=192.168.56.12 CPUs=2 Sockets=1 CoresPerSocket=2 ThreadsPerCore=1 RealMemory=960 State=UNKNOWN
```

```bash
vagrant@master:/vagrant$ ansible -i inventory.ini workers -m copy -a "src=/etc/slurm/slurm.conf dest=/etc/slurm/slurm.conf" --become

vagrant@master:/vagrant$ ansible -i inventory.ini workers -m systemd -a "name=slurmd state=restarted" --become

vagrant@master:/vagrant$ sudo systemctl restart slurmctld


```