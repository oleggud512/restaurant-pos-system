from flask import Blueprint, request, Response, jsonify
from flask_cors import cross_origin
from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps

from src.modules.menu.dish import Dish, DishGrocery
from src.utils import database as db_utils
from src.utils import query as q_utils
from src.utils.response_code import ResponseCode

from src.database import Db
from src.utils.wizard_to_dict import wizard_to_dict

bp = Blueprint('menu', __name__, url_prefix='/menu')


@bp.get('/')
def get_dishes():
    cur = Db.cur()

    price_from = request.args.get('price_from', None)
    price_to = request.args.get('price_to', None)
    sort_column = request.args.get('sort_column')
    asc = request.args.get('asc') or 'ASC'  # | DESC

    groceries = q_utils.decode_query_array(request.args.get('groceries'),
                                           is_int=True,
                                           is_tuple=True)

    groups = q_utils.decode_query_array(request.args.get('groups'),
                                        is_int=True,
                                        is_tuple=True)

    if len(groups) == 1:
        groups = f'({groups[0]})'

    # get filtered dishes
    cur.execute(f"""
        SELECT DISTINCT 
            d.dish_id, 
            d.dish_name, 
            d.dish_price, 
            d.dish_gr_id, 
            d.dish_photo_url, 
            d.dish_descr
        FROM dishes d {'JOIN dish_consists dc USING(dish_id)'
                       if len(groceries) > 0
                       else ''}
        WHERE 42 = 42
            {f" AND d.dish_price BETWEEN {price_from} AND {price_to}"
            if price_from and price_to
            else ''}
            {f' AND d.dish_gr_id IN {groups}' if len(groups) > 0 else ''}
            {f'AND dc.groc_id IN {groceries}' if len(groceries) > 0 else ''}
        ORDER BY d.{sort_column} {asc.upper()}
    """)
    dishes = list(map(lambda d: Dish.from_dict(d), Db.fetch(cur)))

    # get groceries for dishes
    cur.execute(f"""
        SELECT 
            dc.groc_id, 
            g.groc_name, 
            dc.dish_id,
            dc.dc_count as groc_count
        FROM dish_consists dc 
            JOIN groceries g USING(groc_id)
    """)

    all_groceries = DishGrocery.from_list(Db.fetch(cur))
    for dish in dishes:
        dish.dish_groceries = list(filter(
            lambda groc: dish.dish_id == groc.dish_id,
            all_groceries
        ))
    cur.close()
    return jsonify(wizard_to_dict(dishes))


