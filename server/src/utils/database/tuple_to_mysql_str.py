def tuple_to_mysql_str(tp):
    if len(tp) == 1: return '(' + tp[0] + ')'
    else: return str(tuple(tp))