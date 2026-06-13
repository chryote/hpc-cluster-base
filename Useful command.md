1. Resume broken worker
```sudo scontrol update NodeName=worker1 state=RESUME```

2. Slurmd path

```bash
vagrant@worker1:~$ /usr/sbin/slurmd -C
NodeName=worker1 CPUs=2 Boards=1 SocketsPerBoard=1 CoresPerSocket=2 ThreadsPerCore=1 RealMemory=960
UpTime=0-00:12:59
```