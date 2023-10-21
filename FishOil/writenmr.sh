#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=writenmr
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH --mem=130GB
#SBATCH --output=writenmr.%j.out
#SBATCH --error=writenmr.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd $SLURM_SUBMIT_DIR

module load R/4.3.1-foss-2022a
R CMD BATCH writenmr.R
