import json
import requests
from requests.models import Request

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

a = requests.get(ROOT + "/supplys/filter_sort")
print(a.text)