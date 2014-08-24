from django.contrib import admin

from sims.models import LogEntry, Pipeline, Sample

admin.site.register(LogEntry)
admin.site.register(Pipeline)
admin.site.register(Sample)
