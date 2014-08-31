import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

import django
from sims.models import LogEntry, Pipeline

pipeline_name = "test"
pipeline_version = "0.1"
pipeline, pipeline_created = Pipeline.objects.get_or_create(name=pipeline_name, version=pipeline_version)

n = ["NA12878", "NA18507"]

rule all:
    input: expand("{n}.txt", n=n)

rule single:
    output: "{n}.txt"
    run:
        LogEntry.objects.log(wildcards.n, pipeline, output, "started")
        shell("echo \"{input}: {wildcards.n}\" > {output}; sleep 1")
        LogEntry.objects.log(wildcards.n, pipeline, output, "finished")

rule clean:
    shell: "rm -f *.txt"
