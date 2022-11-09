#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GEM
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=GEM.%j.out
#SBATCH --error=GEM.%j.err
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

phenotypes=("w3FA_NMR") #CHANGE

exposures=("CSRV" "SSRV")


for j in ${phenotypes[@]} 
        do

for e in ${exposures[@]} 
        do

mkdir -p $outdir/$j

echo running "$j" and "$e"

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--pheno-file $phenodir/GEMpheno.csv \
--sampleid-name IID \
--pheno-name $j \
--covar-names Sex Age Townsend \
PC1 PC2 PC3 PC4 PC5 PC6 PC7 PC8 PC9 PC10 \
--robust 1 \
--exposure-names "$e" \
--thread 16 \
--out $outdir/$j/"$j"x"$e"-chr"$i"

done
done

#centers 15 & 19 dont exist, center ?? is all 0, which messes up the results
#variables must be numeric to work

#Age2 Geno_batch \
#Center1 Center2 Center3 Center4 Center5 \
#Center6 Center7 Center8 Center9 Center10 \
#Center11 Center12 Center13 Center14 Center16 \
#Center17 Center18 Center20 Center21 Center22 \
#Center23 Statins BMI Lipid_meds \
