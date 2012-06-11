#!/usr/bin/env python
"""
test.py

Created by Maya Brandi on 2012-06-05.
"""
import sys
import os


def main(projname):
	print projname
	ssheet = "_ 20158_01_Table for QA HiSeq2000 sequencing results for samples"
	wsheet = "Sheet1"
	content, ws_key, ss_key = get_google_document(ssheet,wsheet,13)
	print content
	print ws_key
	print ss_key

def get_google_document(ssheet_title,wsheet_title,credentials_file):
	"""
        """
	return ssheet_title, wsheet_title, credentials_file

if __name__ == '__main__':
	projname = sys.argv[1]
	main(projname)


