#!/bin/bash
#SBATCH --job-name=convertpgen         # Job name
#SBATCH --partition=highmem_p             # Partition (queue) name
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=400gb                     # Job memory request
#SBATCH --time=50:00:00               # Time limit hrs:min:sec
#SBATCH --output=convertpgen.%j.out    # Standard output log
#SBATCH --error=convertpgen.%j.err     # Standard error log
#SBATCH --mail-user=ahc87874@uga.edu
#SBATCH --mail-type=ALL
#SBATCH --array=1-22

i=$SLURM_ARRAY_TASK_ID

#Load PLINK
ml PLINK/2.00a4-GCC-11.2.0

#Set genotype directory
genodir=("/scratch/ahc87874/Fall2022/bgen_v1.2_UKBsource")

#Set output directory
outdir=("/scratch/ahc87874/Fall2022/pgen")
mkdir -p $outdir

plink2 \
--bgen $genodir/ukb_imp_chr"$i"_v3.bgen ref-first \
--sample $genodir/ukb_imp_v3.sample \
--make-pgen \
--out $outdir/chr"$i"
