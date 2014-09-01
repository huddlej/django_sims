from django.test import TestCase

from sims.models import LogEntry, Pipeline


class PipelineTestCase(TestCase):
    def setUp(self):
        self.pipeline, pipeline_created = Pipeline.objects.get_or_create(name="test", version="0.1")
        self.sample_name = "NA18507"
        self.rule = self.sample_name + ".data.txt"

    def test_log(self):
        """
        Base log method creates a valid LogEntry for the given rule, sample
        name, and status.
        """
        status = "logged"
        self.pipeline.log(self.rule, self.sample_name, status)
        log_entry = LogEntry.objects.get(pipeline=self.pipeline, sample__name=self.sample_name, rule=self.rule, status=status)
        self.assertEqual(log_entry.status, status)

    def test_start(self):
        """
        Custom log method logs "started" status.
        """
        self.pipeline.start(self.rule, self.sample_name)
        log_entry = LogEntry.objects.get(pipeline=self.pipeline, sample__name=self.sample_name, rule=self.rule)
        self.assertEqual(log_entry.status, "started")

    def test_finish(self):
        """
        Custom log method logs "finished" status.
        """
        self.pipeline.finish(self.rule, self.sample_name)
        log_entry = LogEntry.objects.get(pipeline=self.pipeline, sample__name=self.sample_name, rule=self.rule)
        self.assertEqual(log_entry.status, "finished")
