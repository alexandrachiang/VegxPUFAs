#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=vQTLLeveneMed
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=70:00:00
#SBATCH --mem=500000
#SBATCH --output=vQTLLeveneMed.%j.out
#SBATCH --error=vQTLLeveneMed.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

cd /home/ahc87874/osca/

i=$SLURM_ARRAY_TASK_ID
phenotypes=("w3FA_NMR" "w3FA_NMR_TFAP" "w6FA_NMR" "w6FA_NMR_TFAP" "w6_w3_ratio_NMR"
"DHA_NMR" "DHA_NMR_TFAP" "LA_NMR" "LA_NMR_TFAP" "PUFA_NMR" "PUFA_NMR_TFAP" "MUFA_NMR"
"MUFA_NMR_TFAP" "PUFA_MUFA_ratio_NMR")

genodir=("/scratch/ahc87874/Fall2022/beddup")
phenodir=("/scratch/ahc87874/Fall2022/pheno/INT")
outdir=("/scratch/ahc87874/Fall2022/vQTL/LeveneMed")
mkdir -p outdir

for j in ${phenotypes[@]}
  do

./osca-0.46.1 \
--vqtl \
--bfile $genodir/chr"$i" \
--pheno $phenodir/"$j"INT.txt \
--covar $phenodir/covarsINT.txt \
--qcovar $phenodir/qcovarsINT.txt \
--vqtl-mtd 2 \
--thread-num 20 \
--out $outdir/vQTL_LeveneMed_chr"$i"_"$j"

done
