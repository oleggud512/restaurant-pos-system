-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema restaurant
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema restaurant
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS restaurant;
USE restaurant;

DELIMITER //
CREATE FUNCTION parseISO(iso_datetime VARCHAR(255)) RETURNS DATETIME
DETERMINISTIC
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            RETURN STR_TO_DATE(iso_datetime, '%Y-%m-%dT%H:%i:%s');
        END;

    RETURN STR_TO_DATE(iso_datetime, '%Y-%m-%d %H:%i:%s');
END //

DELIMITER ;


-- -----------------------------------------------------
-- Table restaurant.roles
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.roles (
  role_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT PRIMARY KEY,
  role_name VARCHAR(50) NULL DEFAULT NULL,
  salary_per_hour DECIMAL(10,2) NOT NULL
);


-- -----------------------------------------------------
-- Table restaurant.employees
-- -----------------------------------------------------
-- DROP TABLE restaurant.employees;
CREATE TABLE IF NOT EXISTS restaurant.employees (
  emp_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role_id INT NOT NULL,
  emp_fname VARCHAR(50) NOT NULL,
  emp_lname VARCHAR(50) NOT NULL,
  birthday DATE NULL DEFAULT NULL,
  phone VARCHAR(10) NULL DEFAULT NULL,
  email VARCHAR(50) NULL DEFAULT NULL,
  gender ENUM('m', 'f') NULL DEFAULT NULL,
  hours_per_month INT NOT NULL,
  is_waiter BOOL NOT NULL DEFAULT(FALSE),
  INDEX employees_role_ref (role_id ASC) VISIBLE,
  CONSTRAINT employees_role_ref
    FOREIGN KEY (role_id)
    REFERENCES restaurant.roles (role_id)
);


-- -----------------------------------------------------
-- Table restaurant.diary
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.diary (
  d_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date_ DATE NOT NULL DEFAULT(curdate()),
  emp_id INT NOT NULL,
  start_time TIME NULL DEFAULT(cast(now() as time)),
  end_time TIME NULL DEFAULT(cast(now() as time)),
  gone BOOL NOT NULL DEFAULT(TRUE),
  INDEX diary_emp_ref (emp_id ASC) VISIBLE,
  CONSTRAINT diary_emp_ref
    FOREIGN KEY (emp_id)
    REFERENCES restaurant.employees (emp_id)
);


-- -----------------------------------------------------
-- Table restaurant.dish_groups
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.dish_groups (
  dish_gr_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dish_gr_name VARCHAR(50) NOT NULL
);


-- -----------------------------------------------------
-- Table restaurant.dishes
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.dishes (
  dish_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dish_name VARCHAR(50) NOT NULL,
  dish_price DECIMAL(10,2) NOT NULL DEFAULT '0.00',
  dish_descr TEXT NOT NULL DEFAULT(''),
  dish_photo_url TEXT NOT NULL DEFAULT(''),
  dish_gr_id INT NULL DEFAULT NULL,
  UNIQUE INDEX dish_name (dish_name ASC) VISIBLE,
  INDEX group_ref (dish_gr_id ASC) VISIBLE,
  CONSTRAINT group_ref
    FOREIGN KEY (dish_gr_id)
    REFERENCES restaurant.dish_groups (dish_gr_id)
);


-- -----------------------------------------------------
-- Table restaurant.groceries
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.groceries (
  groc_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  groc_name VARCHAR(50) NOT NULL,
  groc_measure ENUM('gram', 'liter') NOT NULL,
  ava_count DECIMAL(10,3) NULL DEFAULT '0.000'
);


-- -----------------------------------------------------
-- Table restaurant.dish_consists
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.dish_consists (
  dc_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  dish_id INT NOT NULL,
  groc_id INT NOT NULL,
  dc_count DOUBLE NOT NULL,
  INDEX dish_ref (dish_id ASC) VISIBLE,
  INDEX groc_ref (groc_id ASC) VISIBLE,
  CONSTRAINT dish_ref
    FOREIGN KEY (dish_id)
    REFERENCES restaurant.dishes (dish_id),
  CONSTRAINT groc_ref
    FOREIGN KEY (groc_id)
    REFERENCES restaurant.groceries (groc_id)
);


