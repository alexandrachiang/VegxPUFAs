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

ml PLINK/2.00-alpha2.3-x86_64-20200914-dev

genoindir=("/scratch/ahc87874/Fall2022/geno")
outdir=("/scratch/ahc87874/Fall2022/alleles")
mkdir -p $outdir
i=("9")
#13:rs67393898 11:rs72880701 11:rs1817457 11:rs149996902 9:140508031_A_G/9:rs34249205 3:rs62255849 

plink2 \
--bgen $genoindir/chr"$i".bgen ref-first \
--sample $genoindir/chr"$i".sample \
--snp 9:140508031_A_G \
--export A \
--out "$outdir"/chr"$i"SNP

#--snps rs72880701, rs1817457, rs149996902 \
#--snps 9:140508031_A_G, 9:140508031_G_G, 9:140508031_A_A
