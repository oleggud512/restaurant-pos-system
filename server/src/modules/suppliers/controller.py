from flask import Blueprint, request
from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps

from ...utils.database import cur_to_dict
from ...database import con

bp = Blueprint('suppliers', __name__, url_prefix='/suppliers')


@bp.route('/<int:sup_id>', methods=['PUT'])
def update_supplier(sup_id):
    """rewrites all information about single supplier"""
    new_name = request.json.get("name", None)
    new_contacts = request.json.get("contacts", None)
    new_groceries = request.json.get("groceries", [])
    
    cur: CMySQLCursor = con.cursor()
    
    if not sup_id: return "where is id?"

    if new_name and new_contacts:
        sql = f"UPDATE suppliers SET supplier_name = '{new_name}', contacts = '{new_contacts}' WHERE supplier_id = {sup_id}"
    elif new_name:
        sql = f"UPDATE suppliers SET supplier_name = '{new_name}' WHERE supplier_id = {sup_id}"
    elif new_contacts:
        sql = f"UPDATE suppliers SET contacts = '{new_contacts}' WHERE supplier_id = {sup_id}"
    cur.execute(sql)
    con.commit()
    
    if new_groceries:
        cur.execute(f'DELETE FROM suppliers_groc WHERE supplier_id = "{sup_id}"')
        con.commit()

        sql = f'INSERT INTO suppliers_groc(supplier_id, groc_id, sup_groc_price) VALUES '
        values = []
        for i in new_groceries:
            values.append(str((sup_id, i['groc_id'], i['sup_groc_price'])))
        sql += ', '.join(values)

        cur.execute(sql)
        con.commit()

    return 'success'


@bp.get('/<int:supplier_id>')
@bp.get('/')
def get_suppliers(supplier_id=None):
    """if supplier_id is not None returns single supplier else returns list of all suppliers"""
    cur: CMySQLCursor = con.cursor()
    cur.execute(f"""SELECT * 
        FROM suppliers 
        WHERE supplier_name != 'deleted'
        {" AND supplier_id = " + str(supplier_id) if supplier_id != None else ''}
    """)
    suppliers = cur_to_dict(cur)
    
    cur.execute(f"""
        SELECT supplier_id, groc_id, groc_name, sup_groc_price, groc_measure, ava_count
        FROM suppliers_groc sg 
            JOIN groceries gr USING(groc_id) 
            JOIN suppliers USING(supplier_id)
        WHERE supplier_name != 'deleted'
        {" AND supplier_id = " + str(supplier_id) if supplier_id != None else ''}
    """)

    groceries = cur_to_dict(cur)

    for groc in groceries:
        cur.execute(f"""
            SELECT supplier_id, supplier_name, sup_groc_price
            FROM suppliers_groc JOIN suppliers USING(supplier_id)
            WHERE groc_id = {groc["groc_id"]}
        """)

        groc['supplied_by'] = cur_to_dict(cur)

    for supplier in suppliers:
        supplier["groceries"] = list(filter(lambda groc: groc['supplier_id'] == supplier['supplier_id'], groceries))
    
    cur.close()
    return dumps(suppliers, indent=4, use_decimal=True) 


@bp.get("/suppliers")
def add_supplier():
    """adds single supplier"""
    supplier_name = request.json['supplier_name']
    contacts = request.json['contacts']

    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        INSERT INTO suppliers(supplier_name, contacts)
        VALUES ('{supplier_name}', '{contacts}')
    """)
    con.commit()

    cur.close()

    return 'success'


@bp.route("/<int:supplier_id>")
def delete_supplier(supplier_id):
    """deletes one supplier"""
    
    cur: CMySQLCursor = con.cursor()

    cur.execute(f"""
        UPDATE suppliers 
        SET supplier_name = 'deleted'
        WHERE supplier_id = {supplier_id}
    """) 
    
    # cur.execute(f"""
    #     DELETE FROM suppliers_groc
    #     WHERE supplier_id = {supplier_id}
    # """)
    
    con.commit()
    cur.close()

    return 'success'

@bp.delete('/delete_info_about_deleted_suppliers')
def delete_inf_ab_del_s():
    """delete deleted suppliers (when you delete supplier it just change state to 'deleted')"""
    cur: CMySQLCursor = con.cursor()
    cur.execute('CALL del_info_about_del_suppliers()')
    con.commit()
    cur.close()
    return 'success'