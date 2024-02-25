#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=GetAlleles
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=144:00:00
#SBATCH --mem=30000
#SBATCH --output=GetAlleles.%j.out
#SBATCH --error=GetAlleles.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

#Get the alleles of every participant at select SNPs

ml PLINK/2.00a4-GCC-11.2.0

genoindir=("/scratch/ahc87874/Fall2022/geno")
outdir=("/scratch/ahc87874/Fall2022/alleles")
mkdir -p $outdir
i=("2")
#rs4873543	8:52231394_G/A
#rs80103778	2:85067224_G/C
#rs4873543	8:52231394_G/A
#rs6985833	8:52486885_T/G

plink2 \
--bgen $genoindir/chr"$i".bgen ref-first \
--sample $genoindir/chr"$i".sample \
--snp rs80103778 \
--export A \
--out "$outdir"/chr"$i"SNP_Comb

#--snps rs72880701, rs1817457, rs149996902 \
