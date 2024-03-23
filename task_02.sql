DROP DATABASE IF EXISTS task_02;
CREATE DATABASE IF NOT EXISTS task_02;
USE task_02;

DROP PROCEDURE IF EXISTS even_numbers;
DELIMITER $$
#Вывод чётных чисел в виде строки
CREATE PROCEDURE even_numbers (n INT)
BEGIN
	DECLARE result TEXT DEFAULT "";
    DECLARE counter INT DEFAULT 1;	
	WHILE (counter <= n) DO
		CASE 
			WHEN MOD(counter, 2) = 0 
				THEN SET result = CONCAT(result, " ", counter);
			ELSE
				BEGIN
                END;
		END CASE;
        SET counter = counter + 1;
    END WHILE;
    SELECT result;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS even_numbers_row;
DELIMITER $$

#Вывод чётных чисел в виде столбца временной таблицы с типом integer
CREATE PROCEDURE even_numbers_row (n INT)
BEGIN    
    DECLARE counter INT DEFAULT 1;	
	WHILE (counter <= n) DO
		IF counter % 2 = 0 
			THEN INSERT even_numbers_table (even_number) VALUES (counter);
        	END IF;		
        	SET counter = counter + 1;
    END WHILE;
    SELECT even_number
		FROM even_numbers_table;
END $$
DELIMITER ;

CALL even_numbers (10);

DROP TEMPORARY TABLE IF EXISTS even_numbers_table;
CREATE TEMPORARY TABLE even_numbers_table
(
	id SERIAL,
	even_number INT
);
CALL even_numbers_row(10);
