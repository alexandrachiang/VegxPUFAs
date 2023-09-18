#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=vQTL
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=70:00:00
#SBATCH --mem=300000
#SBATCH --output=vQTL.%j.out
#SBATCH --error=vQTL.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022
