import datetime
from functools import reduce
from importlib.metadata import requires
from pprint import pprint
from typing import Any
from flask import Flask, redirect, render_template, request, jsonify, url_for, abort, make_response
from base64 import decodebytes
from itsdangerous import base64_decode, base64_encode
from mysql.connector import connect, MySQLConnection
from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps
import collections

import src.utils.database as db_utils
from src.utils.database import cur_to_dict
import src.utils.query as q_utils


con: MySQLConnection = connect(
    host='localhost', 
    port=3306, 
    user='restaurant_user', 
    password='rstrpass', 
    database='restaurant'
)

app = Flask(__name__)


@app.errorhandler(400)
def bed_request(error):
    return make_response(jsonify({'error': 'not found'}), 400)


@app.route('/')
def index(): return 'Index page. Nothing interesting. Go to /restaurant/v%/...'


@app.route('/restaurant/v1')
def get_restaurant_root():
    return '{"rest": "root"}'


@app.route('/restaurant/v1/groceries', methods=['GET'])
def get_groceries():
    """list of groceries"""
    cur: CMySQLCursor = con.cursor()

    like = request.args['like'] if request.args['like'] else ''

    try:
        supplied_only = True if request.args['supplied_only'] == 'true' else False
    except:
        supplied_only = False
    # print(type(supplied_only), supplied_only)

    cur.execute(f"""
        SELECT DISTINCT groc_id, groc_name, groc_measure, ava_count 
        FROM groceries {'JOIN suppliers_groc USING(groc_id) ' if supplied_only else ' '}
        WHERE groc_name LIKE '%{like}%'
        ORDER BY groc_name ASC
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
    # print(filter_sort_data)
    return dumps(filter_sort_data, indent=4, use_decimal=True)


@app.route("/restaurant/v1/supplys", methods=['POST'])
def add_supply():
    cur: CMySQLCursor = con.cursor()
    # pprint(request.json)
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

    price_from = request.args.get('price_from', None)
    price_to = request.args.get('price_to', None)
    sort_column = request.args.get('sort_column')
    asc = request.args.get('asc')
    groceries = db_utils.decode_query_array(request.args.get('groceries'), is_tuple=True, is_int=True)
    # groceries = request.args.get('groceries')
    groups = db_utils.decode_query_array(request.args.get('groups'), is_tuple=True, is_int=True)
    if len(groups) == 1:
        groups = f'({groups[0]})'

    # cur.execute(f"""SELECT groc_id FROM groceries""")
    # all_groc = srv.powerset(tuple(i[0] for i in cur.fetchall()))

    cur.execute(f"""
        SELECT DISTINCT d.dish_id, d.dish_name, d.dish_price, d.dish_gr_id, d.dish_photo_index, d.dish_descr
        FROM dishes d {'JOIN dish_consists dc USING(dish_id)' if len(groceries) > 0 else ''}
        WHERE 42 = 42
            {f" AND d.dish_price >= {price_from} AND d.dish_price <= {price_to}" if len(price_from) and len(price_to) else ''}
            {f' AND d.dish_gr_id IN {groups}' if len(groups) > 0 else ''}
            {f'AND dc.groc_id IN {groceries}' if len(groceries) > 0 else ''}
        ORDER BY d.{sort_column} {asc.upper()}
    """)
    {f'''
               AND ({" OR ".join(list(map(lambda x: f' {x} IN (SELECT dc.groc_id FROM dish_consists dc WHERE dc.dish_id = d.dish_id) ', groceries)))})
            ''' if len(groceries) > 0 else ''}
    """
    AND 1 IN (select dc.groc_id ...) OR 2 IN (select dc.groc_id ...) OR 3 IN (select dc.groc_id ...)
    """
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

    filter_sort_data = cur_to_dict(cur)[0]      # УБРАТЬ ЭТО НУЖНО потом
    # print(dumps(
    #     {
    #         'dishes' : dishes, 
    #         'groups' : groups, 
    #         'filter_sort_data': filter_sort_data
    #     }, 
    #     indent=4
    # ))
    cur.close()
    return dumps(
        {
            'dishes' : dishes, 
            'groups' : groups, 
            'filter_sort_data': filter_sort_data
        }, 
        indent=4
    )


@app.route('/restaurant/v1/menu/filter-sort', methods=['GET'])
def get_menu_filter_sort():
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT MIN(dish_price) AS min_price, MAX(dish_price) AS max_price
        FROM dishes
    """)

    filter_sort_data = cur_to_dict(cur)[0]

    cur.close()
    return dumps(filter_sort_data, indent=4)


