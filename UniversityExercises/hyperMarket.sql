DROP DATABASE IF EXISTS hypermarket;
CREATE DATABASE hypermarket;
USE hypermarket;

CREATE TABLE addresses(
	id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(40) NOT NULL,
    city VARCHAR(40) NOT NULL,
    zip_code VARCHAR(30),
    neighborhood VARCHAR(30) NOT NULL,
    street VARCHAR(30) NOT NULL,
    `number` VARCHAR(10) NOT NULL
);

CREATE TABLE departments(
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL,
    manager_id INT
);

CREATE TABLE employees(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    midle_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    salary DECIMAL(7,2) NOT NULL,
    department_id INT,
    address_id INT,
    CONSTRAINT FOREIGN KEY (department_id)
    REFERENCES departments(id),
    CONSTRAINT FOREIGN KEY (address_id)
    REFERENCES addresses(id)
);

ALTER TABLE departments
ADD CONSTRAINT FOREIGN KEY (manager_id)
REFERENCES employees(id);

CREATE TABLE product_types(
	id INT AUTO_INCREMENT PRIMARY KEY,
    product_type VARCHAR(30) NOT NULL
);

CREATE TABLE products(
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL,
    price DECIMAL(8,2)  NOT NULL,
    expiry_date DATE NOT NULL,
    weight DECIMAL(8,2),
    product_type_id INT,
	department_id INT,
    CONSTRAINT FOREIGN KEY (product_type_id)
    REFERENCES product_types(id),
    CONSTRAINT FOREIGN KEY (department_id)
    REFERENCES departments(id)
);

CREATE TABLE manufacturers(
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(30) NOT NULL,
    address_id INT,
    CONSTRAINT FOREIGN KEY (address_id)
    REFERENCES addresses(id)
);

CREATE TABLE products_manufactures(
	product_id INT NOT NULL,
    manufacture_id INT NOT NULL,
    PRIMARY KEY (product_id, manufacture_id),
    CONSTRAINT FOREIGN KEY (product_id)
    REFERENCES products(id),
    CONSTRAINT FOREIGN KEY (manufacture_id)
    REFERENCES manufacturers(id)
);

CREATE TABLE emails(
	id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100),
    employee_id INT,
    manufacture_id INT,
    CONSTRAINT FOREIGN KEY (employee_id)
    REFERENCES employees(id),
    CONSTRAINT FOREIGN KEY (manufacture_id)
    REFERENCES manufacturers(id)
);

CREATE TABLE telephones(
	id INT AUTO_INCREMENT PRIMARY KEY,
    telephone VARCHAR(40),
    employee_id INT,
    manufacture_id INT,
    CONSTRAINT FOREIGN KEY (employee_id)
    REFERENCES employees(id),
    CONSTRAINT FOREIGN KEY (manufacture_id)
    REFERENCES manufacturers(id)
);

INSERT INTO addresses (country, city, zip_code, neighborhood, street, `number`)
VALUES 
	('Bulgaria', 'Sofia', '1000', 'Banishora', 'Klokotnica', '34'),
    ('Bulgaria', 'Sofia', '1000', 'Sveta troica', 'Varna', '21'),
    ('Bulgaria', 'Sofia', '1000', 'Zapadern park', 'Naicho Canov', '10'),
    ('Bulgaria', 'Sofia', '1000', 'Druzhba', '5019', '7'),
    ('Bulgaria', 'Varna', '9000', 'Hristo Botev', 'Stara planina', '8');
    
SET FOREIGN_KEY_CHECKS=0;

INSERT INTO departments(`name`,manager_id)
VALUES
	('meat food',2),
    ('drinks',2),
    ('bathrooms',2),
    ('office products',1),
    ('bread department',1);
    
INSERT INTO employees(first_name, midle_name, last_name, salary, department_id,address_id)
VALUES
	('Ivan', 'Mendeleev', 'Mendeleev', 50000, 1, 1),
    ('Stamat', 'Vencislavov', 'Aleksandrov', 60000, 2, NULL),
    ('Pencho', 'Petkov', 'Trifonov', 55000 , 3, NULL),
    ('Lili', 'Bozhkova', 'Ivanova', 66000, 4, NULL),
    ('Boiko', 'Borislavov', 'Petrov', 80000, 5, 2);
    
