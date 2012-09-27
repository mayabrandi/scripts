#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage:
        sample_note_delivery.sh <flowcell id> <project id> <upnex id> <dryrun y/n>

        Arguments:
        <flowcell id>
                - eg: 120127_BD0H2HACXX
        <project id>
                - eg: M.Muurinen_11_01a
        <upnex id>
                - eg: a2012043
	<dryrun y/n>
		- y	will show what files will be moved to where
		- n	will moove files"
  exit
fi

fcID=$1
project_id=$2
uppnex_id=$3
dry=$4
samps=`ls *note.pdf |sed 's/_note.pdf//g'`
path=/proj/$uppnex_id/INBOX/$project_id
if [ $dry == 'y' ];then
echo info
for i in $samps;do 
echo will copy $i* to $path/$i/$fcID
done

else
echo cp
for i in $samps;do cp $i* $path/$i/$fcID;done

fi
