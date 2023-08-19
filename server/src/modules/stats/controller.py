from flask import Blueprint, request
from simplejson import dumps

from ...utils.database import cur_to_dict

from ...database import con

bp = Blueprint('stats', __name__, url_prefix='/stats')

@bp.get('/')
def get_stats(serialize=True):
    cur = con.cursor()
    
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