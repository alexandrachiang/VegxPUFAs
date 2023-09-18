#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=vQTL
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --ntasks-per-node=16
#SBATCH --time=70:00:00
#SBATCH --mem=300000G
#SBATCH --output=vQTL.%j.out
#SBATCH --error=vQTL.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-2

i=$SLURM_ARRAY_TASK_ID

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")

cd /scratch/ahc87874/Fall2022/vQTL

osca \
--vqtl \
--bfile $genodir/chr"$i".bgen \
--pheno $phenodir/INTpheno.csv \
--vqtl-mtd 0 \
--task-num 1000 \
--task-id 1 \
--thread-num 10 \
--out vQTL_Bartlett_chr"$i"
