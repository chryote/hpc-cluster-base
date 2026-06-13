[Checking tool per worker]

1. Worker 1

vagrant@worker1:~$ cd /mnt/slurm_shared/
vagrant@worker1:/mnt/slurm_shared$ export PROC_ID=0
export NODE_NAME="worker1"
export TARGET_FILE="/mnt/slurm_shared/data/synthetic_1GB.fastq"
vagrant@worker1:/mnt/slurm_shared$ TOTAL_SIZE=$(stat -c%s "$TARGET_FILE")
CHUNK_SIZE=$((TOTAL_SIZE / 2))

echo "Manually executing Worker 1 data pipe..."
dd if="$TARGET_FILE" bs=128k count=$((CHUNK_SIZE / 131072)) 2>/dev/null | \
    ./fastq_parser > /mnt/slurm_shared/manual_result_worker_0.txt

echo "Exit Code: $?"
Manually executing Worker 1 data pipe...
Exit Code: 0
vagrant@worker1:/mnt/slurm_shared$ ls
data  fastq_parser  generate_synthetic_file.sh  manual_result_worker_0.txt  submit_local_job.sh
vagrant@worker1:/mnt/slurm_shared$ cat manual_result_worker_0.txt
Node  Processing Results:
Total Read Bases: 231813413 | GC Count: 118093625

2. Worker 2

vagrant@worker2:~$ cd /mnt/slurm_shared/
vagrant@worker2:/mnt/slurm_shared$ export PROC_ID=1
export NODE_NAME="worker2"
export TARGET_FILE="/mnt/slurm_shared/data/synthetic_1GB.fastq"
vagrant@worker2:/mnt/slurm_shared$ TOTAL_SIZE=$(stat -c%s "$TARGET_FILE")
CHUNK_SIZE=$((TOTAL_SIZE / 2))
START_BYTE=$((PROC_ID * CHUNK_SIZE))

BLOCK_SIZE=$((1024 * 1024)) # 1MB block pages
SKIP_BLOCKS=$((START_BYTE / BLOCK_SIZE))
COUNT_BLOCKS=$((CHUNK_SIZE / BLOCK_SIZE))

echo "Manually executing Worker 2 data pipe..."
dd if="$TARGET_FILE" bs=$BLOCK_SIZE skip=$SKIP_BLOCKS count=$COUNT_BLOCKS 2>/dev/null | \
    ./fastq_parser > /mnt/slurm_shared/manual_result_worker_1.txt

echo "Exit Code: $?"
Manually executing Worker 2 data pipe...
Exit Code: 0
vagrant@worker2:/mnt/slurm_shared$ ls
data  fastq_parser  generate_synthetic_file.sh  manual_result_worker_0.txt  manual_result_worker_1.txt  submit_local_job.sh
vagrant@worker2:/mnt/slurm_shared$ cat manual_result_worker_1.txt
Node  Processing Results:
Total Read Bases: 0 | GC Count: 0
vagrant@worker2:/mnt/slurm_shared$


```bash 
vagrant@master:/vagrant$ ansible -i inventory.ini slurm_cluster -m command -a "chmod 777 /mnt/slurm_shared" --become
```

1. Another Fix Bypass the PAM Contraction Layer
slurm.conf
```bash
ProctrackType=proctrack/pgid
TaskPlugin=task/none
```
