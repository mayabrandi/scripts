import bcbio.google
import bcbio.google.spreadsheet
import sys
import os
print len(sys.argv)
if len(sys.argv) < 3:
	print """
Usage:
To be run from the analysis directory, eg: 

/proj/a2012043/private/nobackup/projects/t_olsson_11_02/intermediate/20120503A_hiseq2000

google_docs_test.py <project id> <run>

	<project id> 	eg: T.Olsson_11_02
	<run>		integer - either 1 or 2
	"""
	sys.exit()

project_ID 	= sys.argv[1]
run 		= "Mapped reads after duplicate removal Run %s" %(str(sys.argv[2]))
ssheet_title 	= "%s_20158_01_Table for QA HiSeq2000 sequencing results for samples" % (project_ID)
wsheet_title 	= 'Sheet1'
credentials_file = '/bubo/home/h24/mayabr/config/gdocs_credentials'

print run
print ssheet_title


samples = os.popen("""
an_path=`pwd`
dup_rem=(`grep dup_rem $an_path/stat|sed 's/%_reads_left_after_dup_rem //g'`)
names=(`grep Sample $an_path/stat|sed 's/Sample //g'`)
no_reads=(`grep tot_#_read_pairs $an_path/stat|sed 's/tot_#_read_pairs //g'`)
dict='{'
i=0
for check in ${dup_rem[*]};do
        #mapped after dup_rem
        nr=`echo "scale=3;$check*${no_reads[i]}/100000000" | bc -l`
        #mRNA frac
        #tot=`grep "Total Fragments" $an_path/Ever_rd_${names[i]}.err|sed 's/Total Fragments               //g'`
        #CDS=`grep "CDS Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #UTR5=`grep "5'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #UTR3=`grep "3'UTR Exons" $an_path/Ever_rd_${names[i]}.err|cut -f 3`
        #check2=`echo "($CDS+$UTR5+$UTR3)/$tot>0.75"|bc -l`
        #mRNA=`echo "scale=3;($CDS+$UTR5+$UTR3)/$tot"|bc -l`
	mRNA='mRNA'
        dict=$dict" '"${names[i]}"':['"$nr"','"$mRNA"'],"
        i=$(( $i + 1 ))
done
dict=$dict'}'
dict=`echo $dict|sed 's/,}/}/g'`
echo $dict
""")
samples=eval(samples.readline().strip())


#-------------

credentials = bcbio.google.get_credentials({'gdocs_upload': {'gdocs_credentials': credentials_file}})
client = bcbio.google.spreadsheet.get_client(credentials)

ssheet = bcbio.google.spreadsheet.get_spreadsheet(client,ssheet_title)
assert ssheet is not None, "Could not find spreadsheet %s" % ssheet_title

wsheet = bcbio.google.spreadsheet.get_worksheet(client,ssheet,wsheet_title)
assert wsheet is not None, "Could not find worksheet %s within spreadsheet %s" % (wsheet_title,ssheet_title)

content = bcbio.google.spreadsheet.get_cell_content(client,ssheet,wsheet)

ss_key = bcbio.google.spreadsheet.get_key(ssheet)
ws_key = bcbio.google.spreadsheet.get_key(wsheet)

#--------------

reads_colindex = 0
names_colindex = 0
rowindex = 0
for j,row in enumerate(content):
	if (names_colindex == 0) | (reads_colindex == 0):
		for i,col in enumerate(row):
			print i
			print str(col).strip()
			if str(col).strip() == 'Sample name Scilife':
				names_colindex = i+1
			if str(col).strip() == run:
				reads_colindex = i+1
	print names_colindex
	print reads_colindex
	name = str(row[names_colindex-1]).strip()
	print name
	if samples.has_key(name):
		print str(samples[name][0])
		client.UpdateCell(j+1, reads_colindex, str(samples[name][0]), ss_key, ws_key)

