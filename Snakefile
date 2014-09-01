import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

import django
from sims.models import Pipeline

pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")

n = ["NA12878", "NA18507"]

rule all:
    input: expand("{n}.txt", n=n)

rule single:
    output: "{n}.txt"
    run:
        pipeline.start(wildcards.n, output)
        shell("echo {wildcards.n} > {output}; sleep 1")
        pipeline.finish(wildcards.n, output)

rule clean:
    shell: "rm -f *.txt"
