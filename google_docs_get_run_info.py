#!/usr/bin/env python
"""google_docs_get_run_info.py
Created by Maya Brandi on 2012-06-05.
"""
import bcbio.google
import bcbio.google.spreadsheet
import sys
import os

def main(project_name):

	if len(sys.argv) < 2:
        	print """Usage:		google_docs_get_run_info <project ID>"""
		sys.exit()

	credentials_file = '/bubo/home/h24/mayabr/config/gdocs_credentials'

	try:
		ssheet = "Genomics Project list"
		wsheet = "Ongoing"
        	content, ws_key, ss_key = get_google_document(ssheet,wsheet,credentials_file)
		dummy, uppnex_ID_colindex = get_column(content,'Uppnex ID')
		dummy, project_name_colindex = get_column(content,'Project name')
		dummy, No_samps_colindex = get_column(content,'No of samples')
        	for j,row in enumerate(content):
			name = str(row[project_name_colindex]).strip()
			if name == project_name:
                		uppnexid=str(row[uppnex_ID_colindex]).strip()
                	        No_samps=str(row[No_samps_colindex]).strip()
        	               	break
	except:
		pass

	try:
        	ssheet = project_name+"_20132_02_Table for Sample Summary and Reception Control"
	        wsheet = "Sheet1"
        	content, ws_key, ss_key = get_google_document(ssheet,wsheet,credentials_file)
	        dummy, customer_names_colindex = get_column(content,'Sample name from customer')
        	row_ind, scilife_names_colindex = get_column(content,'Sample name Scilife')
	        samplenames={}
        	for j,row in enumerate(content):
                	if (j>row_ind)&(str(row[scilife_names_colindex-1]).strip() != ''):
                        	samplenames[str(row[scilife_names_colindex]).strip()]=str(row[customer_names_colindex]).strip()
        except: 
                pass

	P_NP={}
	try:
        	ssheet = project_name + "_20158_01_Table for QA HiSeq2000 sequencing results for samples"
	        wsheet = "Sheet1"
        	content, ws_key, ss_key = get_google_document(ssheet,wsheet,credentials_file)
	        dummy, P_NP_colindex = get_column(content,'Passed=P/ not passed=NP*')
        	row_ind, scilife_names_colindex = get_column(content,'Sample name Scilife')
        	for j,row in enumerate(content):
                	if (j > row_ind) & (str(row[scilife_names_colindex]).strip() != ''):
                        	P_NP[str(row[scilife_names_colindex]).strip()]=str(row[P_NP_colindex]).strip()
	except:
		pass
	
	return P_NP,samplenames,uppnexid,No_samps


def get_google_document(ssheet_title,wsheet_title,credentials_file):
	""""""
	credentials = bcbio.google.get_credentials({'gdocs_upload': {'gdocs_credentials': credentials_file}})
	client = bcbio.google.spreadsheet.get_client(credentials)
	ssheet = bcbio.google.spreadsheet.get_spreadsheet(client,ssheet_title)
	assert ssheet is not None, "Could not find spreadsheet %s" % ssheet_title
	wsheet = bcbio.google.spreadsheet.get_worksheet(client,ssheet,wsheet_title)
	assert wsheet is not None, "Could not find worksheet %s within spreadsheet %s" % (wsheet_title,ssheet_title)
	content = bcbio.google.spreadsheet.get_cell_content(client,ssheet,wsheet)
	ss_key = bcbio.google.spreadsheet.get_key(ssheet)
	ws_key = bcbio.google.spreadsheet.get_key(wsheet)
	return content, ws_key, ss_key


def get_column(ssheet_content,header):
	""""""
	colindex=''
	for j,row in enumerate(ssheet_content):
                if colindex == '':
                        for i,col in enumerate(row):
                                if str(col).strip() == header:
                                        colindex = i
		else:
			rowindex = j-1
			return rowindex, colindex

if __name__ == '__main__':
	P_NP,samplenames,uppnexid,No_samps=main(sys.argv[1])
	print samplenames
	print P_NP
	print uppnexid
	print No_samps