def get_dish(dish_id: int) -> Dish:
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
        WHERE d.dish_id = %s
    """, [
        dish_id
    ])
    dish_data = Db.fetch(cur)[0]
    cur.execute("""
        SELECT 
            dc.dish_id,
            dc.groc_id, 
            dc.dc_count as groc_count,
            g.groc_name
        FROM dish_consists dc 
            JOIN groceries g 
            ON dc.groc_id = g.groc_id
        WHERE dc.dish_id = %s
    """, [
        dish_id
    ])
    dish_groceries = Db.fetch(cur)
    dish = Dish.from_dict({
        **dish_data,
        "dish_groceries": dish_groceries
    })
    cur.close()
    return dish


@bp.get('/<int:dish_id>')
def get_dish_route(dish_id: int):
    dish = get_dish(dish_id)
    return jsonify(dish.to_dict())


@bp.get('/filter-sort')
def get_menu_filter_sort():
    cur = Db.cur()

    cur.execute(f"""
        SELECT MIN(dish_price) AS min_price, MAX(dish_price) AS max_price
        FROM dishes
    """)

    filter_sort_data = Db.fetch(cur)[0]

    cur.close()
    return jsonify(filter_sort_data)


@bp.post('/')
def add_dish():
    cur = Db.cur()

    if not request.json:
        return Response('error', ResponseCode.BAD_REQUEST)

    # с процедурами не работает cur.lastrowid
    # TODO: если кидаешь туда группу, которой не существует,
    #  то выбрасывает constraint fails exception.
    cur.execute(f"""
        INSERT INTO dishes(
            dish_name, 
            dish_price, 
            dish_gr_id, 
            dish_descr, 
            dish_photo_url
        )
        VALUES (%s, %s, %s, %s, %s);
    """, [
        request.json['dish_name'],
        request.json['dish_price'],
        request.json['dish_gr_id'],
        request.json['dish_descr'],
        request.json['dish_photo_url']
    ])
    dish_id = cur.lastrowid
    Db.commit()

    groceries = request.json['dish_groceries']

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

    return Response('success', ResponseCode.SUCCESS)


@bp.put('/<int:dish_id>')
def update_dish(dish_id: int):
    if not request.json:
        return Response("no data", ResponseCode.BAD_REQUEST)

    cur = Db.cur()

    dish = Dish.from_dict(request.json)

    # TODO: handle dish_name absense (maybe)...

    cur.execute(f"""
        UPDATE dishes
        SET dish_name = %s,
            dish_price = %s,
            dish_gr_id = %s,
            dish_photo_url = %s,
            dish_descr = %s
        WHERE dish_id = %s;
    """, [
        dish.dish_name,
        dish.dish_price,
        dish.dish_gr_id,
        dish.dish_photo_url,
        dish.dish_descr,
        dish.dish_id
    ])
    Db.commit()

    cur.execute(f"""
        DELETE FROM dish_consists
        WHERE dish_id = %s
    """, [
        dish.dish_id
    ])
    Db.commit()

    sql = "INSERT INTO dish_consists(dish_id, groc_id, dc_count) VALUES "

    for groc in dish.dish_groceries:
        sql += str((dish_id, groc.groc_id, groc.groc_count)) + ', '
    sql = sql[:-2]

    cur.execute(sql)
    Db.commit()

    cur.close()
    updated_dish = get_dish(dish.dish_id)
    return jsonify(updated_dish.to_dict())


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
    cur = Db.cur()
    groc_id_count = q_utils.decode_query_list_of_dict(
        groc_ids,
        'groc_id',
        'groc_count'
    )

    total_prime_cost = 0
    dish_groceries = []

    for groc in groc_id_count:
        # TODO: CALL get_min_groc_price({groc_id}) # ---> не работает...
        # TODO: по идее, сейчас должна работать...
        cur.execute(f"""SELECT
                junk.supplier_id,
                s.supplier_name,
                g.groc_id,
                g.groc_name,
                junk.sup_groc_price AS min_price
            FROM suppliers_groc junk
                     JOIN groceries g ON junk.groc_id = g.groc_id
                     JOIN suppliers s ON junk.supplier_id = s.supplier_id
            WHERE junk.groc_id = {groc['groc_id']}
            ORDER BY junk.sup_groc_price 
            LIMIT 1
        """)

        grocery = Db.fetch(cur)[0]

        # if there is some supplier that supplies this grocery.
        # generally, should not be executed, because the client will not allow
        # to select groceries that are not supplied
        # TODO: should here be 'is None' instead of 'is not None'?
        if grocery['min_price'] is None:
            print('min_price is not None, so I return something invalid')
            return dumps(
                {
                    'total': 110,
                    'consist': [
                        # TODO: why did I add it?
                        {
                            "supplier_id": 666,
                            "supplier_name": "no no no no",
                            "min_price": 666
                        }
                    ],
                }
            )

        groc_count = float(groc['groc_count'])
        groc_total = float(grocery['min_price']) * float(groc['groc_count'])
        grocery = {
            **grocery,
            'groc_count': groc_count,
            'groc_total': groc_total
        }
        total_prime_cost += groc_total
        dish_groceries.append(grocery)

    cur.close()
    res = {
        'total': total_prime_cost,
        'consist': dish_groceries
    }
    print(res)
    return jsonify(res)


@bp.post('/dish-groups')
def add_dish_group():
    cur = Db.cur()

    if not request.json:
        return Response('error', ResponseCode.BAD_REQUEST)

    name = request.json['name']

    if not name:
        return Response('error', ResponseCode.BAD_REQUEST)

    cur.execute(f'INSERT INTO dish_groups(dish_gr_name) VALUES (%s)',
                params=[name])
    Db.commit()

    cur.close()
    return 'success'


@bp.get('/dish-groups')
def get_all_dish_groups():
    cur = Db.cur()
    cur.execute('SELECT * FROM dish_groups')
    groups = Db.fetch(cur)
    cur.close()
    return jsonify(groups)


@bp.post('/dish-groups/<int:dish_group_id>')
def update_dish_group(dish_group_id):
    pass


@bp.delete('/dish-groups/<int:dish_group_id>')
def delete_dish_group(dish_group_id):
    pass