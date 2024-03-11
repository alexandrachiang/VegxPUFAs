#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=TopTen
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=TopTen.%j.out
#SBATCH --error=TopTen.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.3.1-foss-2022a
R CMD BATCH TopTen.R
