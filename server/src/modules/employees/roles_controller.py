from flask import jsonify, request, Blueprint
# from mysql.connector.cursor_cext import CMySQLCursor
from mysql.connector.cursor import MySQLCursor
from simplejson import dumps

from .diary_controller import get_diary # TODO: (2) replace with service method
from .employees_controller import get_employees_data

from ...utils.database import cur_to_dict
from ...database import Db

bp = Blueprint('roles', __name__, url_prefix="/roles")


@bp.post('/')
def add_role():
    cur = Db.cur()

    if not request.json: return 'error'
    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    cur.execute(f"""
        INSERT INTO roles(role_name, salary_per_hour)
        VALUES ('{role_name}', {salary_per_hour})
    """)
    Db.commit()

    cur.close()
    return 'success'

@bp.put('/')
def update_role():
    cur = Db.cur()

    if not request.json: return 'error'

    role_id = request.json['role_id']
    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    # print(request.json)

    cur.execute(f"""
        UPDATE roles 
        SET role_name = '{role_name}', 
            salary_per_hour = {salary_per_hour}
        WHERE role_id = {role_id}
    """)
    Db.commit()

    cur.close()
    return 'success'

@bp.get('/')
def get_roles(serialize=True):
    cur = Db.cur()

    cur.execute(f"""
        SELECT r.role_id, r.role_name, r.salary_per_hour
        FROM roles r
    """)

    roles = Db.fetch(cur)

    cur.close()
    return dumps(roles, indent=4) if serialize else roles

@bp.delete('/<int:role_id>')
def delete_role(role_id):
    cur = Db.cur()

    cur.execute(f"""
        DELETE FROM roles WHERE role_id = {role_id}
    """)
    Db.commit()

    cur.close()
    return 'success'


@bp.get('/employees')
def get_roles_and_employees():

    emp = dict(get_employees_data(request.args, Db.cur()))
    return jsonify(dumps(
        obj={
            **emp,
            'roles': get_roles(serialize=False),
            'diary': get_diary(serialize=False)
        }, 
        indent=4,
        default=str
    ))
