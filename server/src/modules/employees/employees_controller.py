from flask import request, Blueprint
# from mysql.connector.cursor_cext impor
from mysql.connector.cursor import MySQLCursor
from simplejson import dumps

# from ...utils import database as db_utils
from ...utils import query as q_utils
from ...utils.database import cur_to_dict
from ...database import con


bp = Blueprint('employees', __name__, url_prefix="/employees")

@bp.post('/')
def add_employee():
    cur = con.cursor()

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

@bp.put('/')
def update_employee():
    cur = con.cursor()

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

@bp.delete('/<int:emp_id>')
def delete_employee(emp_id):
    """удалит всё нахрен. Работника не существовало"""
    cur = con.cursor()

    

    cur.close()
    return 'success'


@bp.get('/')
def get_employees(serialize=True):
    cur = con.cursor()

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
