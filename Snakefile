import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

import django
from sims.models import Pipeline

pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")

samples = ["NA12878", "NA18507"]

rule all:
    input: expand("{sample}.txt", sample=samples)

rule single:
    output: "{sample}.txt"
    run:
        pipeline.start(output, wildcards.sample)
        shell("echo {wildcards.sample} > {output}; sleep 1")
        pipeline.finish(output, wildcards.sample)

rule clean:
    shell: "rm -f *.txt"