-- -----------------------------------------------------
-- Table restaurant.orders
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.orders (
  ord_date DATE NOT NULL DEFAULT(CURDATE()),
  ord_start_time DATETIME DEFAULT NOW() NOT NULL,
  ord_end_time DATETIME NULL,
  ord_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  emp_id INT NOT NULL,
  is_end TINYINT(1) NOT NULL DEFAULT 0,
  money_from_customer DECIMAL(10,2) NULL,
  comm TEXT NOT NULL DEFAULT(''),
  CONSTRAINT orders_emp_ref
    FOREIGN KEY (emp_id)
    REFERENCES restaurant.employees (emp_id)
);


-- -----------------------------------------------------
-- Table restaurant.list_orders
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.list_orders (
  lord_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  ord_id INT NOT NULL,
  dish_id INT NOT NULL,
  lord_count INT NOT NULL,
  lord_price DECIMAL(10, 2) NOT NULL DEFAULT(0.0),
  comm TINYTEXT NULL DEFAULT NULL,
  INDEX list_orders_ord_id_ref (ord_id ASC) VISIBLE,
  INDEX list_orders_dish_id_ref (dish_id ASC) VISIBLE,
  CONSTRAINT list_orders_dish_id_ref
    FOREIGN KEY (dish_id)
    REFERENCES restaurant.dishes (dish_id),
  CONSTRAINT list_orders_ord_id_ref
    FOREIGN KEY (ord_id)
    REFERENCES restaurant.orders (ord_id)
);


-- -----------------------------------------------------
-- Table restaurant.kitchen_now
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.kitchen_now (
  ord_id INT NOT NULL PRIMARY KEY,
  dish_name VARCHAR(50) NULL DEFAULT NULL,
  comm TINYTEXT NULL DEFAULT NULL,
  CONSTRAINT ord_ref
    FOREIGN KEY (ord_id)
    REFERENCES restaurant.list_orders (ord_id)
);


-- -----------------------------------------------------
-- Table restaurant.suppliers
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.suppliers (
  supplier_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  supplier_name VARCHAR(70) NOT NULL,
  contacts TINYTEXT NULL DEFAULT NULL
);


-- -----------------------------------------------------
-- Table restaurant.supplys
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.supplys (
  supply_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  supply_date DATE NULL DEFAULT(curdate()),
  supplier_id INT NOT NULL,
  summ DECIMAL(10,2) NOT NULL DEFAULT 0,
  CONSTRAINT supplys_sup_ref
    FOREIGN KEY (supplier_id)
    REFERENCES restaurant.suppliers (supplier_id),
  INDEX supplys_sup_ref (supplier_id ASC) VISIBLE
);


-- -----------------------------------------------------
-- Table restaurant.list_supplys
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.list_supplys (
  l_supplys_id INT NOT NULL AUTO_INCREMENT,
  supply_id INT NOT NULL,
  groc_id INT NOT NULL,
  groc_count INT NOT NULL,
  groc_name VARCHAR(50) NULL DEFAULT NULL,
  groc_price DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (l_supplys_id),
  INDEX list_supplys_supply_ref (supply_id ASC) VISIBLE,
  INDEX supply_groc_id (groc_id ASC) VISIBLE,
  CONSTRAINT list_supplys_supply_ref
    FOREIGN KEY (supply_id)
    REFERENCES restaurant.supplys (supply_id),
  CONSTRAINT supply_groc_id
    FOREIGN KEY (groc_id)
    REFERENCES restaurant.groceries (groc_id)
);


