#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=GEMVegphase1
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=168:00:00
#SBATCH --mem=50GB
#SBATCH --output=GEMVegphase1.%j.out
#SBATCH --error=GEMVegphase1.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd /scratch/ahc87874/Fall2022

ml GEM/1.5.1-foss-2022a

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/GEMtest")
mkdir -p $outdir

phenotypes=("w3FA")

exposures=("Vegetarian")

for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr22.bgen \
--sample $genodir/chr22.sample \
--pheno-file $phenodir/GEMphenoVegphase1.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age AgeSex \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--output-style "full" \
--out $outdir/$j/"$j"x"$e"-chr22

done
done
