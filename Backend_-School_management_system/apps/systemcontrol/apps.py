from django.apps import AppConfig


class SystemcontrolConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'apps.systemcontrol'

    def ready(self):
        """Import signals when app is ready"""
        import apps.systemcontrol.signals
