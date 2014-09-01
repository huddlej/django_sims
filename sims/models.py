from django.db import models


class Sample(models.Model):
    """
    Represents a single individual.
    """
    name = models.CharField(max_length=30, unique=True)

    def __str__(self):
        return self.name


class Pipeline(models.Model):
    """
    Represents a pipeline with one or more steps through which one or more
    samples can be passed as input.
    """
    name = models.CharField(max_length=100)
    version = models.CharField(max_length=10)

    def __str__(self):
        return self.name + " (" + self.version + ")"

    def log(self, rule, sample_name, status):
        """
        Create a log entry for this pipeline with the given sample, rule, and
        status.
        """
        sample, sample_created = Sample.objects.get_or_create(name=sample_name)
        LogEntry.objects.create(sample=sample, pipeline=self, rule=rule, status=status)

    def start(self, rule, sample_name):
        """
        Helper method to simplify logging the start of a rule.
        """
        return self.log(rule, sample_name, "started")

    def finish(self, rule, sample_name):
        """
        Helper method to simplify logging the finish of a rule.
        """
        return self.log(rule, sample_name, "finished")


class LogEntry(models.Model):
    """
    Represents a checkpoint during a specific pipeline for a given sample.
    """
    # TODO: implement sample as a GenericForeignKey?
    sample = models.ForeignKey(Sample)
    pipeline = models.ForeignKey(Pipeline)
    # TODO: add model for rule tied to Pipeline and only log rule?
    rule = models.CharField(max_length=100)
    timestamp = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=10)
