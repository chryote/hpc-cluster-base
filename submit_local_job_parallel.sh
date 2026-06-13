#!/bin/bash
#SBATCH --job-name=fastq_parallel_bench
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --output=/tmp/cluster_run_%j.log
#SBATCH --error=/tmp/cluster_error_%j.log
#SBATCH --chdir=/mnt/slurm_shared

# We invoke srun on a secondary, clean execution script wrapper!
srun --mpi=none /mnt/slurm_shared/execute_chunk.sh