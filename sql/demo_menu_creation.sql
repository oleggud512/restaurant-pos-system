CREATE DATABASE IF NOT EXISTS dishes;

USE dishes;

CREATE TABLE dish_groups (
	dish_gr_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_gr_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB CHARACTER SET utf8;


CREATE TABLE dishes (
	dish_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_name VARCHAR(50) UNIQUE NOT NULL,
    dish_price DECIMAL(10, 2) NOT NULL,
    dish_descr TEXT,
    dish_gr_id INT,
    dish_photo_path TINYTEXT,
    CONSTRAINT group_ref FOREIGN KEY (dish_gr_id) REFERENCES dish_groups (dish_gr_id)
) ENGINE=InnoDB CHARACTER SET utf8;


CREATE TABLE groceries (
	groc_id INT PRIMARY KEY AUTO_INCREMENT,
    groc_name VARCHAR(50) NOT NULL,
    groc_measure ENUM("gram", "liter") NOT NULL,
    ava_count INT
) ENGINE=InnoDB CHARACTER SET utf8;


CREATE TABLE dish_consists (
	dc_id INT PRIMARY KEY AUTO_INCREMENT,
    dish_id INT NOT NULL,
    groc_id INT NOT NULL,
    dc_count INT NOT NULL,
    CONSTRAINT dish_ref FOREIGN KEY (dish_id) REFERENCES dishes (dish_id),
    CONSTRAINT groc_ref FOREIGN KEY (groc_id) REFERENCES groceries (groc_id)
) ENGINE=InnoDB CHARACTER SET utf8;