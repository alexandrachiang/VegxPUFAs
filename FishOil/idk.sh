#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEMFishOil1
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=168:00:00
#SBATCH --mem=25GB
#SBATCH --output=GEMFishOil1.%j.out
#SBATCH --error=GEMFishOil1.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

cd /scratch/ahc87874/Fall2022

ml GEM/1.5.1-foss-2022a

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/FishOil/pheno")
outdir=("/scratch/ahc87874/FishOil/GEMphase1")
mkdir -p $outdir

phenotypes=("w3FA")

exposures=("Fish_oil_baseline")

chroms=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" 
"15" "16" "17" "18" "19" "20" "21" "22")

for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

for i in ${chroms[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/GEMphenoFishOilphase1.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age AgeSex \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--output-style "full" \
--out $outdir/$j/"$j"x"$e"-chr"$i"

done
done
done
