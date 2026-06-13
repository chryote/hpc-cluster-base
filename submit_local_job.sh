#!/bin/bash
#SBATCH --job-name=fastq_local_bench
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --output=/tmp/cluster_run_%j.log
#SBATCH --error=/tmp/cluster_error_%j.log

# Force the automated task runner to inherit the current directory structure
#SBATCH --chdir=/tmp

set -x
set -o pipefail

TARGET_FILE="/mnt/slurm_shared/data/synthetic_1GB.fastq"
TOTAL_SIZE=$(stat -c%s "$TARGET_FILE" 2>/dev/null)

NUM_TASKS=${SLURM_NTASKS:-2}
PROC_ID=${SLURM_PROCID:-0}
NODE_NAME=${SLURM_NODENAME:-localhost}

echo "=== [JOB START] Node: ${NODE_NAME} | Task ID: ${PROC_ID} ==="

CHUNK_SIZE=$((TOTAL_SIZE / NUM_TASKS))
START_BYTE=$((PROC_ID * CHUNK_SIZE))

LOG_OUT="/mnt/slurm_shared/parser_task_${PROC_ID}.log"
LOG_ERR="/mnt/slurm_shared/parser_error_${PROC_ID}.log"

if [ "$PROC_ID" -eq 0 ]; then
    /usr/bin/dd if="$TARGET_FILE" bs=128k count=$((CHUNK_SIZE / 131072)) 2>"/mnt/slurm_shared/dd_worker_0.log" | \
        /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
else
    /usr/bin/dd if="$TARGET_FILE" bs=128k skip="$START_BYTE" iflag=skip_bytes count=$((CHUNK_SIZE / 131072)) 2>"/mnt/slurm_shared/dd_worker_1.log" | \
        /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
fi

echo "Pipeline Run Complete on Node: ${NODE_NAME} | Status: $?"