@app.route('/restaurant/v1/menu', methods=['POST'])
def add_dish():
    cur: CMySQLCursor = con.cursor()

    groceries = request.json['consist']

    # с процедурами не работает cur.lastrowid
    cur.execute(f"""
        INSERT INTO dishes(dish_name, dish_price, dish_gr_id, dish_descr)
        VALUES (
            '{request.json['dish_name']}',
            {request.json['dish_price']},
            {request.json['dish_gr_id']},
            '{request.json['dish_descr']}'
        );
    """)
    dish_id = cur.lastrowid
    con.commit()
    photo = request.json.get('photo', None)

    if photo != None:
        db_utils.save_dish_image(photo, dish_id)
        cur.execute(f"""
            UPDATE dishes SET dish_photo_index = {dish_id} WHERE dish_id = {dish_id}
        """)
        con.commit()

    for groc in groceries:
        cur.execute(f"""
            CALL add_grocery_to_certain_dish(
                {dish_id},
                {groc['groc_id']},
                {groc['groc_count']}
            )
        """)
        con.commit()

    cur.close()
    return 'success'


@app.route('/restaurant/v1/menu', methods=['PUT'])
def update_dish():
    cur: CMySQLCursor = con.cursor()
    
    photo = request.json.get('photo', None)
    # print(photo, type(photo))
    dish_photo_index = request.json.get('dish_photo_index')
    dish_id = request.json.get('dish_id')
    dish_name = request.json.get('dish_name')
    dish_price = request.json.get('dish_price')
    dish_gr_id = request.json.get('dish_gr_id')
    consist = request.json.get('consist')
    dish_descr = request.json.get('dish_descr')

    if photo != None:
        db_utils.save_dish_image(photo, dish_id)
    # print(str(dish_descr) + "MAMBA")
    cur.execute(f"""
        UPDATE dishes
        SET dish_name = "{dish_name}",
            dish_price = {dish_price},
            dish_gr_id = {dish_gr_id},
            dish_photo_index = {dish_photo_index},
            dish_descr = "{dish_descr}"
        WHERE dish_id = {dish_id};
    """)
    con.commit()
    cur.execute(f"""
        DELETE FROM dish_consists
        WHERE dish_id = {dish_id}
    """)
    con.commit()

    sql = "INSERT INTO dish_consists(dish_id, groc_id, dc_count) VALUES "

    for groc in consist:
        sql += str((dish_id, groc['groc_id'], groc['groc_count'])) + ', '
    sql = sql[:-2]

    cur.execute(sql)
    con.commit()

    cur.close()
    return 'success'


@app.route('/restaurant/v1/menu/add-dish-group', methods=['POST'])
def add_dish_group():
    cur : CMySQLCursor = con.cursor()

    name = request.json['name']

    cur.execute(f'INSERT INTO dish_groups(dish_gr_name) VALUES (\'{name}\')')
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
    groc_id_count = db_utils.decode_query_list_of_dict(groc_ids, 'groc_id', 'groc_count')
    
    prime_cost = {'consist' : [], 'total': 0}

    for groc in groc_id_count:
        # print(groc)
        # CALL get_min_groc_price({groc_id}) # ---> не работает...
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
        grocery['groc_count'] = float(groc['groc_count'])
        grocery['groc_total'] = float(grocery['min_price']) * float(groc['groc_count'])
        prime_cost['total'] += grocery['groc_total']
        prime_cost['consist'].append(grocery)

    # print(dumps(prime_cost, indent=2))
    cur.close()
    return dumps(prime_cost, indent=2)

######################################################################################
###########################-|| E M P L O Y E E S ||-##################################
######################################################################################


@app.route('/restaurant/v1/roles', methods=['POST'])
def add_role():
    cur: CMySQLCursor = con.cursor()

    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    cur.execute(f"""
        INSERT INTO roles(role_name, salary_per_hour)
        VALUES ('{role_name}', {salary_per_hour})
    """)
    con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/roles', methods=['PUT'])
