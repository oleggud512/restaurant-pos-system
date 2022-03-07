import datetime
from functools import reduce
from pprint import pprint
from typing import Any
from flask import Flask, redirect, render_template, request, jsonify, url_for, abort, make_response
from base64 import decodebytes
from mysql.connector import connect, MySQLConnection
from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps
import services as srv
import collections

from database import cur_to_dict

con: MySQLConnection = connect(host='localhost', 
                                    port=3306, 
                                    user='root', 
                                    password='3542', 
                                    database='restaurant')


app = Flask(__name__)


@app.errorhandler(400)
def bed_request(error):
    return make_response(jsonify({'error': 'bed_request'}), 400)


@app.route('/')
def index(): return 'Index page. Nothing interesting. Go to /restaurant/v%/...'


@app.route('/restaurant/v1')
def get_some():
    return '{"rest": "root"}'


@app.route('/restaurant/v1/groceries', methods=['GET'])
def get_groceries():
    """list of groceries"""
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT groc_id, groc_name, groc_measure, ava_count
        FROM groceries
        WHERE groc_name LIKE '%{request.args["like"]}%'
    """)

    groceries = cur_to_dict(cur)

    for groc in groceries:
        cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {groc["groc_id"]}
        """)

        groc['supplied_by'] = cur_to_dict(cur)


    return dumps(groceries, indent=4, use_decimal=True)


@app.route('/restaurant/v1/groceries/<int:groc_id>', methods=['GET'])
def get_grocery(groc_id):
    """single grocery"""
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT groc_id, groc_name, groc_measure, ava_count
        FROM groceries
        WHERE groc_id = {groc_id}
    """)

    grocery = cur_to_dict(cur)[0]

    cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {grocery["groc_id"]}
        """)

    grocery['supplied_by'] = cur_to_dict(cur)
    cur.close()

    return dumps(grocery, indent=4, use_decimal=True)


@app.route('/restaurant/v1/groceries/<int:groc_id>', methods=['PUT'])
def update_grocery(groc_id):
    """rewrites all information about single grocery"""
    cur: CMySQLCursor = con.cursor()
    
    ava_count = request.args['ava_count']
    groc_name = request.args['groc_name']
    groc_measure = request.args['groc_measure']

    cur.execute(f"""
        UPDATE groceries 
        SET ava_count = \'{ava_count}\', 
            groc_name = \'{groc_name}\', 
            groc_measure = \'{groc_measure}\'
        WHERE groc_id = {groc_id}
    """)
    con.commit()

    return 'success'


@app.route('/restaurant/v1/groceries', methods=['POST'])
def add_grocery():
    """adds one grocery"""
    cur: CMySQLCursor = con.cursor()
    
    ava_count = request.json['ava_count']
    groc_name = request.json['groc_name']
    groc_measure = request.json['groc_measure']

    cur.execute(f"""
        INSERT INTO groceries(groc_name, groc_measure, ava_count) 
        VALUES (\'{groc_name}\', \'{groc_measure}\', {ava_count})
    """)

    con.commit()
    return 'success'


@app.route('/restaurant/v1/suppliers/<int:sup_id>', methods=['PUT'])
def update_supplier(sup_id):
    """rewrites all information about single supplier"""
    new_name = request.json.get("name", None)
    new_contacts = request.json.get("contacts", None)
    new_groceries = request.json.get("groceries", [])
    
    cur: CMySQLCursor = con.cursor()
    
    if not sup_id: return "where is id?"

    if new_name and new_contacts:
        sql = f"UPDATE suppliers SET supplier_name = '{new_name}', contacts = '{new_contacts}' WHERE supplier_id = {sup_id}"
    elif new_name:
        sql = f"UPDATE suppliers SET supplier_name = '{new_name}' WHERE supplier_id = {sup_id}"
    elif new_contacts:
        sql = f"UPDATE suppliers SET contacts = '{new_contacts}' WHERE supplier_id = {sup_id}"
    cur.execute(sql)
    con.commit()
    
    if new_groceries:
        cur.execute(f'DELETE FROM suppliers_groc WHERE supplier_id = "{sup_id}"')
        con.commit()

        sql = f'INSERT INTO suppliers_groc(supplier_id, groc_id, sup_groc_price) VALUES '
        values = []
        for i in new_groceries:
            values.append(str((sup_id, i['groc_id'], i['sup_groc_price'])))
        sql += ', '.join(values)

        cur.execute(sql)
        con.commit()

    return 'success'