-- -----------------------------------------------------
-- Table restaurant.suppliers_groc
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.suppliers_groc (
  id INT NOT NULL AUTO_INCREMENT,
  supplier_id INT NOT NULL,
  groc_id INT NOT NULL,
  sup_groc_price DOUBLE(10,2) NULL,
  PRIMARY KEY (id),
  INDEX suppliers_sup_ref (supplier_id ASC) VISIBLE,
  INDEX suppliers_groc_ref (groc_id ASC) VISIBLE,
  CONSTRAINT suppliers_groc_ref
    FOREIGN KEY (groc_id)
    REFERENCES restaurant.groceries (groc_id),
  CONSTRAINT suppliers_sup_ref
    FOREIGN KEY (supplier_id)
    REFERENCES restaurant.suppliers (supplier_id)
);

USE restaurant ;

-- -----------------------------------------------------
-- Placeholder table for view restaurant.max_values_view
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.max_values_view (max_date INT, min_date INT, max_summ INT);

-- -----------------------------------------------------
-- Placeholder table for view restaurant.mini_suppliers_view
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.mini_suppliers_view (supplier_id INT, supplier_name INT);

-- -----------------------------------------------------
-- Placeholder table for view restaurant.supply_groceries_view
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.supply_groceries_view (supply_id INT, groc_id INT, groc_count INT, groc_name INT, groc_price INT);

-- -----------------------------------------------------
-- Placeholder table for view restaurant.supply_view
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS restaurant.supply_view (supply_id INT, supply_date INT, supplier_id INT, supplier_name INT, summ INT);