def update_role():
    cur: CMySQLCursor = con.cursor()

    role_id = request.json['role_id']
    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    # print(request.json)

    cur.execute(f"""
        UPDATE roles 
        SET role_name = '{role_name}', 
            salary_per_hour = {salary_per_hour}
        WHERE role_id = {role_id}
    """)
    con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/roles', methods=['GET'])
def get_roles(serialize=True):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT r.role_id, r.role_name, r.salary_per_hour
        FROM roles r
    """)

    roles = cur_to_dict(cur)

    cur.close()
    return dumps(roles, indent=4) if serialize else roles

@app.route('/restaurant/v1/roles/<int:role_id>', methods=['DELETE'])
def delete_role(role_id):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        DELETE FROM roles WHERE role_id = {role_id}
    """)
    con.commit()

    cur.close()
    return 'success'





@app.route('/restaurant/v1/employees', methods=['POST'])
def add_employee():
    cur: CMySQLCursor = con.cursor()

    role_id = request.json['role_id']
    is_waiter = request.json['is_waiter']
    emp_fname = request.json['emp_fname'] # str 
    emp_lname = request.json['emp_lname'] # str
    birthday = request.json['birthday'] # 2000-01-20
    phone = request.json['phone'] # str
    email = request.json['email'] # str
    gender = request.json['gender'] # str 'm' | 'f'
    hours_per_month = request.json['hours_per_month'] # int

    cur.execute(f"""
        INSERT INTO employees(role_id, is_waiter, emp_fname, emp_lname, birthday, phone, email, gender, hours_per_month) 
        VALUES ({role_id}, {is_waiter}, '{emp_fname}', '{emp_lname}', DATE('{birthday}'), '{phone}', '{email}', '{gender}', {hours_per_month})
    """)
    con.commit()
    cur.close()
    return 'success'

@app.route('/restaurant/v1/employees', methods=['PUT'])
def update_employee():
    cur: CMySQLCursor = con.cursor()

    emp_id = request.json['emp_id']
    role_id = request.json['role_id']
    is_waiter = request.json['is_waiter']
    emp_fname = request.json['emp_fname'] # str 
    emp_lname = request.json['emp_lname'] # str
    birthday = request.json['birthday'] # 2000-01-20
    phone = request.json['phone'] # str
    email = request.json['email'] # str
    gender = request.json['gender'] # str 'm' | 'f'
    hours_per_month = request.json['hours_per_month'] # int

    cur.execute(f"""
        UPDATE employees
        SET role_id = {role_id},
            emp_fname = '{emp_fname}',
            is_waiter = {is_waiter},
            emp_lname = '{emp_lname}',
            birthday = DATE('{birthday}'),
            phone = '{phone}',
            email = '{email}',
            gender = '{gender}',
            hours_per_month = {hours_per_month}
        WHERE emp_id = {emp_id}
    """)
    con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/employees/<int:emp_id>', methods=['DELETE'])
def delete_employee(emp_id):
    """удалит всё нахрен. Работника не существовало"""
    cur: CMySQLCursor = con.cursor()

    

    cur.close()
    return 'success'


