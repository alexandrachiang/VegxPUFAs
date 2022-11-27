#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=CombineGEM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=20:00:00
#SBATCH --mem=40GB
#SBATCH --output=CombineGEM.%j.out
#SBATCH --error=CombineGEM.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.1.3-foss-2020b
R CMD BATCH CombineGEM.R
