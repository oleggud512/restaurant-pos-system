from flask import request, Blueprint
# from mysql.connector.cursor_cext import CMySQLCursor
from mysql.connector.cursor import MySQLCursor
from simplejson import dumps

from src.database import Db

bp = Blueprint('groceries', __name__, url_prefix="/groceries")


@bp.get('/')
def get_groceries():
    """list all groceries"""
    cur = Db.cur()

    try:
        supplied_only = True if request.args['supplied_only'] == 'true' else False
    except:
        supplied_only = False
    # print(type(supplied_only), supplied_only)

    cur.execute(f"""
        SELECT DISTINCT groc_id, groc_name, groc_measure, ava_count 
        FROM groceries {'JOIN suppliers_groc USING(groc_id) ' if supplied_only else ' '}
        WHERE groc_name LIKE '%{request.args["like"]}%'
        ORDER BY groc_name ASC
    """)

    groceries = Db.fetch(cur)

    for groc in groceries:
        cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {groc["groc_id"]}
        """)

        groc['supplied_by'] = Db.fetch(cur)


    return dumps(groceries, indent=4, use_decimal=True)


@bp.get('/<int:groc_id>')
def get_grocery(groc_id):
    """get a single grocery"""
    cur = Db.cur()

    cur.execute(f"""
        SELECT groc_id, groc_name, groc_measure, ava_count
        FROM groceries
        WHERE groc_id = {groc_id}
    """)

    grocery = Db.fetch(cur)[0]

    cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {grocery["groc_id"]}
        """)

    grocery['supplied_by'] = Db.fetch(cur)
    cur.close()

    return dumps(grocery, indent=4, use_decimal=True)


@bp.put('/<int:groc_id>')
def update_grocery(groc_id):
    """update a single grocery info"""
    cur = Db.cur()
    
    ava_count = request.args['ava_count']
    groc_name = request.args['groc_name']
    groc_measure = request.args['groc_measure']

    cur.execute(f"""
        UPDATE groceries 
        SET ava_count = \'{ava_count}\', 
            groc_name = \'{groc_name}\', 
            groc_measure = \'{groc_measure}\'
        WHERE groc_id = {groc_id}
    """)
    Db.commit()

    return 'success'


@bp.post('/')
def add_grocery():
    """add one grocery"""
    cur = Db.cur()
    
    if not request.json: return 'required data is missing'

    ava_count = request.json['ava_count']
    groc_name = request.json['groc_name']
    groc_measure = request.json['groc_measure']

    cur.execute(f"""
        INSERT INTO groceries(groc_name, groc_measure, ava_count) 
        VALUES (\'{groc_name}\', \'{groc_measure}\', {ava_count})
    """)

    Db.commit()
    return 'success'
