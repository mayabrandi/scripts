#!/usr/bin/env python
""""""

import sys
import os
import couchdb
import hashlib
import time

def  main():
	couch 	= couchdb.Server("http://maggie.scilifelab.se:5984")
	qc 	= couch['qc']
	my_key 	= hashlib.md5('M.Brandi_12_06').hexdigest()

	obj={	'min M reads per sample ordered': 18, 
		'summary of samples sequenced': '', 
		'entity_type': 'ProjectSummary',
	 	'Uppnex id': 'b890328', 
		'samples': {	'1': {'status': 'NP', 'M reads sequenced': 8, 'customer name': 'Al'},
				'3': {'status': 'NP', 'M reads sequenced': 10, 'customer name': 'Cl'}, 
				'2': {'status': 'P', 'M reads sequenced': 20, 'customer name': 'Bl'}}, 
		'Project id': 'Maya_Brandi_12_06', 
		'entity_version': 0.1,
		'_id': my_key}

	save_obj(qc, obj)

def save_obj(db, obj):
    dbobj = db.get(obj['_id'])
    if dbobj is None:
        obj["creation_time"] = time.strftime("%x %X")
        obj["modification_time"] = time.strftime("%x %X")
        db.save(obj)
    else:
        obj["_rev"] = dbobj.get("_rev")
        if obj != dbobj:
            obj["creation_time"] = dbobj["creation_time"]
            obj["modification_time"] = time.strftime("%x %X")
            db.save(obj)
    return True


 
if __name__ == '__main__':
	main()

