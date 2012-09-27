#!/bin/bash
"""I assume that you hav made a fake delivery to a2012043, run tophat and get stat. 
I allso assume that you stand in the analysis directory: /proj/a2012043/private/nobackup/projects/<proj_id>/<fc_id/merged>. 
I check if the number of reads after duplicates removed exxede half the amount ordered by the costumer and then copy the fastqfiles that has been accepted from our fake delivery dir a2012043/INBOX/proj_id/fc_id to the customer dir.
"""
if [ $# -ne 3 ]; then
  echo "Usage:
        deliver.sh <uppnex_id> <flowcell id> <project id>
	<flowcell id> typ 20120503A_hiseq2000
	Stand in the analysis directory: /proj/a2012043/private/nobackup/projects/<proj_id>/<fc_id/merged> while running this script
	"

  exit
fi

echo 'I HAVE NOT BEEN TRYED YET!!!!!!!!'
echo 'S	hould not be used, since we are supposed to deliver with the deliveryscript to get stuff logged in the correct way. But perhaps it is worth fixing this script so that it also logs this kind of deliveries'
uppnexid=$1
fc_id=$2
proj_id=$3

no_ordered_seq=`python /bubo/home/h24/mayabr/glob/scripts/get_ordered_seq.py $proj_id `
source_path=/proj/a2012043/INBOX/$proj_id/$fc_id
an_path=`pwd`
echo /proj/$uppnexid/INBOX/$proj_id/$fc_id
if [ -d /proj/$uppnexid/INBOX/$proj_id/$fc_id ]; then
        echo /proj/$uppnexid/INBOX/$proj_id/$fc_id' exists'
        exit
else 
	if [ ! -d /proj/$uppnexid/INBOX/$proj_id ]; then
		mkdir /proj/$uppnexid/INBOX/$proj_id
	fi
	mkdir /proj/$uppnexid/INBOX/$proj_id/$fc_id

	min_reads=`echo $no_ordered_seq/2|bc -l`
	for stat in $an_path/tophat_out*/stat*;do
        	dup_rem=(`grep dup_rem $stat|cut -f 2 -d ' '`)
        	name=(`grep Sample $stat|cut -f 2 -d ' '`)
        	no_reads=(`grep tot_#_read_pairs $stat|cut -f 2 -d ' '`)
        	nr=`echo "scale=3;$dup_rem*$no_reads/100000000" | bc -l`
        	check=`echo "$nr > $min_reads" | bc -l`
        	if [ $check = 1 ];then
        	        echo ${name} $nr ${no_reads} 'P'
        	        accepted=$accepted' '${name}
        	else
        	        echo ${name} $nr ${no_reads} 'NP'
        	fi
	done
	echo 'Accepted samples: ' $accepted

	for i in $accepted ;do
		if [ -f $source_path/*_${i}_index*1.fastq ];then  
			echo "sample $i is copied to /proj/$uppnexid/INBOX/$proj_id/$fc_id" 
			cp $source_path/*_${i}_index* /proj/$uppnexid/INBOX/$proj_id/$fc_id
		fi
	done
fi

