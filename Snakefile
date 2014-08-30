import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

import django
from sims.models import LogEntry, Pipeline, Sample

pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")

n = [1, 2, 3]

rule all:
    input: expand("{n}.txt", n=n)

rule single:
    output: "{n}.txt"
    run:
        sample, sample_created = Sample.objects.get_or_create(name=wildcards.n)
        LogEntry.objects.create(sample=sample, pipeline=pipeline, rule="single", status="started")
        shell("echo {wildcards.n} > {output}; sleep 5")
        LogEntry.objects.create(sample=sample, pipeline=pipeline, rule="single", status="finished")

rule clean:
    shell: "rm -f *.txt"
