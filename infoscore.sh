#!/bin/bash
#SBATCH --job-name=infoscore       # Job name
#SBATCH --partition=highmem_p             # Partition (queue) name
#SBATCH --ntasks=1                    # Run a single task
#SBATCH --mem=300gb                     # Job Memory
#SBATCH --time=167:00:00               # Time limit hrs:min:sec
#SBATCH --output=infoscore.%j.out      # Standard output log
#SBATCH --error=infoscore.%j.err       # Standard error log
#SBATCH --array=1-22            #Run as array job

i=$SLURM_ARRAY_TASK_ID

#Set working directory
cd /work/kylab/alex/Fall2021Practice/INFOscore

#Load modules & packages
ml PLINK/2.00-alpha2.3-x86_64-20210920-dev

#Chunk steps
step1=false
step2=true

if [ $step1=true ]; then
#-------------------------------------------------------------------------------------------------
#STEP 1: Filter UKB Imputation SNPs by 0.5 quality score

#Set in/out directories
mfidir=("/scratch/ahc87874/Fall2021Practice/UKBpgen/mfi")
outdir=$mfidir/info0.5

mkdir -p $outdir

for i in {1..22}
        do

awk '{if ($8 >= 0.5) print $2}' $mfidir/ukb_mfi_chr"$i"_v3.txt > $outdir/ukb_mfi_chr"$i"_v3_0.5.txt

echo chromosome $i completed

done

fi

#-------------------------------------------------------------------------------------------------
if [ $step2=true ]; then
#STEP 2: Make new genotype files with only INFO >= 0.5

genodir=("/scratch/ahc87874/Fall2021Practice/UKBpgen")
infodir=("/scratch/ahc87874/Fall2021Practice/UKBpgen/mfi/info0.5")
outdir=("/scratch/ahc87874/Fall2021Practice/genotypeQC")

mkdir -p $outdir

plink2 \
--pfile $genodir/chr"$i" \
--extract $infodir/ukb_mfi_chr"$i"_v3_0.5.txt \
--make-pgen \
--out $outdir/chr"$i"

fi



Error: Failed to open /scratch/ahc87874/Fall2021Practice/UKBpgen/chr1.pgen :
Cannot send after transport endpoint shutdown.
Error: /scratch/ahc87874/Fall2021Practice/UKBpgen/chr5.pvar read failure:
Input/output error.
