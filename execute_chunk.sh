#!/bin/bash
TARGET_FILE="/mnt/slurm_shared/data/synthetic_1GB.fastq"
TOTAL_SIZE=$(stat -c%s "$TARGET_FILE")

CHUNK_SIZE=$(( TOTAL_SIZE / SLURM_NTASKS ))
START_BYTE=$(( SLURM_PROCID * CHUNK_SIZE ))

LOG_OUT="/mnt/slurm_shared/parser_task_${SLURM_PROCID}.log"
LOG_ERR="/mnt/slurm_shared/parser_error_${SLURM_PROCID}.log"

if [ "$SLURM_PROCID" -eq 0 ]; then
    /usr/bin/dd if="$TARGET_FILE" bs=128k count=$(( CHUNK_SIZE / 131072 )) 2>"/mnt/slurm_shared/dd_worker_0.log" | \
        /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
else
    # Worker 2: Seeks forward, drops the broken partial line fragment using sed,
    # then processes the remaining data dynamically in perfect sync!
    /usr/bin/dd if="$TARGET_FILE" bs=128k skip="$START_BYTE" iflag=skip_bytes count=$((CHUNK_SIZE / 131072)) 2>"/mnt/slurm_shared/dd_worker_1.log" | \
        /usr/bin/sed '1d' | \
        /mnt/slurm_shared/fastq_parser > "$LOG_OUT" 2> "$LOG_ERR"
fi