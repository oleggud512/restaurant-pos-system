from flask import request, Blueprint, Response, jsonify

from src.modules.employees.entities.employee import Employee
from .employees_service import get_employees_data
from ...database import Db
from ...utils.response_code import ResponseCode

bp = Blueprint('employees', __name__, url_prefix="/employees")


@bp.post('/')
def add_employee():
    cur = Db.cur()

    if not request.json:
        return 'error'

    role_id = request.json['role_id']
    is_waiter = request.json['is_waiter']
    emp_fname = request.json['emp_fname'] # str 
    emp_lname = request.json['emp_lname'] # str
    birthday = request.json['birthday'] # 2000-01-20
    phone = request.json['phone'] # str
    email = request.json['email'] # str
    gender = request.json['gender'] # str 'm' | 'f'
    hours_per_month = request.json['hours_per_month'] # int

    emp = Employee.from_dict(request.json)
    print(emp)

    cur.execute("""
        INSERT INTO employees(
            role_id, 
            is_waiter, 
            emp_fname, 
            emp_lname, 
            birthday, 
            phone, 
            email, 
            gender, 
            hours_per_month
        ) 
        VALUES (%s, %s, %s, %s, DATE(%s), %s, %s, %s, %s)
    """, [
        role_id,
        is_waiter,
        emp_fname,
        emp_lname,
        birthday,
        phone,
        email,
        gender,
        hours_per_month
    ])
    Db.commit()

    cur.close()
    return 'success'


@bp.put('/<int:emp_id>')
def update_employee(emp_id: int):
    cur = Db.cur()

    if not request.json:
        return Response('no request.json', ResponseCode.BAD_REQUEST)

    emp = Employee.from_dict(request.json)

    cur.execute(f"""
        UPDATE employees
        SET role_id = %s,
            emp_fname = %s,
            emp_lname = %s,
            is_waiter = %s,
            birthday = DATE(%s),
            phone = %s,
            email = %s,
            gender = %s,
            hours_per_month = %s
        WHERE emp_id = %s
    """, [
        emp.role_id,
        emp.emp_fname,
        emp.emp_lname,
        emp.is_waiter,
        emp.birthday,
        emp.phone,
        emp.email,
        emp.gender,
        emp.hours_per_month,
        emp.emp_id
    ])
    Db.commit()

    cur.close()
    return 'success'


@bp.delete('/<int:emp_id>')
def delete_employee(emp_id):
    """удалит всё нахрен. Работника не существовало"""
    cur = Db.cur()

    # TODO: (10) хмм... А чего тут ничего нет?

    cur.close()
    return 'success'


@bp.get('/')
def get_employees():
    cur = Db.cur()

    emp_response = get_employees_data(request.args or {}, cur)

    cur.close()
    return jsonify(emp_response.to_dict())
