import json
import requests
from requests.models import Request

from services import decode_list_of_dict

ROOT = 'http://127.0.0.1:5000/restaurant/v1/'


def add_supplier():
    data = {
        "name" : "other_supplier",
        "contacts": "someaddres@mail.ru",
        "groceries": [
            {
                "price":666,
                "id": 3
            },
            {
                "price": 998,
                "id": 2
            }
        ]
    }
    a = requests.post(ROOT+"suppliers", json=data)
    print(a)


def alter_supplier():
    data = {
        "name" : "other_supplier",
        "contacts": "someaddres@mail.ru",
        "groceries": [
            {
                "price":666,
                "id": 3
            },
            {
                "price": 998,
                "id": 2
            }
        ]
    }
    a = requests.put(ROOT+"suppliers", json=data)
    print(a)

def get_suppliers():
    a: Request = requests.get(ROOT+"suppliers")
    print(a.text)

# get_suppliers()

def get_groc():
    a = requests.get(ROOT + 'groceries/3')
    print(a.text)

# get_suppliers()

# a = requests.post(ROOT + 'menu', json={
#     'dish_name': 'alibaba', 
#     'dish_price': 56.65, 
#     'dish_gr_id': 1, 
#     'consist': [
#         {'groc_id': 1, 'groc_name': 'картошка', 'groc_count': 4.0}, 
#         {'groc_id': 2, 'groc_name': 'морковка', 'groc_count': 3.0}, 
#         {'groc_id': 3, 'groc_name': 'лук', 'groc_count': 2.0}
#     ]
# })

# a = requests.get(ROOT + 'menu/prime-cost/1+2+3')
# a = requests.get(ROOT + 'hellonio', params={'mumbai': [1, 2, 3, 4, 5]})
# print(a.text)

# t = '1|2+2|1+3|2.356'
# a = requests.get(ROOT + 'menu/prime-cost/' + t)
# # print(decode_list_of_dict(t, 'groc_id', 'groc_count'))
# print(a.text)


