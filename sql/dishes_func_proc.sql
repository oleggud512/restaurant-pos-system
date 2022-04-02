DELIMITER //
CREATE PROCEDURE add_dish_group(
	name_ VARCHAR(50)
)
BEGIN 
	INSERT INTO dish_groups(dish_gr_name) VALUES (name_);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_dish(
	name_ VARCHAR(50),
    price DECIMAL(10, 2),
    group_id INT -- default = 1 ("unsorted")
)
BEGIN
	SET group_id = IFNULL(group_id, 1);
    
	INSERT INTO dishes(dish_name, dish_price, dish_gr_id)
    VALUES (name_, price, group_id);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE add_grocery_to_certain_dish(
	d_id INT,
    g_id INT,
    count_ DECIMAL(10, 2)
)
BEGIN 
	INSERT INTO dish_consists(groc_id, dish_id, dc_count) 
    VALUES (g_id, d_id, count_);
END //
DELIMITER ;

CALL add_grocery_to_certain_dish(1, 8, 1);
/* для расчета себестоимости */
DELIMITER //
CREATE PROCEDURE get_min_groc_price(groc_id INT)
BEGIN
	SELECT s.supplier_id, s.supplier_name, MIN(sg.sup_groc_price) AS min_price
    FROM suppliers_groc sg JOIN suppliers s USING(supplier_id)
    WHERE groc_id = groc_id;
END; //

DELIMITER //
CREATE TRIGGER delete_dish
BEFORE DELETE ON dishes
FOR EACH ROW
BEGIN 
	DELETE FROM dish_consists
    WHERE dish_id = old.dish_id;
END; //
DELIMITER ;









