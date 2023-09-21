from datetime import datetime, date


def default_srlz(obj):
    if isinstance(obj, (datetime, date)):
        return obj.isoformat()
    return str(obj)