@app.route('/restaurant/v1/employees', methods=['GET'])
def get_employees(serialize=True):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT COALESCE(MIN(hours_per_month), CURDATE()) as hours_per_month_from,
            COALESCE(MAX(hours_per_month), CURDATE()) as hours_per_month_to,
            COALESCE(MIN(birthday), CURDATE()) as birthday_from,
            COALESCE(MAX(birthday), CURDATE()) as birthday_to
        FROM employees
    """)

    filter_sort_data = cur_to_dict(cur)[0]
    filter_sort_data['gender'] = 'fm'
    filter_sort_data['sort_column'] = 'emp_fname' # | 'emp_lname' | 'birthday' | 'hours_per_month'
    filter_sort_data['asc'] = 'asc'
    
    hours_per_month_from = request.args.get('hours_per_month_from', filter_sort_data['hours_per_month_from'])
    hours_per_month_to = request.args.get('hours_per_month_to', filter_sort_data['hours_per_month_to'])
    birthday_from = request.args.get('birthday_from', filter_sort_data['birthday_from'])
    birthday_to = request.args.get('birthday_to', filter_sort_data['birthday_to'])
    gender = tuple(filter_sort_data['gender'] if request.args.get('gender') == None or len(request.args.get('gender')) == 0 else request.args.get('gender'))
    sort_column = request.args.get('sort_column', filter_sort_data['sort_column'])
    asc = request.args.get('asc', filter_sort_data['asc'])
    roles = q_utils.decode_query_array(request.args.get('roles', '') if request.args.get('roles') and len(request.args.get('roles')) > 0 else '', is_tuple=True, is_int=True)

    # print(f'AND role_id IN {str(roles)[0:-2] + ")"} ' if len(roles) > 0 else '', "gogog")

    cur.execute(f"""
        SELECT is_waiter, emp_id, role_id, emp_fname, emp_lname, birthday, phone, email, gender, hours_per_month
        FROM employees
        WHERE (hours_per_month BETWEEN {hours_per_month_from} AND {hours_per_month_to}) 
            AND (birthday BETWEEN DATE('{birthday_from}') AND DATE('{birthday_to}')) 
            AND gender IN {gender}
            {f'AND role_id IN {q_utils.tuple_to_mysql_str(roles)} ' if len(roles) > 0 else ''}
        ORDER BY {sort_column} {asc}
    """)
    
    employees = cur_to_dict(cur)

    res = {'employees': employees, 'filter_sort_data': filter_sort_data}

    cur.close()
    return dumps(res, indent=4) if serialize else res


@app.route('/restaurant/v1/roles/employees', methods=['GET'])
def get_roles_and_employees():
    return dumps({
        **get_employees(serialize=False),
        'roles': get_roles(serialize=False),
        'diary': get_diary(serialize=False)
    }, indent=4)


@app.route('/restaurant/v1/diary/start/<int:emp_id>', methods=['POST'])
def employee_comes(emp_id):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        INSERT INTO diary(emp_id) VALUES ({emp_id})
    """)
    con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/diary/gone/<int:emp_id>', methods=['PUT'])
def employee_has_gone(emp_id):  
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        UPDATE diary 
        SET end_time = TIME(NOW()),
            gone = 1
        WHERE gone = 0 AND emp_id = {emp_id}
    """)

    cur.close()
    return 'success'

@app.route('/restaurant/v1/diary', methods=['GET'])
def get_diary(serialize=True):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT d.d_id, 
            d.date_, 
            d.emp_id, 
            d.start_time, 
            d.end_time, 
            d.gone, 
            CONCAT(e.emp_lname, " ", e.emp_fname) as emp_name
        FROM diary d JOIN employees e USING(emp_id)
    """)

    diary = cur_to_dict(cur)
    # print(diary)
    

    cur.close()
    return dumps(diary, indent=4) if serialize else diary

@app.route('/restaurant/v1/diary/<int:d_id>', methods=['DELETE'])
def delete_diary(d_id):
    cur: CMySQLCursor = con.cursor()
    
    cur.execute(f"""
        DELETE FROM diary WHERE d_id = {d_id}
    """)
    con.commit()

    cur.close()
    return 'success'




@app.route('/restaurant/v1/orders', methods=['POST'])
def add_order():
    cur: CMySQLCursor = con.cursor()

    emp_id = request.json.get('emp_id')
    comm = request.json.get('comm')
    list_orders = request.json.get('list_orders')

    cur.execute(f"""
        INSERT INTO orders(emp_id, comm) VALUES ({emp_id}, "{comm}")
    """)
    ord_id = cur.lastrowid
    con.commit()

    for order_node in list_orders:
        cur.execute(f"""
            INSERT INTO list_orders(ord_id, dish_id, lord_count, lord_price)
            VALUES (
                {ord_id},
                {order_node['dish_id']},
                {order_node['count']},
                {order_node['price']}
            )
        """)
        con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/orders/<int:ord_id>', methods=['DELETE'])
