#!/bin/bash
#SBATCH --job-name=fastq_parallel_bench
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --output=/tmp/cluster_run_%j.log
#SBATCH --error=/tmp/cluster_error_%j.log
#SBATCH --chdir=/tmp

set -x
set -o pipefail

TARGET_FILE="/mnt/slurm_shared/data/synthetic_1GB.fastq"
TOTAL_SIZE=$(stat -c%s "$TARGET_FILE" 2>/dev/null)

# We wrap the conditional execution inside an srun inline loop!
# Slurm will duplicate this tracking block across both hosts simultaneously.
srun --mpi=none bash -c '
    NUM_TASKS=$SLURM_NTASKS
    PROC_ID=$SLURM_PROCID
    NODE_NAME=$SLURM_NODENAME

    CHUNK_SIZE=$(( '$TOTAL_SIZE' / NUM_TASKS ))
    START_BYTE=$(( PROC_ID * CHUNK_SIZE ))

    LOG_OUT="/mnt/slurm_shared/parser_task_${PROC_ID}.log"
    LOG_ERR="/mnt/slurm_shared/parser_error_${PROC_ID}.log"

    if [ "$PROC_ID" -eq 0 ]; then
        /usr/bin/dd if="'$TARGET_FILE'" bs=128k count=$(( CHUNK_SIZE / 131072 )) 2>"/mnt/slurm_shared/dd_worker_0.log" | \
            /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
    else
        /usr/bin/dd if="'$TARGET_FILE'" bs=128k skip="$START_BYTE" iflag=skip_bytes count=$(( CHUNK_SIZE / 131072 )) 2>"/mnt/slurm_shared/dd_worker_1.log" | \
            /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
    fi
'


================== WEAKNESS =========================
when I wrap pipeline script inside srun bash -c '...' using single quotes ('), bash on the master node evaluates and substitutes the mathematical expressions BEFORE sending the command string over the network to the workers.

Because of that premature evaluation, Worker 2 is getting fed completely broken stream indices!

When the master node parsed my script, it evaluated the string and saw:
```START_BYTE=$(( PROC_ID * CHUNK_SIZE ))```

Since the master node doesn't have an active $PROC_ID variable in its own terminal environment, it treats $PROC_ID as 0.
Therefore, it tells BOTH workers to calculate START_BYTE=$(( 0 * CHUNK_SIZE )) = 0.

Then, Worker 2 executes its block:
```/usr/bin/dd if="$TARGET_FILE" bs=128k skip="0" iflag=skip_bytes ...```

But because Worker 2 is using iflag=skip_bytes alongside a non-zero count, forcing it to seek manually over misaligned, duplicated block boundaries causes the bufio.NewReaderSize scanner inside the Go program to lose its formatting synchronization loop (knocking out the 4-line FASTQ cadence). It parses nothing, registers an EOF, and prints 0 | 0.
