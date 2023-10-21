#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=writenmr
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=20:00:00
#SBATCH --mem=122GB
#SBATCH --output=writenmr.%j.out
#SBATCH --error=writenmr.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.1.3-foss-2020b
R CMD BATCH writenmr.R