@app.route('/restaurant/v1/suppliers/<int:supplier_id>', methods=['GET'])
@app.route('/restaurant/v1/suppliers', methods=['GET'])
def get_suppliers(supplier_id=None):
    """if supplier_id is not None returns single supplier else returns list of all suppliers"""
    cur: CMySQLCursor = con.cursor()
    cur.execute(f"""SELECT * 
        FROM suppliers 
        WHERE supplier_name != 'deleted'
        {" AND supplier_id = " + str(supplier_id) if supplier_id != None else ''}
    """)
    suppliers = cur_to_dict(cur)
    
    cur.execute(f"""
        SELECT supplier_id, groc_id, groc_name, sup_groc_price, groc_measure, ava_count
        FROM suppliers_groc sg 
            JOIN groceries gr USING(groc_id) 
            JOIN suppliers USING(supplier_id)
        WHERE supplier_name != 'deleted'
        {" AND supplier_id = " + str(supplier_id) if supplier_id != None else ''}
    """)

    groceries = cur_to_dict(cur)

    for groc in groceries:
        cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {groc["groc_id"]}
        """)

        groc['supplied_by'] = cur_to_dict(cur)

    for supplier in suppliers:
        supplier["groceries"] = list(filter(lambda groc: groc['supplier_id'] == supplier['supplier_id'], groceries))
    
    cur.close()
    return dumps(suppliers, indent=4, use_decimal=True) 


@app.route("/restaurant/v1/suppliers", methods=['POST'])
def add_supplier():
    """adds single supplier"""
    supplier_name = request.json['supplier_name']
    contacts = request.json['contacts']

    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        INSERT INTO suppliers(supplier_name, contacts)
        VALUES ('{supplier_name}', '{contacts}')
    """)
    con.commit()

    cur.close()

    return 'success'


@app.route("/restaurant/v1/suppliers/<int:supplier_id>", methods=['DELETE'])
def delete_supplier(supplier_id):
    """deletes one supplier"""
    
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        UPDATE suppliers 
        SET supplier_name = 'deleted'
        WHERE supplier_id = {supplier_id}
    """) 
    
    # cur.execute(f"""
    #     DELETE FROM suppliers_groc
    #     WHERE supplier_id = {supplier_id}
    # """)
    
    con.commit()
    cur.close()

    return 'success'

@app.route("/restaurant/v1/supplys/<int:supply_id>", methods=['GET'])
@app.route("/restaurant/v1/supplys", methods=['GET'])
def get_supplys(supply_id=None):
    cur: CMySQLCursor = con.cursor()
    sort_collumn = request.args['sort_collumn']
    sort_direction = request.args['sort_direction']
    price_from = request.args['price_from']
    price_to = request.args['price_to']
    date_from = request.args['date_from']
    date_to = request.args['date_to']

    if request.args['suppliers'] != '':
        suppliers = list(map(lambda x: int(x), request.args['suppliers'].split('+')))
    else: 
        suppliers = [0]

    sql = f"""
        SELECT supply_id, supply_date, supplier_id, supplier_name, summ 
        FROM supply_view 
        WHERE supply_date >= DATE(\'{date_from}\') 
            AND supply_date <= DATE(\'{date_to}\')
            AND summ >= {price_from}
            AND summ <= {price_to} 
            AND supplier_id IN {tuple(suppliers) if len(suppliers) > 1 else '('+str(suppliers[0])+')'}
        ORDER BY {sort_collumn} {sort_direction}
    """

    cur.execute(sql)

    supplys = cur_to_dict(cur)

    cur.execute(f"""
        SELECT supply_id, groc_id, groc_count, groc_name, groc_price
        FROM supply_groceries_view
    """)

    groceries = cur_to_dict(cur)
    
    for supply in supplys: # присваивание поставкам их продуктов, указаных в list_supplys
        supply['groceries'] = list(filter(lambda groc: groc['supply_id'] == supply['supply_id'], groceries))

    return dumps(supplys, indent=4, use_decimal=True)


@app.route("/restaurant/v1/supplys/filter_sort", methods=['GET'])
def filter_sort():
    cur: CMySQLCursor = con.cursor()
    
    cur.execute("""
        SELECT max_date, max_summ, min_date
        FROM max_values_view
    """)
    
    filter_sort_data = cur_to_dict(cur)[0]

    cur.execute("""
        SELECT supplier_id, supplier_name
        FROM mini_suppliers_view
    """)

    filter_sort_data['suppliers'] = cur_to_dict(cur)
    print(filter_sort_data)
    return dumps(filter_sort_data, indent=4, use_decimal=True)


@app.route("/restaurant/v1/supplys", methods=['POST'])
def add_supply():
    cur: CMySQLCursor = con.cursor()
    pprint(request.json)
    cur.execute(f"""
        INSERT INTO supplys(supplier_id, summ) 
        VALUES ({request.json['supplier_id']}, {request.json['summ']})
    """)
    supply_id = cur.lastrowid
    con.commit()
    for groc in request.json['groceries']:
        cur.execute(f"""
            CALL add_groc_to_certain_supply(
                {supply_id}, 
                {groc['groc_id']}, 
                {groc['groc_count']}
            )
        """)
        con.commit()

    cur.close()
    return 'success'


