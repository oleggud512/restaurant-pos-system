from typing import Iterable
from itsdangerous import base64_decode
from itertools import chain, combinations
import sys, os


def decode_list_of_dict(string, *param_names):
    """
        5|4+3|2 
        TO 
        [
            {
                "param_name1" : 5,
                "param_name2" : 4,
            },
            {
                "param_name1" : 3,
                "param_name2" : 2
            }
        ]
    
    """
    array = [i.split('|') for i in string.split('+')]
    res = []

    for pair in array:
        dicto = {}
        for node, name in zip(pair, param_names):
            dicto[name] = node
        res.append(dicto)
    
    return res

def decode_array(string:str, is_int=False, is_float=False, is_tuple=False):
    """
    1+2+3+4 => [1, 2, 3, 4] || (1, 2, 3, 4) || ('1', '2', '3', '4') || [1.0, 2.0, 3.0, 4.0]
    """
    if len(string) > 0:
        res = string.split('+')
    else:
        return []
    if is_int:
        res = map(lambda x: int(x), res)
    if is_float:
        res = map(lambda x: float(x), res)
    if is_tuple:
        return tuple(res)
    return list(res)

def save_photo(photo, dish_id):
    try: os.remove(f'static/images/{dish_id}.jpg')
    except FileNotFoundError: ...
    with open(f'static/images/{dish_id}.jpg', 'wb') as file:
        file.write(base64_decode(photo))


def tuple_to_str(tp):
    if len(tp) == 1: return '(' + tp[0] + ')'
    else: return str(tuple(tp))

def powerset(iterable):
    "powerset([1,2,3]) --> () (1,) (2,) (3,) (1,2) (1,3) (2,3) (1,2,3)"
    s = list(iterable)
    return tuple(map(lambda sub: '+'.join(list(map(lambda subsub: str(subsub), sub))), list(chain.from_iterable(combinations(s, r) for r in range(len(s)+1)))[1:]))

    