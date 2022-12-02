#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GetAlleles
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=GetAlleles.%j.out
#SBATCH --error=GetAlleles.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

genoindir=("/scratch/ahc87874/Fall2022/bgen_v1.2_UKBsource") geno
outdir=("/scratch/ahc87874/Fall2022/alleles")
mkdir -p $outdir
id=(rs)

plink2 \
--bgen $genoindir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genoindir/ukb_imp_v3.sample \

--snp 
#--snps
--export A \
--out "$outdir"/"$id"
