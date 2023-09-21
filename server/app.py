from flask import Blueprint, Flask, jsonify, make_response, request, Response
from werkzeug.utils import secure_filename
from uuid import uuid4
from flask_cors import CORS
from src.modules.groceries.controller import bp as groceries_bp
from src.modules.suppliers.controller import bp as suppliers_bp
from src.modules.supplies.controller import bp as supplies_bp
from src.modules.menu.controller import bp as menu_bp
from src.modules.employees.roles_controller import bp as roles_bp
from src.modules.employees.employees_controller import bp as employees_bp
from src.modules.employees.diary_controller import bp as diary_bp
from src.modules.orders.controller import bp as orders_bp
from src.modules.stats.controller import bp as stats_bp
from src.utils.response_code import ResponseCode

app = Flask(__name__)
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

app.url_map.strict_slashes = False

main_bp = Blueprint(
    'restaurant/v1',
    __name__,
    url_prefix="/restaurant/v1"
)

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
    return make_response(jsonify({
        'error': 'bed_request',
        'actual_error': error
    }), 400)


@main_bp.get('/')
def get_restaurant_root():
    return '{"rest": "root"}'


@main_bp.post('/image')
def add_image():
    img = request.files.get('image', None)
    if not img:
        return Response("NO IMAGE", ResponseCode.BAD_REQUEST)
    print(img.filename)
    filename: str = secure_filename(img.filename)
    ext = filename.split('.')[-1]
    uid = str(uuid4())
    path = f'static/images/{uid}.{ext}'
    host = request.host
    url = f'http://{host}/{path}'  # TODO: change to https
    img.save(path)

    return {
        "image_url": url
    }


@app.route('/')
def index(): 
    return 'Index page. Nothing interesting. Go to /restaurant/v%/...'


app.register_blueprint(main_bp)

print(app.url_map)

