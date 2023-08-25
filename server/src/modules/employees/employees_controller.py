from collections import namedtuple
from datetime import datetime
from typing import Any
from flask import request, Blueprint
# from mysql.connector.cursor_cext impor
from mysql.connector.cursor_cext import CMySQLCursorDict
from simplejson import dumps

# from ...utils import database as db_utils
from ...utils import query as q_utils
from ...utils import database as db_utils
from ...utils.database import cur_to_dict
from ...database import Db


bp = Blueprint('employees', __name__, url_prefix="/employees")

@bp.post('/')
def add_employee():
    cur = Db.cur()

    if not request.json: return 'error'

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
    Db.commit()
    cur.close()
    return 'success'

@bp.put('/')
def update_employee():
    cur = Db.cur()

    if not request.json: return 'error'

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
    Db.commit()

    cur.close()
    return 'success'

@bp.delete('/<int:emp_id>')
def delete_employee(emp_id):
    """удалит всё нахрен. Работника не существовало"""
    cur = Db.cur()

    # TODO: хмм... А чего тут ничего нет?

    cur.close()
    return 'success'

EmployeesFilterDefaults = namedtuple(
    typename='EmployeesFilterDefaults', 
    field_names=[
        'hours_per_month_from', 
        'hours_per_month_to', 
        'birthday_from', 
        'birthday_to',
        'gender',
        'sort_column',
        'asc'
    ]
)

def get_employees_filter_defaults(cur: CMySQLCursorDict) -> EmployeesFilterDefaults:
    cur.execute(f"""
        SELECT MIN(hours_per_month) as hours_per_month_from,
            MAX(hours_per_month) as hours_per_month_to,
            COALESCE(MIN(birthday), CURDATE()) as birthday_from, -- COALESCE - null checking
            COALESCE(MAX(birthday), CURDATE()) as birthday_to
        FROM employees
    """)

    filtering_bounds = Db.fetch(cur)[0]

    return EmployeesFilterDefaults(
        hours_per_month_from=filtering_bounds['hours_per_month_from'] or 0,
        hours_per_month_to=filtering_bounds['hours_per_month_to'] or 0,
        birthday_from=filtering_bounds['birthday_from'] or datetime.min,
        birthday_to=filtering_bounds['birthday_to'] or datetime.max,
        gender='fm',
        sort_column='emp_fname', # | 'emp_lname' | 'birthday' | 'hours_per_month'
        asc='asc'
    )

def get_employees_data(args: dict[str, str], cur: CMySQLCursorDict) -> dict[str, Any]:
    cur = Db.cur()

    defaults = get_employees_filter_defaults(cur)
    
    hours_per_month_from = args.get('hours_per_month_from', defaults.hours_per_month_from)
    hours_per_month_to = args.get('hours_per_month_to', defaults.hours_per_month_to)
    birthday_from = args.get('birthday_from', defaults.birthday_from)
    birthday_to = args.get('birthday_to', defaults.birthday_to)
    gender = tuple(str(args.get('gender', defaults.gender)))
    sort_column = args.get('sort_column', defaults.sort_column)
    asc = args.get('asc', defaults.asc)
    roles = q_utils.decode_query_array(args.get('roles', ''), is_tuple=True, is_int=True)

    # print(f'AND role_id IN {str(roles)[0:-2] + ")"} ' if len(roles) > 0 else '', "gogog")

    cur.execute(f"""
        SELECT is_waiter, emp_id, role_id, emp_fname, emp_lname, birthday, phone, email, gender, hours_per_month
        FROM employees
        WHERE (hours_per_month BETWEEN {hours_per_month_from} AND {hours_per_month_to}) 
            AND (birthday BETWEEN DATE('{birthday_from}') AND DATE('{birthday_to}')) 
            AND gender IN {gender}
            {f'AND role_id IN {db_utils.tuple_to_mysql_str(roles)} ' if len(roles) > 0 else ''}
        ORDER BY {sort_column} {asc}
    """)
    
    employees = Db.fetch(cur)

    
    res = {
        'employees': employees, 
        'filter_sort_data': defaults
    }

    cur.close()
    return res


@bp.get('/')
def get_employees():
    if not request.args: return 'error'

    cur = Db.cur()

    emp = get_employees_data(request.args or {}, cur)

    return dumps(emp, indent=4)
