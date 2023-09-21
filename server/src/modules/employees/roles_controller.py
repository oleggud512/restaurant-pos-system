from flask import jsonify, request, Blueprint, Response
# from mysql.connector.cursor_cext import CMySQLCursor
from simplejson import dumps

from .diary_service import get_all_diary_entries
from .employees_controller import get_employees_data
from .roles_service import get_all_roles

from ...database import Db
from ...utils.response_code import ResponseCode
from ...utils.wizard_to_dict import wizard_to_dict

bp = Blueprint('roles', __name__, url_prefix="/roles")


@bp.post('/')
def add_role():
    cur = Db.cur()

    if not request.json:
        return 'error'
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

    if not request.json:
        return Response('no data', ResponseCode.BAD_REQUEST)

    role_id = request.json['role_id']
    role_name = request.json['role_name']
    salary_per_hour = request.json['salary_per_hour']

    print(request.json)

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
def get_roles_route(serialize=True):
    return jsonify(wizard_to_dict(get_all_roles()))


@bp.delete('/<int:role_id>')
def delete_role(role_id: int):
    cur = Db.cur()
    print(role_id)
    cur.execute(f"""
        DELETE FROM roles WHERE role_id = %s
    """, [
        role_id
    ])
    Db.commit()

    cur.close()
    return 'success'


@bp.get('/employees')
def get_roles_and_employees():

    emp_data = get_employees_data(request.args, Db.cur())
    return jsonify(dumps(
        obj={
            **emp_data.to_dict(),
            'roles': wizard_to_dict(get_all_roles()),
            'diary': wizard_to_dict(get_all_diary_entries())
        }, 
        indent=4,
        default=str
    ))
