#! /bin/bash -l

#SBATCH -A a2010002
#SBATCH -p core
#SBATCH -t 1:00:00
#SBATCH -J fastqc
#SBATCH -e .err
#SBATCH -o .out
#SBATCH --mail-user maya.brandi@scilifelab.se
#SBATCH --mail-type=ALL

module load fastqc

fastqc 2_120420_AD0VFTACXX_112_index4_1.Q25.fastq -o fastqc
