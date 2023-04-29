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

#Get the alleles of every participant at select SNPs

ml PLINK/2.00-alpha2.3-x86_64-20200914-dev

genoindir=("/scratch/ahc87874/Replication/genoCSA")
outdir=("/scratch/ahc87874/Replication/alleles")
mkdir -p $outdir
i=("13")
#13:rs67393898 11:rs72880701 11:rs1817457 11:rs149996902 9:140508031_A_G/9:rs34249205 3:rs62255849 
#11:rs174583 FADS2

plink2 \
--bgen $genoindir/chr"$i".bgen ref-first \
--sample $genoindir/chr"$i".sample \
--snp rs67393898 \
--export A \
--out "$outdir"/chr"$i"

#--snps rs72880701, rs1817457, rs149996902 \
