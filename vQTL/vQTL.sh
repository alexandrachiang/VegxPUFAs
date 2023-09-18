#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=vQTL
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=70:00:00
#SBATCH --mem=500000
#SBATCH --output=vQTL.%j.out
#SBATCH --error=vQTL.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-2

cd /scratch/ahc87874/Fall2022/vQTL

i=$SLURM_ARRAY_TASK_ID
phenotypes=("w3FA_NMR" "w3FA_NMR_TFAP" "w6FA_NMR" "w6FA_NMR_TFAP" "w6_w3_ratio_NMR" 
"DHA_NMR" "DHA_NMR_TFAP" "LA_NMR" "LA_NMR_TFAP" "PUFA_NMR" "PUFA_NMR_TFAP" "MUFA_NMR" 
"MUFA_NMR_TFAP" "PUFA_MUFA_ratio_NMR")
genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno/INT")

for j in ${phenotypes[@]}
  do

./osca-0.46.1 \
--vqtl \
--bfile $genodir/chr"$i".bgen \
--pheno $phenodir/"$j"INT.txt \
--vqtl-mtd 0 \
--task-num 1000 \
--task-id 1 \
--thread-num 10 \
--out vQTL_Bartlett_chr"$i"

done
