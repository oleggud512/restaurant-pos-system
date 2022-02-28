import datetime
from xmlrpc.client import DateTime
from mysql.connector import connect, MySQLConnection
from mysql.connector.cursor_cext import CMySQLCursor
from pprint import pprint
from flask import jsonify
from json import dumps, loads


con: MySQLConnection = connect(host='localhost', 
                                    port=3306, 
                                    user='root', 
                                    password='3542', 
                                    database='publisher')

def cur_to_dict(cur: CMySQLCursor):
    result = []
    data = cur.fetchall()
    for row in data:
        row_dict = {}
        for col_name, col_value in zip(cur.column_names, row):
            if type(col_value) == datetime.date: 
                row_dict[col_name] = col_value.isoformat()
            else:
                row_dict[col_name] = col_value
        result.append(row_dict)
    return result


cur: CMySQLCursor = con.cursor()

cur.execute("SELECT b_name, b_circul, b_id FROM books")

