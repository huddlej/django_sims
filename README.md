# Django SIMS

Django SIMS (sample information management system) provides centralized logging
for distributed computational analyses.

The element of logging is a ``LogEntry``. Each ``LogEntry`` instance attaches a
status and timestamp to a rule or expected output for a given pipeline and
sample.

## Usage

Add Django SIMS calls to existing Python code. The original API was designed for
use within Johannes Köster's
[Snakemake](https://bitbucket.org/johanneskoester/snakemake/wiki/Home), a
Python-based DSL that improves upon GNU Make. See the included ``Snakefile`` and
``sims/tests.py`` for examples.

Log an arbitrary status.

```python
from sims.models import Pipeline

pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")
pipeline.log("my_sample_output.txt", "my_sample", "logged")
```

Alternately, use helper methods for common logging operations like the start and
finish of a pipeline's rule.

```python
pipeline.start("my_sample_output.txt", "my_sample")
do_something("my_sample")
pipeline.finish("my_sample_output.txt", "my_sample")
```
