import sys

R1=sys.argv[1]
R2=sys.argv[2]
name=sys.argv[3]
f=open(name+".sh",'w')
print >>f, """#! /bin/bash -l

#SBATCH -A a2010002
#SBATCH -p core
#SBATCH -t 45:00:00
#SBATCH -J osthyvel
#SBATCH -e osthyvel_"""+ name + """.err
#SBATCH -o osthyvel_"""+ name + """.out
#SBATCH --mail-user maya.brandi@scilifelab.se
#SBATCH --mail-type=ALL

python /bubo/home/h24/mayabr/glob/scilifelab/utilities/bin_reads_by_quality.py""" + " " + R1 + " " + R2

