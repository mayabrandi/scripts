import bcbio.google
import bcbio.google.spreadsheet
import sys
import os
"""This script loads Reads after duplicate removal into the 20158 table given
that you have run the analysis pipeline (so that each tophat_out_X dir contains 
a stat_X file with mapping statistics, and that you are standing in the analysis directory. It will overwrite whatever is writen in the column "Reads after duplicate removal" in table 20158. You need th check what version of the document that you what to upload to.)
"""

if len(sys.argv) < 3:
	print """
Usage:
To be run from the analysis directory, eg: 

/proj/a2012043/private/nobackup/projects/t_olsson_11_02/intermediate/20120503A_hiseq2000

load_dupRem_20158.py <project id> <version>

	<project id> 	eg: T.Olsson_11_02
	<version>	document version av 20158 integer - either 1,2 or 3 
	"""
	sys.exit()

project_ID 	= sys.argv[1]
version		= sys.argv[2]
if version=="1":
	run 		= "Mapped reads after duplicate removal Run 1"
	ssheet_title    = "%s_20158_01_Table for QA HiSeq2000 sequencing results for samples" % (project_ID)
	scilife_col	= "Sample name Scilife"
elif version=="2":
	run		= "Reads after duplicate removal (Millions) Run 1"
	ssheet_title    = "%s_20158_02 QC for HiSeq sequencing results" % (project_ID)
	scilife_col     = "Sample name (SciLifeLab)"
elif version=="3":
	run             = "Total number of reads after duplicate removal (Millions)"
	ssheet_title    = "%s_20158_03 QC for HiSeq sequencing results" % (project_ID)
	scilife_col     = "Sample name (SciLifeLab)"
else:
	sys.exit("Unknown versionnumber")

wsheet_title 	= 'Sheet1'
credentials_file = '/bubo/home/h24/mayabr/config/gdocs_credentials'

print run
print ssheet_title


samples = os.popen("""
dict='{'
for stat in tophat_out*/stat*;do
        dup_rem=(`grep dup_rem $stat|cut -f 2 -d ' '`)
        name=(`grep Sample $stat|cut -f 2 -d ' '`)
        no_reads=(`grep tot_#_read_pairs $stat|cut -f 2 -d ' '`)
        nr=`echo "scale=3;$dup_rem*$no_reads/100000000" | bc -l`
        #tot=`grep "Total Fragments" Ever_rd_${names[i]}.err|sed 's/Total Fragments               //g'`
        #CDS=`grep "CDS Exons" Ever_rd_${names[i]}.err|cut -f 3`
        #UTR5=`grep "5'UTR Exons" Ever_rd_${names[i]}.err|cut -f 3`
        #UTR3=`grep "3'UTR Exons" Ever_rd_${names[i]}.err|cut -f 3`
        #check2=`echo "($CDS+$UTR5+$UTR3)/$tot>0.75"|bc -l`
        #mRNA=`echo "scale=3;($CDS+$UTR5+$UTR3)/$tot"|bc -l`
        mRNA='mRNA'
	dict=$dict" '"$name"':['"$nr"','"$mRNA"'],"
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
			if str(col).strip() == scilife_col:
				names_colindex = i+1
			if str(col).strip() == run:
				reads_colindex = i+1
	name = str(row[names_colindex-1]).strip()
	print name
	if samples.has_key(name):
		print str(samples[name][0])
		client.UpdateCell(j+1, reads_colindex, str(samples[name][0]), ss_key, ws_key)

