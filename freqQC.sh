#!/bin/bash
#SBATCH --partition=highmem_p
#SBATCH --job-name=freqQC
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=160:00:00
#SBATCH --mem=180000
#SBATCH --output=freqQC.%j.out
#SBATCH --error=freqQC.%j.err
#SBATCH --array=1-22
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL

i=$SLURM_ARRAY_TASK_ID

cd /scratch/ahc87874/Fall2022

ml PLINK/2.00-alpha2.3-x86_64-20210920-dev

indir=("/scratch/ahc87874/Fall2022/genoQC")
outdir=("/scratch/ahc87874/Fall2022/genoQC/freq")
mkdir -p $outdir

plink2 \
--bgen $indir/chr"$i".bgen ref-first \
--sample $indir/chr"$i".sample \
--freq \
--out "$outdir"/chr"$i"
