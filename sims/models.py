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
