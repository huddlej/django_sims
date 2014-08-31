import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

import django
from sims.models import LogEntry

pipeline_name = "test"
pipeline_version = "0.1"

n = ["NA12878", "NA18507"]

rule all:
    input: expand("{n}.txt", n=n)

rule single:
    output: "{n}.txt"
    run:
        LogEntry.objects.log(wildcards.n, pipeline_name, pipeline_version, output, "started")
        shell("echo \"{input}: {wildcards.n}\" > {output}; sleep 1")
        LogEntry.objects.log(wildcards.n, pipeline_name, pipeline_version, output, "finished")

rule clean:
    shell: "rm -f *.txt"
