import logging
import os
import sys
sys.path.append("/Users/jlhudd/Documents/code/django_sims")
os.environ["DJANGO_SETTINGS_MODULE"] = "django_sims.settings"

#from mongolog.handlers import MongoHandler
import django
from sims.models import LogEntry, Pipeline, Sample

pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")

# # Create logger.
# dblog = logging.getLogger("dblogger")

# # Create handler and add to logger.
# dblog.addHandler(MongoHandler.to(db='mongolog', collection='log'))

# # Create formatter and add to handler.
# dblog.setLevel(logging.DEBUG)

n = [1, 2, 3]

rule all:
    input: expand("{n}.txt", n=n)

rule single:
    output: "{n}.txt"
    run:
        #dblog.debug("Start single", sample=wildcards.n)
        sample, sample_created = Sample.objects.get_or_create(name=wildcards.n)
        LogEntry.objects.create(sample=sample, pipeline=pipeline, rule="single", status="started")
        shell("echo {wildcards.n} > {output}; sleep 5")
        LogEntry.objects.create(sample=sample, pipeline=pipeline, rule="single", status="finished")
        #dblog.debug("End single", sample=wildcards.n)

rule clean:
    shell: "rm -f *.txt"
