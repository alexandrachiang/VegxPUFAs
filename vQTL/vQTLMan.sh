#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=vQTLMan
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=20:00:00
#SBATCH --mem=122GB
#SBATCH --output=vQTLMan.%j.out
#SBATCH --error=vQTLMan.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.3.1-foss-2022a
R CMD BATCH vQTLMan.R
