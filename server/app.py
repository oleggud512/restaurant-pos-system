from flask import Flask, redirect, render_template, request, jsonify, url_for
from base64 import decodebytes
from mysql.connector import connect, MySQLConnection
from mysql.connector.cursor_cext import CMySQLCursor

from database import cur_to_dict

app = Flask(__name__)


def increase_index():
    with open('next_index.json', 'r') as file:
        ind = int(file.read())
    with open('index_index.json', 'w') as file:
        file.write(ind+1)
    return ind


@app.route('/second', methods=['GET'])
def bbb():
    return request.args['a']

@app.route('/first', methods=['GET'])
def aaa():
    return str(bbb())

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'GET':
        return "hello from index"

    if request.method == 'POST':
        action = request.json['action']
        con: MySQLConnection = connect(host='localhost', 
                                    port=3306, 
                                    user='root', 
                                    password='3542', 
                                    database='publisher')
        cur:CMySQLCursor = con.cursor()
        # из строки (которая пришла к нам в base64) в байты
        # image_in_base64 = str.encode(request.json['image'])
        
        # with open('images/posted_image.jpg', 'wb') as new_photo:
        #     # байты в base64 декодируем в фотку
        #     new_photo.write(decodebytes(image_in_base64))
        if action == 'GET_ALL_GROCERIES':
            """все ингридиенты будем добавлять в отдельном окне"""
            sql = 'SELECT groc_name, ava_count FROM groceries'
            cur.execute(sql)
            res = list(map(lambda x: x[0], cur.fetchall()))
            cur.close()
            return res
        
        if action == 'GET_ALL_GROUPS':
            """группы блюд тоже добавить в отдельном окне"""
            sql = 'SELECT group_name FROM dish_groups'
            cur.execute(sql)
            res = list(map(lambda x: x[0], cur.fetchall()))
            cur.close()
            return res


        if action == 'ADD_GROCERY':
            groc_measure = request.json['measure']
            groc_name = request.json['name']

            sql = f'INSERT INTO groceries(groc_name, groc_measure) VALUES ({groc_name}, {groc_measure})'

            cur.execute(sql)
            con.commit()
            cur.close()
            return 'success' # нужно посмотреть как делать эти exception handling
                             # а то что-то это как-то не очень...

        if action == 'ADD_DISH':
            image_in_base64 = str.encode(request.json['image'])
            name = request.json['name']
            price = request.json['price']
            descr = request.json['descr']
            groceries = request.json['groceries']
            group = request.json['group']
            i = increase_index()
            
            sql = 'INSERT INTO dishes(dish_name, dish_price, dish_descr, .......) VALUES ....'

            cur: CMySQLCursor = con.cursor()
            
            con.commit()
            cur.close()


        return "its all ended!!!"


if __name__ == '__main__':
    app.run()