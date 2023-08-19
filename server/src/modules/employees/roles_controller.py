from flask import request, Blueprint
# from mysql.connector.cursor_cext import CMySQLCursor
from mysql.connector.cursor import MySQLCursor
from simplejson import dumps

from .diary_controller import get_diary # TODO: replace with service method
from .employees_controller import get_employees # TODO: replace with service method

from ...utils.database import cur_to_dict
from ...database import con

bp = Blueprint('roles', __name__, url_prefix="/roles")


@bp.post('/')
def add_role():
    cur = con.cursor()

    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    cur.execute(f"""
        INSERT INTO roles(role_name, salary_per_hour)
        VALUES ('{role_name}', {salary_per_hour})
    """)
    con.commit()

    cur.close()
    return 'success'

@bp.put('/')
def update_role():
    cur = con.cursor()

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
    con.commit()

    cur.close()
    return 'success'

@bp.get('/')
def get_roles(serialize=True):
    cur = con.cursor()

    cur.execute(f"""
        SELECT r.role_id, r.role_name, r.salary_per_hour
        FROM roles r
    """)

    roles = cur_to_dict(cur)

    cur.close()
    return dumps(roles, indent=4) if serialize else roles

@bp.delete('/<int:role_id>')
def delete_role(role_id):
    cur = con.cursor()

    cur.execute(f"""
        DELETE FROM roles WHERE role_id = {role_id}
    """)
    con.commit()

    cur.close()
    return 'success'


@bp.get('/employees')
def get_roles_and_employees():
    return dumps({
        **get_employees(serialize=False),
        'roles': get_roles(serialize=False),
        'diary': get_diary(serialize=False)
    }, indent=4)