SET FOREIGN_KEY_CHECKS=1;
    
INSERT INTO product_types(product_type)
VALUES 
	('meat'),
    ('drink'),
    ('toilet'),
    ('office'),
    ('bread');
    
INSERT INTO products(`name`, price, expiry_date, weight, product_type_id, department_id)
VALUES
	('bacon', 12, '2019-01-02', 1.2, 1, 1),
    ('water', 1, '2019-01-10', 1.5, 2, 2),
    ('toilet paper', 1, '2025-01-02', 0.5, 2, 2),
    ('pen', 0.5, '2024-01-02', 0.02, 2, 2),
    ('dobruzhda bread', 2, '2019-01-03', 0.1, 2, 2);
    
INSERT INTO manufacturers(`name`, address_id)
VALUES
	('bacons OOD', 3),
    ('food creaters', 4),
    ('Office Eldorado', 5);
    
INSERT INTO products_manufactures(product_id,manufacture_id)
VALUES
	(1,1),
    (1,2),
    (2,3),
    (3,3),
    (4,3),
    (5,2);

INSERT INTO emails(email, employee_id, manufacture_id)
VALUES 
	('pingvin@abv.bg', 1, NULL),
    ('stamat@abv.bg', 2, NULL),
    ('bobo.c@abv.bg', 3, NULL),
    ('titan@abv.bg', 3, NULL),
    ('darling@abv.bg', NULL, 2);
    
INSERT INTO telephones(telephone, employee_id, manufacture_id)
VALUES
	('0877322781', 1, NULL),
    ('0877322782', 2, NULL),
    ('0877322783', 3, NULL),
    ('0877322784', 3, NULL),
    ('0877322789', NULL, 2);
	
SELECT pr.name AS product_name, pr.expiry_date, man.name AS manufacturer
FROM products AS pr
JOIN manufacturers AS man
ON man.id IN (
			  SELECT pr_man.manufacture_id
              FROM products_manufactures AS pr_man
              WHERE pr_man.product_id = pr.id
			);
#2
SELECT emp.first_name, emp.last_name
FROM employees AS emp
WHERE emp.address_id IN (
						  SELECT ad.id
                          FROM addresses AS ad
                          WHERE ad.city = 'Sofia'
						);
#3
SELECT ad.city, COUNT(ad.city) AS addresses_from_city
FROM addresses AS ad
GROUP BY ad.city;

#4 
#---> INNER JOIN EXAMPLE
SELECT emp.first_name, ad.city
FROM employees as emp
JOIN addresses AS ad
ON emp.address_id = ad.id;

#----> OUTER JOIN EXAMPLE
SELECT emp.first_name, ad.city
FROM employees as emp
LEFT JOIN addresses AS ad
ON emp.address_id = ad.id;   
 
#5    
SELECT dep.name AS department, ROUND(AVG(emp.salary),2) AS avarege_salary
FROM employees AS emp
JOIN departments AS dep
ON emp.department_id = dep.id
GROUP BY dep.name;

DROP PROCEDURE IF EXISTS p_cursor_demonstration;
DELIMITER $$
CREATE PROCEDURE p_cursor_demonstration()
BEGIN
DECLARE flag INT;
DECLARE temp_employee_name VARCHAR(30);
DECLARE temp_employee_salary DECIMAL;
DECLARE employee_cursor CURSOR FOR
SELECT emp.first_name, emp.salary
FROM employees AS emp
WHERE emp.salary IS NOT NULL;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET flag = 0;
SET flag = 1;
OPEN employee_cursor;
employee_loop: WHILE(flag = 1)
DO
FETCH employee_cursor INTO temp_employee_name, temp_employee_salary;
	IF(flag = 0)
    THEN
    LEAVE employee_loop;
    END IF;
    SELECT temp_employee_name, temp_employee_salary;
END WHILE;
CLOSE employee_cursor;
SET flag = 1;
END;
$$
DELIMITER ;

CALL p_cursor_demonstration(); 