@app.route("/restaurant/v1/supplys/<int:supply_id>", methods=['DELETE'])
def delete_supply(supply_id):
    cur: CMySQLCursor = con.cursor()
    cur.execute(f'CALL delete_supply({supply_id})')
    con.commit()
    cur.close()
    return 'success'


@app.route('/restaurant/v1/settings/delete_info_about_deleted_suppliers', methods=['DELETE'])
def delete_inf_ab_del_s():
    cur: CMySQLCursor = con.cursor()
    cur.execute('CALL del_info_about_del_suppliers()')
    con.commit()
    cur.close()
    return 'success'


@app.route('/restaurant/v1/menu', methods=['GET'])
def get_menu():
    cur: CMySQLCursor = con.cursor()

    like = request.args.get('like', '')
    min_price = request.args.get('min_price', 0)
    max_price = request.args.get('max_price')
    
    cur.execute(f"""
        SELECT dish_id, dish_name, dish_price, dish_gr_id FROM dishes
        WHERE dish_name LIKE '%{like}%'
    """)
    
    dishes = cur_to_dict(cur)

    cur.execute(f"""
        SELECT dc.groc_id, g.groc_name, dc.dc_count, dc.dish_id
        FROM dish_consists dc JOIN groceries g USING(groc_id)
    """)

    groceries = cur_to_dict(cur)

    for dish in dishes:
        dish['consist'] = list(filter(lambda x: dish['dish_id'] == x['dish_id'], groceries))

    cur.execute(f"""
        SELECT dish_gr_id, dish_gr_name FROM dish_groups
    """)

    groups = cur_to_dict(cur)

    cur.execute(f"""
        SELECT MIN(dish_price) AS min_price, MAX(dish_price) AS max_price
        FROM dishes
    """)

    filter_sort_data = cur_to_dict(cur)[0]
    print(dumps(
        {
            'dishes' : dishes, 
            'groups' : groups, 
            'filter_sort_data': filter_sort_data
        }, 
        indent=4
    ))
    cur.close()
    return dumps(
        {
            'dishes' : dishes, 
            'groups' : groups, 
            'filter_sort_data': filter_sort_data
        }, 
        indent=4
    )


@app.route('/restaurant/v1/menu', methods=['POST'])
def add_dish():
    cur: CMySQLCursor = con.cursor()

    groceries = request.json['consist']

    # с процедурами не работает cur.lastrowid
    cur.execute(f"""
        INSERT INTO dishes(dish_name, dish_price, dish_gr_id)
        VALUES (
            '{request.json['dish_name']}',
            {request.json['dish_price']},
            {request.json['dish_gr_id']}
        );
    """)
    dish_id = cur.lastrowid
    con.commit()


    for groc in groceries:
        cur.execute(f"""
            CALL add_grocery_to_certain_dish(
                {dish_id},
                {groc['groc_id']},
                {groc['groc_count']}
            )
        """)
        print("PROCEDURE")
        con.commit()

    cur.close()
    return 'success'


@app.route('/restaurant/v1/menu/prime-cost/<string:groc_ids>', methods=['GET'])
def get_prime_cost(groc_ids):
    """
        находит минимальную цену за указаные продукты
            {
                total: total_summ,
                consist: [
                    {
                        supplier_id: 
                        supplier_name:
                        min_price:
                        groc_name:
                    }
                ]
            }
    """
    # groceries - список id продуктов
    cur: CMySQLCursor = con.cursor()
    groc_id_count = srv.decode_list_of_dict(groc_ids, 'groc_id', 'groc_count')
    
    prime_cost = {'consist' : [], 'total': 0}

    for groc in groc_id_count:
        print(groc)
        # CALL get_min_groc_price({groc_id}) ---> не работает...
        cur.execute(f"""SELECT 
                s.supplier_id, 
                s.supplier_name, 
                MIN(sg.sup_groc_price) AS min_price, 
                g.groc_name
            FROM suppliers_groc sg 
                JOIN suppliers s USING(supplier_id)
                JOIN groceries g USING(groc_id)
            WHERE groc_id = {groc['groc_id']}
        """)
        grocery = cur_to_dict(cur)[0]

        if (grocery['min_price'] == None): return dumps(
            {
                'total': 0,
                'consist': [
                    {
                        "supplier_id" : 666,
                        "supplier_name" : "no no no no",
                        "min_price" : 666
                    }
                ],
            }
        )

        prime_cost['total'] += float(grocery['min_price']) * float(groc['groc_count'])
        prime_cost['consist'].append(grocery)

    print(dumps(prime_cost, indent=2))

    cur.close()
    return dumps(prime_cost, indent=2)


if __name__ == '__main__':
    app.run()