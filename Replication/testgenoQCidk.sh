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

i=("11")

cd /scratch/ahc87874/Replication

ml PLINK/2.00-alpha2.3-x86_64-20210920-dev

genoindir=("/scratch/ahc87874/Fall2022/bgen_v1.2_UKBsource")
mfiscoredir=("/scratch/ahc87874/Fall2022/mfi/info0.5")
outdir=("/scratch/ahc87874/Replication/testgenoQC")
mkdir -p $outdir

plink2 \
--bgen $genoindir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genoindir/ukb_imp_v3.sample \
--extract $mfiscoredir/ukb_mfi_chr"$i"_v3_0.5.txt \
--max-alleles 2 \
--keep /scratch/ahc87874/Replication/phenoQC_CSA.txt \
--export bgen-1.2 bits=8 \
--out "$outdir"/chr"$i"


#--mind 0.05 \
#--geno 0.02 \
#--hwe 1e-06 \
#--maf 0.01 \
#--autosome \
#--maj-ref \
