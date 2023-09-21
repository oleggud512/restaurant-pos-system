from collections import namedtuple
from datetime import datetime
from typing import Any

from flask import jsonify
from mysql.connector.cursor_cext import CMySQLCursorDict

from .entities.employee import Employee
from .entities.employees_filter_data import EmployeesFilters
from .entities.employees_response import EmployeesResponse
from ...utils import query as q_utils
from ...utils import database as db_utils

from src.database import Db


def get_employees_filter_defaults(cur: CMySQLCursorDict) -> EmployeesFilters:
    cur.execute(f"""
        SELECT MIN(hours_per_month) as hours_per_month_from,
            MAX(hours_per_month) as hours_per_month_to,
            COALESCE(MIN(birthday), CURDATE()) as birthday_from, -- COALESCE - null checking
            COALESCE(MAX(birthday), CURDATE()) as birthday_to
        FROM employees
    """)

    filtering_bounds = Db.fetch(cur)[0]

    return EmployeesFilters(
        hours_per_month_from=filtering_bounds['hours_per_month_from'] or 0,
        hours_per_month_to=filtering_bounds['hours_per_month_to'] or 0,
        birthday_from=filtering_bounds['birthday_from'] or datetime.min,
        birthday_to=filtering_bounds['birthday_to'] or datetime.max,
        gender='fm',
        sort_column='emp_fname',  # | 'emp_lname' | 'birthday' | 'hours_per_month'
        asc='asc'
    )


def get_employees_data(args: dict[str, str], cur: CMySQLCursorDict) \
        -> EmployeesResponse:
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
        SELECT 
            is_waiter, 
            emp_id, 
            role_id, 
            emp_fname, 
            emp_lname, 
            birthday, 
            phone, 
            email, 
            gender, 
            hours_per_month
        FROM employees
        WHERE (hours_per_month BETWEEN 
                {hours_per_month_from} AND {hours_per_month_to}) 
            AND (birthday BETWEEN 
                DATE('{birthday_from}') AND DATE('{birthday_to}')) 
            AND gender IN {gender}
            {f'AND role_id IN {db_utils.tuple_to_mysql_str(roles)} ' 
            if len(roles) > 0 
            else ''}
        ORDER BY {sort_column} {asc}
    """)

    employees = Db.fetch(cur)

    res = EmployeesResponse(
        employees=Employee.from_list(employees),
        filter_sort_data=defaults
    )

    print(res)

    return res
