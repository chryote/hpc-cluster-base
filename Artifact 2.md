[Real Memory Mistmatch]

1. on master /etc/slurm/slurm.conf
NodeName=worker1 NodeAddr=192.168.56.11 CPUs=2 RealMemory=900 State=UNKNOWN
NodeName=worker2 NodeAddr=192.168.56.12 CPUs=2 RealMemory=900 State=UNKNOWN

2. on workers

```/usr/sbin/slurmd -C```
RealMemory=960 

3. Edit slurm.conf
NodeName=worker1 NodeAddr=192.168.56.11 CPUs=2 RealMemory=960 State=UNKNOWN
NodeName=worker2 NodeAddr=192.168.56.12 CPUs=2 RealMemory=960 State=UNKNOWN