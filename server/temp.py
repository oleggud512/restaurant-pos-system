

from pprint import pprint
from json import dump


with open('log.txt', 'r') as file: 
    a = list(map(lambda x: x.rstrip(), file.readlines()))
    
with open("n.json", 'w') as file:
    dump(a, file, indent=4)