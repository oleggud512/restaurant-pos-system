from typing import Any, cast
from mysql.connector.connection_cext import CMySQLConnection
from mysql.connector.cursor_cext import CMySQLCursorDict


class Db: 
    con = CMySQLConnection()

    @staticmethod
    def connect():
        Db.con.connect(
            host='localhost', 
            port=3306, 
            user='restaurant_user', 
            password='rstrpass', 
            database='restaurant'
        )
    
    @staticmethod
    def commit():
        Db.con.commit()


    @staticmethod
    def cur() -> CMySQLCursorDict:
        """use cur global variable to create a dictionary cursor"""
        return cast(CMySQLCursorDict, Db.con.cursor(cursor_class=CMySQLCursorDict))

    @staticmethod
    def fetch(cur: CMySQLCursorDict) -> list[dict[str, Any]]:
        """call cursor's fetchall method and cast it to list[dict[str, Any]]"""
        res_type = list[dict[str, Any]]
        return res_type(cur.fetchall())
    
    # @staticmethod
    # def fetchone(cur: CMySQLCursorDict) -> dict[str, Any]: 
    #     """call cursor's fetchone method and cast it to dict[str, Any]"""
    #     res_type = dict[str, Any]
    #     return cast(res_type, cur.fetchone())
