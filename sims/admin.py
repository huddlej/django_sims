from django.contrib import admin

from sims.models import LogEntry, Pipeline, Sample

admin.site.register(Pipeline)
admin.site.register(Sample)

class LogEntryAdmin(admin.ModelAdmin):
    list_display = ("sample", "pipeline", "rule", "timestamp", "status")
    list_filter = ("pipeline__name", "status")

admin.site.register(LogEntry, LogEntryAdmin)
