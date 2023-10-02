#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=vQTLBartlett
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=70:00:00
#SBATCH --mem=500000
#SBATCH --output=vQTLBartlett.%j.out
#SBATCH --error=vQTLBartlett.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

cd /home/ahc87874/osca/

i=$SLURM_ARRAY_TASK_ID
phenotypes=("w3FA_NMR")

genodir=("/scratch/ahc87874/Fall2022/beddup")
phenodir=("/scratch/ahc87874/Fall2022/pheno/INT")
outdir=("/scratch/ahc87874/Fall2022/vQTL/Bartlett")
mkdir -p outdir

for j in ${phenotypes[@]}
  do

./osca-0.46.1 \
--vqtl \
--bfile $genodir/chr"$i" \
--pheno $phenodir/"$j"INT.txt \
--covar $phenodir/covarsINT2.txt \
--qcovar $phenodir/qcovarsINT2.txt \
--vqtl-mtd 0 \
--thread-num 20 \
--out $outdir/vQTL_Bartlett_chr"$i"_"$j"_covars

done