-- -----------------------------------------------------
-- procedure add_dish
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE add_dish(
	name_ VARCHAR(50),
    price DECIMAL(10, 2),
    group_id INT -- default = 1 ("unsorted")
)
BEGIN
	SET group_id = IFNULL(group_id, 1);
    
	INSERT INTO dishes(dish_name, dish_price, dish_gr_id)
    VALUES (name_, price, group_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_dish_group
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE add_dish_group(
	name_ VARCHAR(50)
)
BEGIN 
	INSERT INTO dish_groups(dish_gr_name) VALUES (name_);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_grocery_to_certain_supply
-- -----------------------------------------------------
DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE add_grocery_to_certain_supply(
	certain_supply_id INT,
    grocery_id INT,
    grocery_count INT
)
BEGIN 
	DECLARE var_supplier_id INT DEFAULT 0;
	DECLARE var_groc_price DECIMAL(10,2) DEFAULT 0.1;
	DECLARE var_groc_name VARCHAR(50) DEFAULT '';
    
    -- determine supplier id from supply
    SELECT s.supplier_id INTO var_supplier_id
    FROM supplys s
    WHERE s.supply_id = certain_supply_id;
    
	-- obtain supplier's price for the current grocery
	SELECT sg.sup_groc_price INTO var_groc_price
	FROM suppliers_groc sg
	WHERE sg.groc_id = grocery_id AND
	      sg.supplier_id = var_supplier_id;

    -- get grocery name
    SELECT g.groc_name INTO var_groc_name
    FROM groceries g
    WHERE g.groc_id = grocery_id;

	-- add grocery to the check
	INSERT INTO list_supplys(
        supply_id,
        groc_id,
        groc_count,
        groc_name,
        groc_price
	)
	VALUES (
		certain_supply_id, 
		grocery_id, 
		grocery_count, 
		var_groc_name,
		var_groc_price
	);

	-- increase total supply summ
	UPDATE supplys s
	SET s.summ = s.summ + var_groc_price * grocery_count
	WHERE s.supply_id = certain_supply_id;
	
	-- increase current amount of grocery available
	UPDATE groceries 
	SET ava_count = ava_count + grocery_count
	WHERE groc_id = grocery_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_grocery_to_certain_dish
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE add_grocery_to_certain_dish(
	d_id INT,
    g_id INT,
    count_ DECIMAL(10, 2)
)
BEGIN 
	INSERT INTO dish_consists(groc_id, dish_id, dc_count) 
    VALUES (g_id, d_id, count_);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure add_supply
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE add_supply(sup_id INT)
BEGIN
	INSERT INTO supplys(supply_date, supplier_id) VALUES (DATE(NOW()), sup_id);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure del_info_about_del_suppliers
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE del_info_about_del_suppliers()
BEGIN
	DELETE FROM suppliers
    WHERE supplier_name = 'deleted';
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure delete_supply
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE delete_supply(supl_id INT)
BEGIN 
	DELETE FROM supplys
    WHERE supply_id = supl_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure get_min_groc_price
-- -----------------------------------------------------

DELIMITER $$
USE restaurant$$
CREATE DEFINER=root@localhost PROCEDURE get_min_groc_price(grocery_id INT)
BEGIN
    SELECT
        s.supplier_id,
        s.supplier_name,
        g.groc_id,
        g.groc_name,
        MIN(junk.sup_groc_price) AS min_price
    FROM suppliers_groc junk
             JOIN suppliers s ON junk.supplier_id = s.supplier_id
             JOIN groceries g ON junk.groc_id = g.groc_id
    WHERE junk.groc_id = grocery_id;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View restaurant.max_values_view
-- -----------------------------------------------------
DROP TABLE IF EXISTS restaurant.max_values_view;
USE restaurant;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW restaurant.max_values_view AS select ifnull(max(restaurant.supply_view.supply_date),cast(now() as date)) AS max_date,ifnull(min(restaurant.supply_view.supply_date),cast(now() as date)) AS min_date,ifnull(max(restaurant.supply_view.summ),0) AS max_summ from restaurant.supply_view;

-- -----------------------------------------------------
-- View restaurant.mini_suppliers_view
-- -----------------------------------------------------
DROP TABLE IF EXISTS restaurant.mini_suppliers_view;
USE restaurant;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW restaurant.mini_suppliers_view AS select sup.supplier_id AS supplier_id,sup.supplier_name AS supplier_name from restaurant.suppliers sup;

-- -----------------------------------------------------
-- View restaurant.supply_groceries_view
-- -----------------------------------------------------
DROP TABLE IF EXISTS restaurant.supply_groceries_view;
USE restaurant;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW restaurant.supply_groceries_view AS select restaurant.list_supplys.supply_id AS supply_id,restaurant.list_supplys.groc_id AS groc_id,restaurant.list_supplys.groc_count AS groc_count,restaurant.list_supplys.groc_name AS groc_name,restaurant.list_supplys.groc_price AS groc_price from restaurant.list_supplys;

-- -----------------------------------------------------
-- View restaurant.supply_view
-- -----------------------------------------------------
DROP TABLE IF EXISTS restaurant.supply_view;
USE restaurant;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=root@localhost SQL SECURITY DEFINER VIEW restaurant.supply_view AS select restaurant.supplys.supply_id AS supply_id,restaurant.supplys.supply_date AS supply_date,restaurant.supplys.supplier_id AS supplier_id,restaurant.suppliers.supplier_name AS supplier_name,restaurant.supplys.summ AS summ from (restaurant.supplys join restaurant.suppliers on((restaurant.supplys.supplier_id = restaurant.suppliers.supplier_id)));
USE restaurant;

DELIMITER $$
USE restaurant$$
CREATE
DEFINER=root@localhost
TRIGGER restaurant.delete_dish
BEFORE DELETE ON restaurant.dishes
FOR EACH ROW
BEGIN 
	DELETE FROM dish_consists
    WHERE dish_id = old.dish_id;
END$$

USE restaurant$$
CREATE
DEFINER=root@localhost
TRIGGER restaurant.del_all_info_about_supplier
BEFORE DELETE ON restaurant.suppliers
FOR EACH ROW
BEGIN
	DELETE FROM suppliers_groc
    WHERE supplier_id = old.supplier_id;
    DELETE FROM supplys # дальше вызывает триггер на удаление из list_supplys
    WHERE supplier_id = old.supplier_id;
END$$

USE restaurant$$
CREATE
DEFINER=root@localhost
TRIGGER restaurant.on_delete_supply
BEFORE DELETE ON restaurant.supplys
FOR EACH ROW
BEGIN 
	DELETE FROM list_supplys
    WHERE supply_id = old.supply_id;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

