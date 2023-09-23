#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=Convertbgen
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --time=70:00:00
#SBATCH --mem=300000
#SBATCH --output=Convertbgen.%j.out
#SBATCH --error=Convertbgen.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml PLINK/2.00a4-GCC-11.2.0

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/bed")
mkdir -p $outdir

plink2 \
--bgen $genodir/chr"$i".bgen ref-first \
--sample $genodir/chr"$i".sample \
--make-bed \
--out $outdir/chr"$i"
