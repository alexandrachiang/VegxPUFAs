#!/bin/bash
#SBATCH --partition=batch
#SBATCH --job-name=Convertbgen
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=70:00:00
#SBATCH --mem=30000
#SBATCH --output=Convertbgen.%j.out
#SBATCH --error=Convertbgen.%j.err
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml GEM/1.4.3-intel-2020b

genodir=("/scratch/ahc87874/Fall2022/geno")
phenodir=("/scratch/ahc87874/Fall2022/pheno")
outdir=("/scratch/ahc87874/Fall2022/bed")
mkdir -p $outdir

GEM \
--bgen $genodir/chr"$i".bgen \
--sample $genodir/chr"$i".sample \
--make-bed \
--thread 16 \
--out $outdir/chr"$i"
