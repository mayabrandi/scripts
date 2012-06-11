#!/bin/bash

an_path=`pwd`
dup_rem=(`grep dup_rem $an_path/stat|sed 's/%_reads_left_after_dup_rem //g'`)
names=(`grep Sample $an_path/stat|sed 's/Sample //g'`)
no_reads=(`grep tot_#_read_pairs $an_path/stat|sed 's/tot_#_read_pairs //g'`)
dict='{'
accepted=''
i=0
for check in ${dup_rem[*]};do
	#mapped after dup_rem
	echo ${names[i]}
	echo ${no_reads[i]}
	
	nr=`echo "scale=3;$check*${no_reads[i]}/100000000" | bc -l`
        #mRNA frac
        #tot=`grep "Total Fragments" $an_path/Ever_rd_${names[i]}.err|sed 's/Total Fragments               //g'`
        #CDS=`grep "CDS Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #UTR5=`grep "5'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #UTR3=`grep "3'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #check2=`echo "($CDS+$UTR5+$UTR3)/$tot>0.75"|bc -l`
	#mRNA=`echo "scale=3;($CDS+$UTR5+$UTR3)/$tot"|bc -l`
	#dict=$dict" '"${names[i]}"':['"$nr"','"$mRNA"']," 
	echo ${names[i]} $nr
	check1=`echo "$nr > 9" | bc -l`
        if [ $check1 = 1 ];then
        	echo 'P'
		accepted=$accepted' '${names[i]}
        fi
	i=$(( $i + 1 ))
done
echo $accepted
#dict=$dict'}'
#dict=`echo $dict|sed 's/,}/}/g'`
#echo $dict
