from flask import Blueprint, request
from simplejson import dumps

from ...utils.database import cur_to_dict
from ...database import con

bp = Blueprint('supplys', __name__, url_prefix='/supplys')

# @bp.get("/<int:supply_id>")
@bp.get("/")
def get_supplys(
    # supply_id=None
):
    cur = con.cursor()
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


@bp.get("/filter_sort")
def filter_sort():
    cur = con.cursor()
    
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


@bp.post("/")
def add_supply():
    cur = con.cursor()
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


@bp.post("/<int:supply_id>")
def delete_supply(supply_id):
    cur = con.cursor()
    cur.execute(f'CALL delete_supply({supply_id})')
    con.commit()
    cur.close()
    return 'success'