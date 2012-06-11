#! /bin/bash -l

#SBATCH -A a2010002
#SBATCH -p core
#SBATCH -t 45:00:00
#SBATCH -J osthyvel
#SBATCH -e osthyvel_179.err
#SBATCH -o osthyvel_179.out
#SBATCH --mail-user maya.brandi@scilifelab.se
#SBATCH --mail-type=ALL

python /bubo/home/h24/mayabr/glob/scilifelab/utilities/bin_reads_by_quality.py 5_120420_AD0VFTACXX_179_index18_1.fastq 5_120420_AD0VFTACXX_179_index18_2.fastq
