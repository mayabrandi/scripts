#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Usage:
        deliver.sh <uppnex_id> <flowcell id> <project id>
	<flowcell id> typ 20120503A_hiseq2000
	Stand in the analysis directory: /proj/a2012043/private/nobackup/projects/<proj_id>/<fc_id/merged> while running this script
	"

  exit
fi

uppnexid=$1
fc_id=$2
proj_id=$3

no_ordered_seq=`python /bubo/home/h24/mayabr/glob/scripts/get_ordered_seq.py $proj_id `

source_path=/proj/a2012043/INBOX/$proj_id/$fc_id
an_path=`pwd`
#/proj/a2012043/private/nobackup/projects/`echo $proj_id|sed 's/\./\_/g'|sed 's/.*/\L&/'`/intermediate/$fc_id
echo /proj/$uppnexid/INBOX/$proj_id/$fc_id
if [ -d /proj/$uppnexid/INBOX/$proj_id/$fc_id ]; then
        echo /proj/$uppnexid/INBOX/$proj_id/$fc_id' exists'
        exit
else 
	if [ ! -d /proj/$uppnexid/INBOX/$proj_id ]; then
		mkdir /proj/$uppnexid/INBOX/$proj_id
	fi
	mkdir /proj/$uppnexid/INBOX/$proj_id/$fc_id

	dup_rem=(`grep dup_rem $an_path/stat|sed 's/%_reads_left_after_dup_rem //g'`)
	names=(`grep Sample $an_path/stat|sed 's/Sample //g'`)
	no_reads=(`grep tot_#_read_pairs $an_path/stat|sed 's/tot_#_read_pairs //g'`)
	accepted=''
	i=0
	echo $dup_rem
	echo $names
	echo $no_reads
	
	for check in ${dup_rem[*]};do
		#mapped after dup_rem
		nr=`echo "$check*${no_reads[i]}/100" | bc`
		check1=`echo "$check*${no_reads[i]}/100 > ${no_ordered_seq}/2" | bc -l`
                #mRNA frac
#                tot=`grep "Total Fragments" $an_path/Ever_rd_${names[i]}.err|sed 's/Total Fragments               //g'`
#                CDS=`grep "CDS Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
#                UTR5=`grep "5'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
#                UTR3=`grep "3'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
#                check2=`echo "($CDS+$UTR5+$UTR3)/$tot>0.75"|bc -l`
#		mRNA=`echo "scale=3;($CDS+$UTR5+$UTR3)/$tot"|bc -l`
		if [ $check1 = 1 ];then
		#if [[ $check1 = 1 && $check2 = 1 ]];then
			accepted=$accepted' '${names[i]}
		#	echo ${names[i]} $nr $mRNA P
		else
		echo ${names[i]} $nr
		fi
		i=$(( $i + 1 ))

	done
	echo $accepted
	for i in $accepted ;do
		if [ -f $source_path/*_${i}_index*1.fastq ];then  
			echo "sample $i is copied to /proj/$uppnexid/INBOX/$proj_id/$fc_id" 
			cp $source_path/*_${i}_index* /proj/$uppnexid/INBOX/$proj_id/$fc_id
		fi
	done
fi

