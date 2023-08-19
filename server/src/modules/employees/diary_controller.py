from flask import request, Blueprint
# from mysql.connector.cursor_cext impor
from mysql.connector.cursor import MySQLCursor
from simplejson import dumps

# from ...utils import database as db_utils
from ...utils.database import cur_to_dict
from ...database import con

bp = Blueprint('diary', __name__, url_prefix='/diary')

@bp.post('/start/<int:emp_id>')
def employee_comes(emp_id):
    cur = con.cursor()

    cur.execute(f"""
        INSERT INTO diary(emp_id) VALUES ({emp_id})
    """)
    con.commit()

    cur.close()
    return 'success'

@bp.put('/gone/<int:emp_id>')
def employee_has_gone(emp_id):  
    cur = con.cursor()

    cur.execute(f"""
        UPDATE diary 
        SET end_time = TIME(NOW()),
            gone = 1
        WHERE gone = 0 AND emp_id = {emp_id}
    """)

    cur.close()
    return 'success'

@bp.get('/')
def get_diary(serialize=True):
    cur = con.cursor()

    cur.execute(f"""
        SELECT d.d_id, 
            d.date_, 
            d.emp_id, 
            d.start_time, 
            d.end_time, 
            d.gone, 
            CONCAT(e.emp_lname, " ", e.emp_fname) as emp_name
        FROM diary d JOIN employees e USING(emp_id)
    """)

    diary = cur_to_dict(cur)
    # print(diary)
    

    cur.close()
    return dumps(diary, indent=4) if serialize else diary

@bp.delete('/<int:d_id>')
def delete_diary(d_id):
    cur = con.cursor()
    
    cur.execute(f"""
        DELETE FROM diary WHERE d_id = {d_id}
    """)
    con.commit()

    cur.close()
    return 'success'

