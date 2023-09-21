from src.database import Db
from app import app

if __name__ == '__main__':
    Db.connect()
    app.run()
