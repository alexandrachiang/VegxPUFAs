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

--snp 
#--snps
--export A
--out $outdir/
