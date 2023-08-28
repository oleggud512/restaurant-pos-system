def decode_query_array(string: str | None, is_int=False, is_float=False, is_tuple=False):
    """
    1+2+3+4 => [1, 2, 3, 4] || (1, 2, 3, 4) || ('1', '2', '3', '4') || [1.0, 2.0, 3.0, 4.0]
    """
    if not string: return []

    res = string.split('+')

    if is_int: res = map(lambda x: int(x), res)
    if is_float: res = map(lambda x: float(x), res)
    if is_tuple: return tuple(res)
    return list(res)