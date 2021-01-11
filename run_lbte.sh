#!/bin/bash

#SBATCH -J PtS2-25-iso_cas
#SBATCH -p defq
#SBATCH -N 1
#SBATCH --constraint=LargeMem
#SBATCH -n 8

echo "$(date)" >> ~/spiedie-log
echo "JOB BEGIN: $SLURM_JOB_NAME, $SLURM_JOB_ID, $SLURM_SUBMIT_DIR" >> ~/spiedie-log
echo "Partition = $SLURM_JOB_PARTITION, N = $SLURM_JOB_NUM_NODES, n = $SLURM_NTASKS, CPUS/NODE = $SLURM_CPUS_ON_NODE, n per N = $SLURM_TASKS_PER_NODE, node names = $SLURM_JOB_NODELIST" >> ~/spiedie-log
echo "" >> ~/spiedie-log


export OMP_NUM_THREADS=8

phono3py --dim="3 3 1" --mesh="25 25 1" -c "POSCAR-unitcell" --lbte --isotope --bmfp=10000 > kappa_LBTE_25_iso_cas_10000

echo "$(date)" >> ~/spiedie-log
echo "JOB END: $SLURM_JOB_NAME, $SLURM_JOB_ID, $SLURM_SUBMIT_DIR" >> ~/spiedie-log
echo "" >> ~/spiedie-log
