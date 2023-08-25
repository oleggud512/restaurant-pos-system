from collections import namedtuple
from flask import Blueprint, jsonify, request
from simplejson import dumps
from mysql.connector.cursor_cext import CMySQLCursorDict, CMySQLCursor
from ...utils.database import cur_to_dict

from ...database import Db

bp = Blueprint('stats', __name__, url_prefix='/stats')


Defaults = namedtuple('Defaults', ['dish_from', 'dish_to', 'ord_from', 'ord_to', 'group'])

def get_filtering_defaults(cur: CMySQLCursorDict) -> Defaults:
    # get filtering default values (oldest order datetime and newest order datetime)
    cur.execute(f"""
        SELECT COALESCE(MIN(ord_start_time), CURDATE()) AS oldest, 
                COALESCE(MAX(ord_start_time), CURDATE()) AS newest
        FROM orders
    """)

    order_time_bounds = Db.fetch(cur)[0]

    defaults = Defaults(
        group='DAY',# HOUR | MONTH | YEAR
        dish_from=str(order_time_bounds['oldest']), 
        dish_to=str(order_time_bounds['newest']),
        ord_from=str(order_time_bounds['oldest']), 
        ord_to=str(order_time_bounds['newest']),
    )
    return defaults

@bp.get('/')
def get_stats(serialize=True):
    cur: CMySQLCursor = Db.cur()
    
    defaults = get_filtering_defaults(cur)
    
    ### getting filter properties from request body. If there is no value - use default one. 
    # getting a group
    group = request.args.get('group', defaults.group) 

    # getting order bounds
    ord_from = str(request.args.get('ord_from', defaults.ord_from)).rstrip('.000')
    ord_to = str(request.args.get('ord_to', defaults.ord_to)).rstrip('.000')

    # getting dish bounds
    dish_from = str(request.args.get('dish_from', defaults.dish_from)).rstrip('.000')
    dish_to = str(request.args.get('dish_to', defaults.dish_to)).rstrip('.000')

    # select the number of orders in the group and the first order datetime
    # in the bounds of ord_from ord_to
    cur.execute(f"""
        SELECT MIN(ord_start_time) as `ord_start_time`, COUNT(ord_id) AS `count`
        FROM orders
        WHERE ord_start_time BETWEEN parseISO('{ord_from}') AND parseISO('{ord_to}')
        GROUP BY {group}(ord_start_time)
    """)

    orders_number_per_period = Db.fetch(cur)

    # how many dishes have been sold in some period
    cur.execute(f"""
        SELECT lo.dish_id, d.dish_name, COUNT(lo.dish_id) AS count
        FROM list_orders lo
            JOIN dishes d USING(DISH_ID) 
            JOIN orders o USING(ord_id)
        WHERE o.ord_start_time BETWEEN parseISO('{dish_from}') AND parseISO('{dish_to}')
        GROUP BY lo.dish_id
        ORDER BY count DESC
    """)

    dishes_sold_per_period = Db.fetch(cur)


    cur.execute(f"""
        SELECT d.emp_id, 
            -- just get the name
            CONCAT(e.emp_fname, e.emp_lname) AS emp_name,
            
            -- the number of hours worked at all??? (not per month???)
            SUM(TIMESTAMPDIFF(HOUR, d.start_time, d.end_time)) AS worked, 
            
            -- how many they need to work
            e.hours_per_month
        FROM diary d JOIN employees e USING(emp_id)
        GROUP BY emp_id
    """)

    emp_worked = Db.fetch(cur)
    res = {
        'filtering_defaults': defaults._asdict(),
        'stats_data': {
            'ord_per_period': orders_number_per_period,
            'dish_per_period': dishes_sold_per_period,
            'emp_worked': emp_worked
        }
    }

    cur.close()
    return jsonify(res) if serialize else res