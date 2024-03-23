DROP DATABASE IF EXISTS task_01;
CREATE DATABASE IF NOT EXISTS task_01;
USE task_01;
DROP FUNCTION IF EXISTS sec_to_datetime_div;
DELIMITER $$
#Использование оператора DIV - целочисленное деление
CREATE FUNCTION sec_to_datetime_div(sec INT)
RETURNS TEXT READS SQL DATA
BEGIN
	DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;
    DECLARE seconds INT;
    DECLARE result TEXT;
    SET days = sec DIV 60 DIV 60 DIV 24;    
    SET hours = (sec - (days * 24 * 60 * 60)) DIV 60 DIV 60;    
    SET minutes = (sec - (days * 60 * 60 * 24) - (hours * 60 * 60)) DIV 60;    
    SET seconds = sec - (days * 60 * 60 * 24) - (hours * 60 * 60) - (minutes * 60);    
    SET result = CONCAT_WS(" ",
						   sec,
                           "seconds is -",
                           days,
                           "days,",
                           hours,
                           "hours,",
                           minutes,
                           "minutes,",
                           seconds,
                           "seconds.");
    RETURN result;
END $$
DELIMITER ;

DROP FUNCTION IF EXISTS sec_to_datetime_floor;
DELIMITER $$
#Использование функции FLOOR - выделение целой части из десятичной дроби
CREATE FUNCTION sec_to_datetime_floor(sec INT)
RETURNS TEXT READS SQL DATA
BEGIN
	DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;
    DECLARE seconds INT;
    DECLARE result TEXT;
	SET days = FLOOR(sec / 60 / 60 / 24);
	SET hours = FLOOR((sec - days * 60 * 60 * 24) / 60 / 60);
	SET minutes = FLOOR ((sec - (days * 60 * 60 * 24) - (hours * 60 * 60)) / 60);
	SET seconds = FLOOR ((sec - (days * 60 * 60 * 24) - (hours * 60 * 60)) - (minutes * 60));
	SET result = CONCAT_WS(" ", 
						   sec,
                           "seconds is -",
                           days, "days,",
                           hours,
                           "hours,",
                           minutes,
                           "minutes,",
                           seconds,
                           "seconds.");
	RETURN result;
END $$
DELIMITER ;

#Использование функции MOD - нахождение остатка от деления
DROP FUNCTION IF EXISTS sec_to_datetime_mod;
DELIMITER $$
CREATE FUNCTION sec_to_datetime_mod(sec INT)
RETURNS TEXT READS SQL DATA
BEGIN
	DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;
    DECLARE seconds INT;
    DECLARE result TEXT;
	SET days = FLOOR(sec / 60 / 60 / 24);
    SET hours = FLOOR(MOD(sec / 60 / 60 / 24, 1) * 24);
    SET minutes = FLOOR(MOD(MOD(sec / 60 / 60 / 24, 1) * 24, 1) * 60);
    SET seconds = ROUND(MOD(MOD(MOD(sec / 60 / 60 / 24, 1) * 24, 1) * 60, 1) * 60);
	SET result = CONCAT_WS(" ", 
						   sec,
                           "seconds is -",
                           days, "days,",
                           hours,
                           "hours,",
                           minutes, 
                           "minutes,", 
                           seconds, 
                           "seconds.");
	RETURN result;
END $$

#То же самое, что с MOD, но используется оператор % - остаток от деления
DROP FUNCTION IF EXISTS sec_to_datetime_mod2;
DELIMITER $$
CREATE FUNCTION sec_to_datetime_mod2(sec INT)
RETURNS TEXT READS SQL DATA
BEGIN
	DECLARE days INT;
    DECLARE hours INT;
    DECLARE minutes INT;
    DECLARE seconds INT;
    DECLARE result TEXT;
	SET days = FLOOR(sec / 60 / 60 / 24);
    SET hours = FLOOR(((sec / 60 / 60 / 24) % 1) * 24);
    SET minutes = FLOOR(((((sec / 60 / 60 / 24) % 1) * 24) % 1) * 60);
    SET seconds = ROUND(((((((sec / 60 / 60 / 24) % 1) * 24) % 1) * 60) % 1) * 60);
	SET result = CONCAT_WS(" ", 
						   sec, 
                           "seconds is -", 
                           days, "days,", 
                           hours, "hours,", 
                           minutes, 
                           "minutes,", 
                           seconds, 
                           "seconds.");
	RETURN result;
END $$
DELIMITER ;


#Проверка всех функций сведена во временную таблицу
DROP TEMPORARY TABLE IF EXISTS tests;
CREATE TEMPORARY TABLE tests(
id SERIAL,
_seconds INT,
_div TEXT,
_floor TEXT,
_mod TEXT,
_mod2 TEXT
);


INSERT INTO tests (_seconds, _div, _floor, _mod, _mod2)
VALUES
	(456885, (SELECT sec_to_datetime_div(456885)), (SELECT sec_to_datetime_floor (456885)), (SELECT sec_to_datetime_mod(456885)), (SELECT sec_to_datetime_mod2(456885))),
	(0, (SELECT sec_to_datetime_div(0)), (SELECT sec_to_datetime_floor (0)), (SELECT sec_to_datetime_mod(0)), (SELECT sec_to_datetime_mod2(0))),
	(604800, (SELECT sec_to_datetime_div(604800)), (SELECT sec_to_datetime_floor (604800)), (SELECT sec_to_datetime_mod(604800)), (SELECT sec_to_datetime_mod2(604800))),
	(60, (SELECT sec_to_datetime_div(60)), (SELECT sec_to_datetime_floor (60)), (SELECT sec_to_datetime_mod(60)), (SELECT sec_to_datetime_mod2(60))),
	(3600, (SELECT sec_to_datetime_div(3600)), (SELECT sec_to_datetime_floor (3600)), (SELECT sec_to_datetime_mod(3600)), (SELECT sec_to_datetime_mod2(3600))),
	(86400, (SELECT sec_to_datetime_div(86400)), (SELECT sec_to_datetime_floor (86400)), (SELECT sec_to_datetime_mod(86400)), (SELECT sec_to_datetime_mod2(86400))),
	(59, (SELECT sec_to_datetime_div(59)), (SELECT sec_to_datetime_floor (59)), (SELECT sec_to_datetime_mod(59)), (SELECT sec_to_datetime_mod2(59)));
SELECT * FROM tests;
#Результат выполнения всех функций совпадает, значения проверены через сторонний калькулятор.