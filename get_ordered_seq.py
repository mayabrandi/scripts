#!/usr/bin/env python

import os
import sys
from bcbio.google import bc_metrics
from bcbio.pipeline.config_loader import load_config
from bcbio.scilifelab.google.project_metadata import ProjectMetaData

config_file="/bubo/home/h24/mayabr/config/post_process.yaml"
project_id=sys.argv[1]

config = load_config(config_file)
proj_data = ProjectMetaData(project_id, config)
min_reads_per_sample = int(float(proj_data.min_reads_per_sample)*1000000)

print min_reads_per_sample
