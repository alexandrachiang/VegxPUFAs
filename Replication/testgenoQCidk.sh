#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=TestQC
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=144:00:00
#SBATCH --mem=300000
#SBATCH --output=TestQC.%j.out
#SBATCH --error=TestQC.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

#Get the alleles of every participant at select SNPs

ml PLINK/2.00-alpha2.3-x86_64-20210920-dev

genoindir=("/scratch/ahc87874/Replication/geno")
genoindir=("/scratch/ahc87874/Fall2022/bgen_v1.2_UKBsource")
outdir=("/scratch/ahc87874/Replication/testQC")
mkdir -p $outdir
i=("11")
#13:rs67393898 11:rs72880701 11:rs1817457 11:rs149996902 9:140508031_A_G/9:rs34249205 3:rs62255849 
#11:rs174583 FADS2

plink2 \
--bgen $genoindir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genoindir/ukb_imp_v3.sample \
--extract $mfiscoredir/ukb_mfi_chr"$i"_v3_0.5.txt \
--mind 0.05 \
--geno 0.02 \
--hwe 1e-06 \
--maf 0.01 \
--autosome \
--maj-ref \
--max-alleles 2 \
--keep /scratch/ahc87874/Replication/phenoQC_CSA.txt \
--snps rs72880701, rs1817457, rs149996902 \
--export A \
--out "$outdir"/chr"$i"

#--snp rs67393898
#--snps rs72880701, rs1817457, rs149996902 \
#--snp 9:140508031_A_G
#--snp rs62255849
