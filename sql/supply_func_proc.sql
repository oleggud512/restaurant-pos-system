DELIMITER //
CREATE PROCEDURE add_groc_to_certain_supply(
	sup_id INT,
    g_id INT,
    g_count INT
)
BEGIN
	INSERT INTO list_supplys(supply_id, groc_id, groc_count, groc_name, groc_price)
    VALUES (
		sup_id, 
        g_id, 
        g_count, 
        (SELECT groc_name
        FROM groceries 
        WHERE groc_id = g_id),
        (SELECT DISTINCT sup_groc_price 
        FROM suppliers_groc JOIN supplys USING(supplier_id)
        WHERE supply_id = sup_id AND groc_id = g_id)
	);
    UPDATE groceries SET ava_count = ava_count + g_count;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE add_supply(sup_id INT)
BEGIN
	INSERT INTO supplys(supply_date, supplier_id) VALUES (DATE(NOW()), sup_id);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE delete_supply(supl_id INT)
BEGIN 
	DELETE FROM supplys
    WHERE supply_id = supl_id;
END //
DELIMITER ;


-- CREATE VIEW supply_view AS 
-- SELECT supplys.supply_id, 
-- 	supplys.supply_date, 
--     supplys.supplier_id, 
--     suppliers.supplier_name, 
--     SUM(sup_gr.sup_groc_price * lsup.groc_count) AS summ
-- FROM list_supplys lsup
-- 	JOIN supplys supplys USING(supply_id)
-- 	JOIN suppliers suppliers USING(supplier_id)
--     JOIN suppliers_groc sup_gr ON sup_gr.supplier_id = supplys.supplier_id 
-- 								AND sup_gr.groc_id = lsup.groc_id
-- GROUP BY supplys.supply_id;


CREATE VIEW supply_view AS 
SELECT supply_id, supply_date, supplier_id, supplier_name, summ
FROM supplys JOIN suppliers USING(supplier_id);

CREATE VIEW supply_groceries_view AS 
SELECT supply_id, groc_id, groc_count, groc_name, groc_price
FROM list_supplys;


-- CREATE VIEW max_values_view AS 
-- SELECT MAX(supply_date) as max_date, MIN(supply_date) as min_date, MAX(summ) as max_summ
-- FROM supply_view;

CREATE VIEW max_values_view AS 
SELECT  IFNULL(MAX(supply_date), DATE(NOW())) as max_date, 
	IFNULL(MIN(supply_date), DATE(NOW())) as min_date, 
    IFNULL(MAX(summ), 0) as max_summ
FROM supply_view;



SELECT * FROM max_values_view;


CREATE VIEW mini_suppliers_view AS 
SELECT sup.supplier_id, sup.supplier_name
FROM suppliers sup;


DELIMITER //
CREATE PROCEDURE del_info_about_del_suppliers()
BEGIN
	DELETE FROM suppliers
    WHERE supplier_name = 'deleted';
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER del_all_info_about_supplier
BEFORE DELETE ON suppliers
FOR EACH ROW
BEGIN
	DELETE FROM suppliers_groc
    WHERE supplier_id = old.supplier_id;
    DELETE FROM supplys # дальше вызывает триггер на удаление из list_supplys
    WHERE supplier_id = old.supplier_id;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER on_delete_supply
BEFORE DELETE ON supplys
FOR EACH ROW
BEGIN 
	DELETE FROM list_supplys
    WHERE supply_id = old.supply_id;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE add_groc_to_certain_supply(
	sup_id INT,
    g_id INT,
    g_count INT
)
BEGIN
	INSERT INTO list_supplys(supply_id, groc_id, groc_count, groc_name, groc_price)
    VALUES (
		sup_id, 
        g_id, 
        g_count, 
        (SELECT groc_name
        FROM groceries 
        WHERE groc_id = g_id),
        (SELECT DISTINCT sup_groc_price 
        FROM suppliers_groc JOIN supplys USING(supplier_id)
        WHERE supply_id = sup_id AND groc_id = g_id)
	);
    UPDATE groceries 
    SET ava_count = ava_count + g_count
    WHERE groc_id = g_id;
END //
DELIMITER ;

