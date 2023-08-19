from mysql.connector import connect, MySQLConnection

con: MySQLConnection = connect(
    host='localhost', 
    port=3306, 
    user='restaurant_user', 
    password='rstrpass', 
    database='restaurant'
)