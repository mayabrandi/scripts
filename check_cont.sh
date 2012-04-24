
#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage:
        check_cont.sh <flowcell id> <project id>

        Arguments:
        <flowcell id>
                - eg: 120127_SN1018_0062_BD0H2HACXX
        <project id>
                - eg: M.Muurinen_11_01a"
  exit
fi

fcID=$1
project_id=$2

dir=`pwd`
echo ""
echo $fcID
echo $project_id
echo ""

if [ -f /bubo/proj/a2010002/nobackup/illumina/${fcID}/fastq_screen/*.txt ]; then
mkdir temp
cd /bubo/proj/a2010002/nobackup/illumina/
grep Human ${fcID}/fastq_screen/*.txt > $dir/temp/Human.txt
grep Mouse ${fcID}/fastq_screen/*.txt > $dir/temp/Mouse.txt
grep Ecoli ${fcID}/fastq_screen/*.txt > $dir/temp/Ecoli.txt
grep Spruce ${fcID}/fastq_screen/*.txt > $dir/temp/Spruce.txt
grep PhiX ${fcID}/fastq_screen/*.txt > $dir/temp/PhiX.txt
cd $dir

H=`python ~mikaelh/scripts/translate.py temp/Human.txt|grep $project_id|cut -f 6 |uniq`

if [ "$H" = "" ]; then
	echo "
your spelling of the project id might be wrong. 
Check for the correct spelling in the list below:

"
	python ~mikaelh/scripts/translate.py temp/Mouse.txt|cut -f 6|uniq
else

	echo "Sample info  % not mapping  % mapping  % mapping to Human Mouse or Ecoli"
	echo ""
	python ~mikaelh/scripts/translate.py temp/Human.txt|grep $project_id|cut -f 3 -d '/'|cut -f 1,2,3,4
	echo ""
	python ~mikaelh/scripts/translate.py temp/Mouse.txt|grep $project_id|cut -f 3 -d '/'|cut -f 1,2,3,4
	echo ""
	python ~mikaelh/scripts/translate.py temp/Ecoli.txt|grep $project_id|cut -f 3 -d '/'|cut -f 1,2,3,4
	echo ""
	python ~mikaelh/scripts/translate.py temp/Spruce.txt|grep $project_id|cut -f 3 -d '/'|cut -f 1,2,3,4
	echo ""
	python ~mikaelh/scripts/translate.py temp/PhiX.txt|grep $project_id|cut -f 3 -d '/'|cut -f 1,2,3,4

fi
echo ""
rm -r temp

else 
echo "ERROR: Could not find file /bubo/proj/a2010002/nobackup/illumina/${fcID}/fastq_screen/*.txt"

fi
