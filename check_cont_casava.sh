
#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage:
        check_cont.sh <flowcell id> <project id>

        Arguments:
        <flowcell id>
                - eg: 120127_BD0H2HACXX
        <project id>
                - eg: M.Muurinen_11_01a"
  exit
fi

fcID=$1
project_id=$2

dir=`pwd`
cd /bubo/proj/a2010002/nobackup/illumina/
grep Human ${project_id}/*/${fcID}/fastq_screen/*.txt|sed 's/:/\//g' |cut -f 2,6 -d '/'
echo ''
grep Mouse ${project_id}/*/${fcID}/fastq_screen/*.txt|sed 's/:/\//g' |cut -f 2,6 -d '/'
echo ''
grep Ecoli ${project_id}/*/${fcID}/fastq_screen/*.txt|sed 's/:/\//g' |cut -f 2,6 -d '/'
echo ''
grep Spruce ${project_id}/*/${fcID}/fastq_screen/*.txt|sed 's/:/\//g' |cut -f 2,6 -d '/'
echo ''
grep PhiX ${project_id}/*/${fcID}/fastq_screen/*.txt|sed 's/:/\//g' |cut -f 2,6 -d '/'
cd $dir

