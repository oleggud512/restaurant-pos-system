from flask import Blueprint, request, jsonify, Response
from simplejson import dumps
from mysql.connector import MySQLConnection

from ...utils import database as db_utils
from ...utils import query as q_utils

from ...database import Db
from ...utils.default_srlz import default_srlz
from ...utils.response_code import ResponseCode

bp = Blueprint('orders', __name__, url_prefix='/orders')


@bp.post('/')
def add_order():
    cur = Db.cur()

    if not request.json:
        return Response('error', ResponseCode.BAD_REQUEST)

    emp_id = request.json.get('emp_id')
    comm = request.json.get('comm')
    list_orders = request.json.get('list_orders')

    cur.execute(f"""
        INSERT INTO orders(emp_id, comm) VALUES (%s, %s)
    """, [
        emp_id,
        comm
    ])
    ord_id = cur.lastrowid
    Db.commit()

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
        Db.commit()

    cur.close()
    return jsonify({
        'ord_id': ord_id
    })


@bp.delete('/<int:ord_id>')
def delete_order(ord_id):
    cur = Db.cur()

    cur.execute("""
        DELETE FROM list_orders WHERE ord_id = %s
    """, [
        ord_id
    ])
    Db.commit()

    cur.execute(f"""
        DELETE FROM orders WHERE ord_id = %s
    """, [
        ord_id
    ])
    Db.commit()

    cur.close()
    return 'success'


@bp.get('/')
def get_orders():
    cur = Db.cur()

    cur.execute(f"""
        SELECT 
            d.dish_id, 
            d.dish_name, 
            d.dish_price, 
            d.dish_gr_id, 
            d.dish_photo_url, 
            d.dish_descr
        FROM dishes d
    """)

    dishes = Db.fetch(cur)

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
            (SELECT SUM(lo.lord_price * lo.lord_count)
             FROM list_orders lo 
             WHERE lo.ord_id = o.ord_id) as total_price,
            o.is_end
        FROM orders o
    """)

    orders = Db.fetch(cur)

    for order in orders:
        cur.execute(f"""
            SELECT 
                dish_id, 
                lord_count, 
                lord_price
            FROM list_orders
            WHERE ord_id = %s
        """, [
            order['ord_id']
        ])

        list_orders = Db.fetch(cur)

        for order_node in list_orders:
            order_node['dish'] = list(filter(
                lambda x: x['dish_id'] == order_node['dish_id'],
                dishes
            ))[0]
            del order_node['dish_id']

        order['list_orders'] = list_orders

    return Response(
        dumps(orders, default=default_srlz),
        mimetype='application/json'
    )


@bp.put('/pay')
def pay_order():
    cur = Db.cur()

    money_from_customer = request.args.get('money_from_customer')
    ord_id = request.args.get('ord_id')

    cur.execute(f"""
        UPDATE orders
        SET money_from_customer = %s,
            is_end = 1,
            ord_end_time = parseISO(NOW())
        WHERE ord_id = %s
    """, [
        money_from_customer,
        ord_id
    ])
    Db.commit()

    cur.close()
    return 'success'
