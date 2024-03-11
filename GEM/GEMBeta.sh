#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEMBeta
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=168:00:00
#SBATCH --mem=25GB
#SBATCH --output=GEMBeta.%j.out
#SBATCH --error=GEMBeta.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=8

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml GEM/1.5.1-foss-2022a

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/GEMBetaVeg")
mkdir -p $outdir

phenotypes=("w3FA" "w3FA_TFAP" "DHA")
#phenotypes=("PUFA")

exposures=("Vegetarian")

for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/GEMphenoVegVeg.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age AgeSex \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--thread 16 \
--output-style "full" \
--out $outdir/$j/"$j"x"$e"-chr"$i"

done
done
