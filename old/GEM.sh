#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=GEMVeg
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=144:00:00
#SBATCH --mem=50GB
#SBATCH --output=GEMVeg.%j.out
#SBATCH --error=GEMVeg.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml GEM/1.4.3-intel-2020b

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/GEM")
mkdir -p $outdir

#phenotypes=("w3Fa" "w3FA_TFAP" "w6FA" "w6FA_TFAP" "w6_w3_ratio" 
#"DHA" "DHA_TFAP" "LA" "LA_TFAP" "PUFA" "PUFA_TFAP" "MUFA" 
#"MUFA_TFAP" "PUFA_MUFA_ratio")

phenotypes=("w3FA_NMR" "w3FA_NMR_TFAP" "w6FA_NMR" "w6FA_NMR_TFAP" "w6_w3_ratio_NMR" 
"DHA_NMR" "DHA_NMR_TFAP" "LA_NMR" "LA_NMR_TFAP" "PUFA_NMR" "PUFA_NMR_TFAP" "MUFA_NMR" 
"MUFA_NMR_TFAP" "PUFA_MUFA_ratio_NMR")

exposures=("SSRV")

for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/GEMphenowKeep.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age Townsend \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--output-style "full"
--out $outdir/$j/"$j"x"$e"-chr"$i"

done
done
