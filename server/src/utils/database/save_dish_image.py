import os
from itsdangerous import base64_decode


def save_dish_image(image, dish_id):
    try: os.remove(f'static/images/{dish_id}.jpg')
    except FileNotFoundError: ...
    with open(f'static/images/{dish_id}.jpg', 'wb') as file:
        file.write(base64_decode(image))