def delete_order(ord_id):
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        DELETE FROM orders WHERE ord_id = {ord_id}
    """)
    con.commit()

    cur.close()
    return 'success'

@app.route('/restaurant/v1/orders', methods=['GET'])
def get_orders():
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        SELECT d.dish_id, d.dish_name, d.dish_price, d.dish_gr_id, d.dish_photo_index, d.dish_descr
        FROM dishes d
    """)
    dishes = cur_to_dict(cur)

    cur.execute(f"""
        SELECT o.ord_id, 
            o.ord_date, 
            o.ord_start_time, 
            o.ord_end_time, 
            o.money_from_customer, 
            o.emp_id, 
            (SELECT CONCAT(emp_fname, ' ', emp_lname)
             FROM employees e
             WHERE e.emp_id = o.emp_id) as emp_name,
            o.comm, 
            (SELECT SUM(lord_price) 
             FROM list_orders lo 
             WHERE lo.ord_id = o.ord_id) as total_price,
            o.is_end
        FROM orders o
    """)
    orders = cur_to_dict(cur)

    for order in orders:
        cur.execute(f"""
            SELECT dish_id, lord_count, lord_price
            FROM list_orders
            WHERE ord_id = {order['ord_id']}
        """)

        list_orders = cur_to_dict(cur)

        for order_node in list_orders:
            order_node['dish'] = list(filter(lambda x: x['dish_id'] == order_node['dish_id'], dishes))[0]
            del order_node['dish_id']

        order['list_orders'] = list_orders
    
    return dumps(orders, indent=4)


@app.route('/restaurant/v1/orders/pay', methods=['PUT'])
def pay_order():
    cur: CMySQLCursor = con.cursor()

    money_from_customer = request.args.get('money_from_customer')
    ord_id = request.args.get('ord_id')

    cur.execute(f"""
        UPDATE orders
        SET money_from_customer = {money_from_customer},
            is_end = 1,
            ord_end_time = parseISO(NOW())
        WHERE ord_id = {ord_id}
    """)
    con.commit()

    cur.close()
    return 'success'


@app.route('/restaurant/v1/stats', methods=['GET'])
def get_stats(serialize=True):
    cur: CMySQLCursor = con.cursor()
    
    cur.execute(f"""
        SELECT COALESCE(MIN(ord_start_time), CURDATE()) AS from_base, COALESCE(MAX(ord_start_time), CURDATE()) AS to_base
        FROM orders
    """)

    filter_sort_data = cur_to_dict(cur)[0]
    filter_sort_data['group'] = 'DAY'
    filter_sort_data['dish_from'] = filter_sort_data['from_base']
    filter_sort_data['dish_to'] = filter_sort_data['to_base']
    filter_sort_data['ord_from'] = filter_sort_data['from_base']
    filter_sort_data['ord_to'] = filter_sort_data['to_base']

    ord_from = request.args.get('ord_from', filter_sort_data['ord_from']).rstrip('.000')
    ord_to = request.args.get('ord_to', filter_sort_data['ord_to']).rstrip('.000')
    dish_from = request.args.get('dish_from', filter_sort_data['dish_from']).rstrip('.000')
    dish_to = request.args.get('dish_to', filter_sort_data['dish_to']).rstrip('.000')
    group = request.args.get('group', filter_sort_data['group'])

    cur.execute(f"""
        SELECT ord_start_time, COUNT(ord_id) AS `count`
        FROM orders
        WHERE ord_start_time BETWEEN parseISO('{ord_from}') AND parseISO('{ord_to}')
        GROUP BY {group}(ord_start_time)
    """)

    ord_per_period = cur_to_dict(cur)

    cur.execute(f"""
        SELECT lo.dish_id, d.dish_name, COUNT(lo.dish_id) AS count
        FROM list_orders lo
            JOIN dishes d USING(DISH_ID) 
            JOIN orders o USING(ord_id)
        WHERE o.ord_start_time BETWEEN parseISO('{dish_from}') AND parseISO('{dish_to}')
        GROUP BY lo.dish_id
        ORDER BY count DESC
    """)

    dish_per_period = cur_to_dict(cur)

    cur.execute(f"""
        SELECT d.emp_id, 
            CONCAT(e.emp_fname, e.emp_lname) AS emp_name, 
            SUM(TIMESTAMPDIFF(HOUR, d.start_time, d.end_time)) AS worked,
            e.hours_per_month
        FROM diary d JOIN employees e USING(emp_id)
        GROUP BY emp_id
    """)

    emp_worked = cur_to_dict(cur)

    res = {
        'filter_sort_stats': filter_sort_data,
        'stats_data': {
            'ord_per_period': ord_per_period,
            'dish_per_period': dish_per_period,
            'emp_worked': emp_worked
        }
    }

    cur.close()
    return dumps(res, indent=4) if serialize else res


if __name__ == '__main__':
    app.run()