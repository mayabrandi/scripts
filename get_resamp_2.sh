#!/bin/bash
#	This script fetches the accepted samples based on M reads left 
# after mapping and duplicate removal. It assumes that you are standing 
# in the analysis directory containing the tophat_out_X directories, and 
# that the analysis pipeline has been run so that each topgat_out_X dir 
# contains a stat_X file with mapping statistics. 

if [ $# -ne 1 ]; then
  echo "Usage:
        get_resamp_2.sh <M reads ordered> 
        	<M reads ordered> 	find this number in genomics project list eg."
  exit
fi

min_reads=`echo $1/2|bc -l`
no_Accepted=0
no_not_Accepted=0
ej_accepted=''
accepted=''
for stat in tophat_out*/stat*;do
	dup_rem=(`grep dup_rem $stat|cut -f 2 -d ' '`)
	name=(`grep Sample $stat|cut -f 2 -d ' '`)
	no_reads=(`grep tot_#_read_pairs $stat|cut -f 2 -d ' '`)
	nr_aft_dup_rem=`echo "scale=3;$dup_rem*$no_reads/100000000" | bc -l`
	check=`echo "$nr_aft_dup_rem > $min_reads" | bc -l`
        if [ $check = 1 ];then
        #        echo ${name} '   ' $nr_aft_dup_rem '   ' ${no_reads} 'P'
                accepted=$accepted' '${name}
		no_Accepted=`echo $no_Accepted+1|bc`
        else
		ej_accepted=$ej_accepted' '${name}
		no_not_Accepted=`echo $no_not_Accepted+1|bc`
                echo ${name} '   ' $nr_aft_dup_rem '   ' ${no_reads} 'NP'
        fi
done
echo 'Ej Accepted samples: ' $ej_accepted
echo 'Accepted samples: ' $accepted
echo 'Number of accepted samples: ' $no_Accepted
echo 'Number of not accepted samples: ' $no_not_Accepted
