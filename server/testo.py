from typing import Any, cast
from mysql.connector.connection_cext import CMySQLConnection
from mysql.connector.cursor_cext import CMySQLCursorDict
import dataclasses as dcl

con = CMySQLConnection()
con.connect(
    host='localhost', 
    port=3306, 
    user='restaurant_user', 
    password='rstrpass', 
    database='restaurant'
)

class DbUtils: 
    def cursor(self, con: CMySQLConnection) -> CMySQLCursorDict:
        return cast(CMySQLCursorDict, con.cursor(cursor_class=CMySQLCursorDict))

    def fetchall(self, cur: CMySQLCursorDict) -> list[dict[str, Any]]:
        res_type = list[dict[str, Any]]
        return cast(res_type, cur.fetchall())

@dcl.dataclass(init=True)
class Dish: 
    dish_id: int
    dish_name: str
    dish_price: float
    dish_descr: str
    dish_gr_id: int
    dish_photo_index: int
