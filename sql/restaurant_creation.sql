DROP DATABASE restaurant;
CREATE DATABASE restaurant;

USE restaurant;

# групи страв
CREATE TABLE dish_groups (
	dish_gr_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_gr_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB CHARACTER SET utf8;

# страви
CREATE TABLE dishes (
	dish_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_name VARCHAR(50) UNIQUE NOT NULL,
    dish_price DECIMAL(10, 2) NOT NULL,
    dish_descr TEXT,
    dish_gr_id INT,
    dish_photo_path TINYTEXT,
    CONSTRAINT group_ref FOREIGN KEY (dish_gr_id) REFERENCES dish_groups (dish_gr_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# продукти
CREATE TABLE groceries (
	groc_id INT PRIMARY KEY AUTO_INCREMENT,
    groc_name VARCHAR(50) NOT NULL,
    groc_measure ENUM("gram", "liter") NOT NULL,
    ava_count INT DEFAULT(0)
) ENGINE=InnoDB CHARACTER SET utf8;

# склад страв (зв'язок між стравою та інгридиєнтом)
CREATE TABLE dish_consists (
	dc_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT NOT NULL,
    groc_id INT NOT NULL,
    dc_count INT NOT NULL,
    CONSTRAINT dish_ref FOREIGN KEY (dish_id) REFERENCES dishes (dish_id),
    CONSTRAINT groc_ref FOREIGN KEY (groc_id) REFERENCES groceries (groc_id)
) ENGINE=InnoDB CHARACTER SET utf8;

###############################################################################################
###############################################################################################
###############################################################################################

# таблиця постачальників 
CREATE TABLE suppliers(
	supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(70) NOT NULL,
    contacts VARCHAR(70)
) ENGINE=InnoDB CHARACTER SET utf8;

# який постачальник що постачає
CREATE TABLE suppliers_groc(
	id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    groc_id INT NOT NULL,
    sup_groc_price DOUBLE(10, 2),
    CONSTRAINT suppliers_sup_ref FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT suppliers_groc_ref FOREIGN KEY (groc_id) REFERENCES groceries(groc_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# поставки
CREATE TABLE supplys(
	supply_id INT PRIMARY KEY AUTO_INCREMENT,
    supply_date DATE NOT NULL DEFAULT(CURDATE()),
    supplier_id INT NOT NULL,
    CONSTRAINT supplys_sup_ref FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# склад поставки
CREATE TABLE list_supplys(
	l_supplys_id INT PRIMARY KEY AUTO_INCREMENT,
    supply_id INT NOT NULL,
    groc_id INT NOT NULL,
	groc_count INT NOT NULL,
	CONSTRAINT list_supplys_supply_ref FOREIGN KEY (supply_id) REFERENCES supplys(supply_id),
    CONSTRAINT supply_groc_id FOREIGN KEY (groc_id) REFERENCES groceries(groc_id)
)  ENGINE=InnoDB CHARACTER SET utf8;

###############################################################################################
###############################################################################################
###############################################################################################

# посади та їх погодинна оплата
CREATE TABLE roles(
	role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50),
    salary_per_hour DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB CHARACTER SET utf8;

# співробітники
CREATE TABLE employees(
	emp_id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT NOT NULL,
    emp_fname VARCHAR(50) NOT NULL,
    emp_lname VARCHAR(50) NOT NULL,
    birthday DATE,
    phone VARCHAR(10),
    email VARCHAR(50),
    gender ENUM('m', 'f'),
    hours_per_week INT NOT NULL,
    CONSTRAINT employees_role_ref FOREIGN KEY (role_id) REFERENCES roles(role_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# офіціанти, тобто ті employees що взагалі працюють з додатком
CREATE TABLE waiters(
	waiter_id INT PRIMARY KEY,
	waiter_login VARCHAR(50) UNIQUE,
    waiter_password VARCHAR(50),
    CONSTRAINT waiters_id_ref FOREIGN KEY (waiter_id) REFERENCES employees(emp_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# замовлення
CREATE TABLE orders(
	ord_id INT PRIMARY KEY AUTO_INCREMENT,
    ord_date DATE NOT NULL DEFAULT(CURDATE()),
    ord_start_time TIME NOT NULL DEFAULT(TIME(NOW())),
    ord_end_time TIME,
	money_from_customer DECIMAL(10, 2) NOT NULL,
    waiter_login VARCHAR(50) NOT NULL,
    CONSTRAINT orders_waiter_ref FOREIGN KEY (waiter_login) REFERENCES waiters(waiter_login)
) ENGINE=InnoDB CHARACTER SET utf8;

# склад замовлень
CREATE TABLE list_orders(
	lord_id INT PRIMARY KEY AUTO_INCREMENT,
    ord_id INT NOT NULL,
    dish_id INT NOT NULL,
    lord_count INT NOT NULL, -- кількість конкретеної страви в одному замовленні
    comm TINYTEXT,
    CONSTRAINT list_orders_ord_id_ref FOREIGN KEY (ord_id) REFERENCES orders(ord_id),
    CONSTRAINT list_orders_dish_id_ref FOREIGN KEY (dish_id) REFERENCES dishes(dish_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# екран кухні в даний момент
CREATE TABLE kitchen_now(
	ord_id INT PRIMARY KEY,
    dish_name VARCHAR(50),
    comm TINYTEXT,
    CONSTRAINT ord_ref FOREIGN KEY (ord_id) REFERENCES list_orders(ord_id)
) ENGINE=InnoDB CHARACTER SET utf8;

# кто когда сколько работал
CREATE TABLE diary (
	d_id INT PRIMARY KEY AUTO_INCREMENT,
    date_ DATE NOT NULL DEFAULT(CURDATE()),
    emp_id INT NOT NULL,
    start_time TIME DEFAULT(TIME(NOW())),
    end_time TIME DEFAULT(TIME(NOW())),
    CONSTRAINT diary_emp_ref FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
) ENGINE=InnoDB CHARACTER SET=utf8;