#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=CombineGEM
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=6:00:00
#SBATCH --mem=90GB
#SBATCH --output=CombineGEM.%j.out
#SBATCH --error=CombineGEM.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.3.1-foss-2022a
R CMD BATCH CombineGEM.R
