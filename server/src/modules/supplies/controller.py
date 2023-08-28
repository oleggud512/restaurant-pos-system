from flask import Blueprint, Response, jsonify, request, abort
from simplejson import dumps

from ...utils.database import cur_to_dict
from ...utils.query import decode_query_array
from ...database import Db

bp = Blueprint('supplys', __name__, url_prefix='/supplys')

# @bp.get("/<int:supply_id>")
@bp.get("/")
def get_supplys(
    # supply_id=None
):
    cur = Db.cur()
    
    sort_collumn = request.args['sort_collumn']
    sort_direction = request.args['sort_direction']
    price_from = request.args['price_from']
    price_to = request.args['price_to']
    date_from = request.args['date_from']
    date_to = request.args['date_to']

    suppliers = decode_query_array(
        string=request.args['suppliers'], 
        is_int=True, 
        is_tuple=True
    )

    suppliers_str = ''
    if not suppliers: suppliers_str = '(0)'
    elif len(suppliers) == 1: suppliers_str = f'(${suppliers[0]})'
    else: suppliers_str = str(suppliers)

    sql = f"""
        SELECT supply_id, supply_date, supplier_id, supplier_name, summ 
        FROM supply_view 
        WHERE supply_date >= DATE(%s) 
            AND supply_date <= DATE(%s)
            AND summ >= %s
            AND summ <= %s
            AND supplier_id IN {suppliers_str}
        ORDER BY {sort_collumn} {sort_direction}
    """

    cur.execute(sql, [
        date_from, 
        date_to, 
        price_from, 
        price_to,
    ])

    supplys = Db.fetch(cur)

    cur.execute(f"""
        SELECT supply_id, groc_id, groc_count, groc_name, groc_price
        FROM supply_groceries_view
    """)

    groceries = Db.fetch(cur)
    
    for supply in supplys: # присваивание поставкам их продуктов, указаных в list_supplys
        supply['groceries'] = [groc for groc in groceries if groc['supply_id'] == supply['supply_id']]

    return jsonify(dumps(supplys, indent=4, use_decimal=True, default=str))


@bp.get("/filter_sort")
def filter_sort():
    cur = Db.cur()
    
    cur.execute("""
        SELECT max_date, max_summ, min_date
        FROM max_values_view
    """)
    
    filter_sort_data = Db.fetch(cur)[0]

    cur.execute("""
        SELECT supplier_id, supplier_name
        FROM mini_suppliers_view
    """)

    filter_sort_data["suppliers"] = Db.fetch(cur)
    return jsonify(dumps(filter_sort_data, indent=4, use_decimal=True, default=str))


@bp.post("/")
def add_supply():
    cur = Db.cur()
    print(request.json)
    if not request.json \
        or not request.json['supplier_id'] \
        or not request.json['groceries'] \
        or not all(map(lambda g: g['groc_id'] and g['groc_count'], list(request.json['groceries']))): abort(400)
    
    cur.execute(f"""
        INSERT INTO supplys(supplier_id) 
        VALUES ({request.json['supplier_id']})
    """)
    supply_id = cur.lastrowid
    Db.con.commit()

    for groc in request.json['groceries']:
        # TODO: (1) make this function increase the overall summ of the supply
        cur.execute(f"""
            CALL add_grocery_to_certain_supply(
                {supply_id}, 
                {groc['groc_id']}, 
                {groc['groc_count']}
            )
        """)
        Db.con.commit()

    cur.close()
    return 'success'


@bp.post("/<int:supply_id>")
def delete_supply(supply_id):
    cur = Db.cur()
    cur.execute(f'CALL delete_supply({supply_id})')
    Db.con.commit()
    cur.close()
    return 'success'