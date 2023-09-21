from flask import Blueprint, jsonify

from .diary_service import get_all_diary_entries
from ...database import Db
from ...utils.wizard_to_dict import wizard_to_dict

bp = Blueprint('diary', __name__, url_prefix='/diary')


@bp.post('/start/<int:emp_id>')
def employee_comes(emp_id):
    cur = Db.cur()

    cur.execute(f"""
        INSERT INTO diary(emp_id)
        SELECT %s
        FROM dual
        WHERE NOT EXISTS (SELECT * FROM diary WHERE emp_id = %s AND gone = 0);
    """, [emp_id, emp_id])

    # TODO: send user some notification if the diary entry have not been created
    Db.commit()

    cur.close()
    return 'success'


@bp.put('/gone/<int:emp_id>')
def employee_has_gone(emp_id):  
    cur = Db.cur()

    cur.execute(f"""
        UPDATE diary 
        SET end_time = TIME(NOW()),
            gone = 1
        WHERE gone = 0 AND emp_id = %s
    """, [emp_id])

    cur.close()
    return 'success'


@bp.get('/')
def get_diary():
    return jsonify(wizard_to_dict(get_all_diary_entries()))


@bp.delete('/<int:d_id>')
def delete_diary(d_id):
    cur = Db.cur()
    
    cur.execute("DELETE FROM diary WHERE d_id = %s", [d_id])
    Db.commit()

    cur.close()
    return 'success'

