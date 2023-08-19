from flask import Blueprint, Flask, jsonify, make_response
from .modules.groceries.controller import bp as groceries_bp
from .modules.suppliers.controller import bp as suppliers_bp
from .modules.supplies.controller import bp as supplies_bp
from .modules.menu.controller import bp as menu_bp
from .modules.employees.roles_controller import bp as roles_bp
from .modules.employees.employees_controller import bp as employees_bp
from .modules.employees.diary_controller import bp as diary_bp
from .modules.orders.controller import bp as orders_bp
from .modules.stats.controller import bp as stats_bp

app = Flask(__name__)

main_bp = Blueprint('restaurant/v1', __name__, url_prefix="/restaurant/v1")

main_bp.register_blueprint(groceries_bp)
main_bp.register_blueprint(suppliers_bp)
main_bp.register_blueprint(supplies_bp)
main_bp.register_blueprint(menu_bp)
main_bp.register_blueprint(roles_bp)
main_bp.register_blueprint(employees_bp)
main_bp.register_blueprint(diary_bp)
main_bp.register_blueprint(orders_bp)
main_bp.register_blueprint(stats_bp)


@main_bp.errorhandler(400)
def bed_request(error):
    return make_response(jsonify({'error': 'bed_request', 'actual_error': error}), 400)


@main_bp.get('/')
def get_restaurant_root():
    return '{"rest": "root"}'

@app.route('/')
def index(): 
    return 'Index page. Nothing interesting. Go to /restaurant/v%/...'


app.register_blueprint(main_bp)

print(app.url_map)

