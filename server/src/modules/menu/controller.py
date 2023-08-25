from flask import Blueprint, request
from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps

from ...utils.database import cur_to_dict
from ...utils import database as db_utils
from ...utils import query as q_utils

from ...database import Db

bp = Blueprint('menu', __name__, url_prefix='/menu')

@bp.get('/')
def get_menu():
    cur: CMySQLCursor = Db.cur()

    price_from = request.args.get('price_from', None)
    price_to = request.args.get('price_to', None)
    sort_column = request.args.get('sort_column')
    asc = request.args.get('asc') or 'ASC' # | DESC
    groceries = q_utils.decode_query_array(str(request.args.get('groceries')), is_tuple=True, is_int=True)
    # groceries = request.args.get('groceries')
    groups = q_utils.decode_query_array(str(request.args.get('groups')), is_tuple=True, is_int=True)
    if len(groups) == 1:
        groups = f'({groups[0]})'

    # cur.execute(f"""SELECT groc_id FROM groceries""")
    # all_groc = srv.powerset(tuple(i[0] for i in cur.fetchall()))

    cur.execute(f"""
        SELECT DISTINCT d.dish_id, d.dish_name, d.dish_price, d.dish_gr_id, d.dish_photo_index, d.dish_descr
        FROM dishes d {'JOIN dish_consists dc USING(dish_id)' if len(groceries) > 0 else ''}
        WHERE 42 = 42
            {f" AND d.dish_price >= {price_from} AND d.dish_price <= {price_to}" if price_from and price_to else ''}
            {f' AND d.dish_gr_id IN {groups}' if len(groups) > 0 else ''}
            {f'AND dc.groc_id IN {groceries}' if len(groceries) > 0 else ''}
        ORDER BY d.{sort_column} {asc.upper()}
    """)
    # {f'''
    #            AND ({" OR ".join(list(map(lambda x: f' {x} IN (SELECT dc.groc_id FROM dish_consists dc WHERE dc.dish_id = d.dish_id) ', groceries)))})
    #         ''' if len(groceries) > 0 else ''}
    # """
    # AND 1 IN (select dc.groc_id ...) OR 2 IN (select dc.groc_id ...) OR 3 IN (select dc.groc_id ...)
    # """
    dishes = Db.fetch(cur)

    cur.execute(f"""
        SELECT dc.groc_id, g.groc_name, dc.dc_count, dc.dish_id
        FROM dish_consists dc JOIN groceries g USING(groc_id)
    """)

    groceries = Db.fetch(cur)

    for dish in dishes:
        dish['consist'] = list(filter(lambda x: dish['dish_id'] == x['dish_id'], groceries))

    cur.execute(f"""
        SELECT dish_gr_id, dish_gr_name FROM dish_groups
    """)

    groups = Db.fetch(cur)

    cur.execute(f"""
        SELECT MIN(dish_price) AS min_price, MAX(dish_price) AS max_price
        FROM dishes
    """)

    filter_sort_data = Db.fetch(cur)[0]      # УБРАТЬ ЭТО НУЖНО потом
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


@bp.get('/filter-sort')
def get_menu_filter_sort():
    cur: CMySQLCursor = Db.cur()

    cur.execute(f"""
        SELECT MIN(dish_price) AS min_price, MAX(dish_price) AS max_price
        FROM dishes
    """)

    filter_sort_data = Db.fetch(cur)[0]

    cur.close()
    return dumps(filter_sort_data, indent=4)


@bp.post('/')
def add_dish():
    cur: CMySQLCursor = Db.cur()

    if not request.json: return 'error'
    
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
    Db.commit()
    photo = request.json.get('photo', None)

    if photo != None:
        db_utils.save_dish_image(photo, dish_id)
        cur.execute(f"""
            UPDATE dishes SET dish_photo_index = {dish_id} WHERE dish_id = {dish_id}
        """)
        Db.commit()

    for groc in groceries:
        cur.execute(f"""
            CALL add_grocery_to_certain_dish(
                {dish_id},
                {groc['groc_id']},
                {groc['groc_count']}
            )
        """)
        Db.commit()

    cur.close()
    return 'success'


@bp.put('/')
def update_dish():
    cur: CMySQLCursor = Db.cur()
    
    if not request.json: return 'error'
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
    Db.commit()
    cur.execute(f"""
        DELETE FROM dish_consists
        WHERE dish_id = {dish_id}
    """)
    Db.commit()

    sql = "INSERT INTO dish_consists(dish_id, groc_id, dc_count) VALUES "

    for groc in consist:
        sql += str((dish_id, groc['groc_id'], groc['groc_count'])) + ', '
    sql = sql[:-2]

    cur.execute(sql)
    Db.commit()

    cur.close()
    return 'success'


@bp.post('/add-dish-group')
def add_dish_group():
    cur = Db.cur()

    if not request.json: return 'error'

    name = request.json['name']

    if not name: return 'error'

    cur.execute(f'INSERT INTO dish_groups(dish_gr_name) VALUES (\'{name}\')')
    Db.commit()

    cur.close()
    return 'success'


@bp.get('/prime-cost/<string:groc_ids>')
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
    cur: CMySQLCursor = Db.cur()
    groc_id_count = q_utils.decode_query_list_of_dict(groc_ids, 'groc_id', 'groc_count')
    
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
        grocery = Db.fetch(cur)[0]

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