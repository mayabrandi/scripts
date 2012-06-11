#!/bin/bash -l

name_list=(`echo $1 | tr "," "\n"`)
bedfile=$2

for i in ${name_list[*]};do

## read distribution
echo "#!/bin/bash -l" > ${i}_runRSeQC_rd.sh
echo "#SBATCH -A a2010003" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH -p node" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH -t 50:00:00" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH -e RSeQC_rd_$i.err" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH -o RSeQC_rd_$i.out" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH -J RSeQC_rd_$i" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH --mail-type=ALL" >> ${i}_runRSeQC_rd.sh
echo "#SBATCH --mail-user=maya.brandi@scilifelab.se" >> ${i}_runRSeQC_rd.sh
echo "export PYTHONPATH=/proj/a2010002/nobackup/sw/mf/bioinfo-tools/pipelines/RSeQC-2.0.0/sw/comp/python/2.7_kalkyl/lib/python2.7/site-packages:"'$PYTHONPATH' >> ${i}_runRSeQC_rd.sh
echo "export PATH=/proj/a2010002/nobackup/sw/mf/bioinfo-tools/pipelines/RSeQC-2.0.0/sw/comp/python/2.7_kalkyl/bin:"'$PATH' >> ${i}_runRSeQC_rd.sh
echo "module unload samtools" >> ${i}_runRSeQC_rd.sh
echo "module load samtools/0.1.9" >> ${i}_runRSeQC_rd.sh
echo "read_distribution.py -i tophat_out_$i/accepted_hits_sorted_dupRemoved_$i.bam -r $bedfile" >> ${i}_runRSeQC_rd.sh


## gene body coverage
echo "#!/bin/bash -l" > ${i}_runRSeQC_gbc.sh
echo "#SBATCH -A a2010003" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH -p node" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH -t 15:00:00" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH -e RSeQC_gbc_$i.err" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH -o RSeQC_gbc_$i.out" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH -J RSeQC_gbc_$i" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH --mail-type=ALL" >> ${i}_runRSeQC_gbc.sh
echo "#SBATCH --mail-user=maya.brandi@scilifelab.se" >> ${i}_runRSeQC_gbc.sh
echo "export PYTHONPATH=/proj/a2010002/nobackup/sw/mf/bioinfo-tools/pipelines/RSeQC-2.0.0/sw/comp/python/2.7_kalkyl/lib/python2.7/site-packages:"'$PYTHONPATH' >> ${i}_runRSeQC_gbc.sh
echo "export PATH=/proj/a2010002/nobackup/sw/mf/bioinfo-tools/pipelines/RSeQC-2.0.0/sw/comp/python/2.7_kalkyl/bin:"'$PATH' >> ${i}_runRSeQC_gbc.sh
echo "module unload samtools" >> ${i}_runRSeQC_gbc.sh
echo "module load samtools/0.1.9" >> ${i}_runRSeQC_gbc.sh
echo "samtools view /tophat_out_${i}/accepted_hits_sorted_dupRemoved_${i}.bam | geneBody_coverage.py -i - -r $bedfile -o $i" >> ${i}_runRSeQC_gbc.sh
echo "R CMD BATCH ${i}.geneBodyCoverage_plot.r" >> ${i}_runRSeQC_gbc.sh
echo "mv geneBody_coverage.pdf ${i}_geneBody_coverage.pdf" >> ${i}_runRSeQC_gbc.sh

done

