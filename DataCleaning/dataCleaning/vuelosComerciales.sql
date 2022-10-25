DROP DATABASE IF EXISTS vuelosComerciales;
CREATE DATABASE vuelosComerciales;
USE vuelosComerciales;

SELECT @@global.secure_file_priv; -- Muestra la carpeta de donde solo se pueden a cargar los archivos
SHOW VARIABLES LIKE "secure_file_priv"; -- Idem
SET SQL_SAFE_UPDATES = 0; -- desactivamos el safe mode 
SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS plane_data; 
CREATE TABLE IF NOT EXISTS plane_data (
	`tailnum`		VARCHAR(7),
    `type`			VARCHAR(20),
  	`manufacturer`	VARCHAR(30),
    `issue_date`	VARCHAR(20),
    `model`			VARCHAR(20),
    `status`		VARCHAR(20),
    `aircraft_type`	VARCHAR(30),
    `engine_type`	VARCHAR(20),
    `year`			INTEGER,
    PRIMARY KEY (tailnum)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

DROP TABLE IF EXISTS airline;
CREATE TABLE IF NOT EXISTS airline (
	`IATA_CODE_AIRLINE`	VARCHAR(10),
  	`AIRLINE`			VARCHAR(100),
    PRIMARY KEY (IATA_CODE_AIRLINE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

DROP TABLE IF EXISTS airport;
CREATE TABLE IF NOT EXISTS airport (
	`IATA_CODE_AIRPORT`	VARCHAR(5),
  	`AIRPORT`			VARCHAR(100),
    `CITY`				VARCHAR(100),
    `STATE`				VARCHAR(100),
    `COUNTRY`			VARCHAR(100),
    `LATITUDE`			DECIMAL(15,10),
	`LONGITUDE`			DECIMAL(15,10),

    PRIMARY KEY (IATA_CODE_AIRPORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

-- *************************************************************************************************
-- PARA CREAR LA TABLA PERIODO
DROP PROCEDURE IF EXISTS `Llenar_dimension_periodo`;
DELIMITER $$
CREATE  PROCEDURE `Llenar_dimension_periodo`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO period VALUES (
                        YEAR(currentdate)*100+MONTH(currentdate),
                        DATE_FORMAT(currentdate,'%Y-%m'),
                        YEAR(currentdate),
                        MONTH(currentdate),
                        QUARTER(currentdate),
                        DATE_FORMAT(currentdate,'%M'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 MONTH);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension periodo*/
DROP TABLE IF EXISTS `period`;
CREATE TABLE period (
        `IdPeriod`		INTEGER,  -- year*100+month
		`Period`		VARCHAR(7) NOT NULL,
        `Year`			INTEGER NOT NULL,
        `Month`			INTEGER NOT NULL, -- 1 to 12
        `Quarter`		INTEGER NOT NULL, -- 1 to 4
        `Name month`	VARCHAR(9) NOT NULL, -- 'January', 'February'...
        PRIMARY KEY (IdPeriod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CALL Llenar_dimension_periodo('2002-01-01','2022-12-31');

-- PARA CREAR LA TABLA  CALENDARIO
DROP PROCEDURE IF EXISTS `Llenar_dimension_calendario`;
DELIMITER $$
CREATE  PROCEDURE `Llenar_dimension_calendario`(IN `startdate` DATE, IN `stopdate` DATE)
BEGIN
    DECLARE currentdate DATE;
    SET currentdate = startdate;
    WHILE currentdate < stopdate DO
        INSERT INTO calendar VALUES (
                        YEAR(currentdate)*10000+MONTH(currentdate)*100 + DAY(currentdate),
                        currentdate,
                        YEAR(currentdate)*100+MONTH(currentdate),
                        DAY(currentdate),
                        WEEKOFYEAR(currentdate),
                        DATE_FORMAT(currentdate,'%W'));
        SET currentdate = ADDDATE(currentdate,INTERVAL 1 DAY);
    END WHILE;
END$$
DELIMITER ;

/*Se genera la dimension calendario*/
DROP TABLE IF EXISTS `calendar`;
CREATE TABLE calendar (
        `IdDate`		INTEGER,  -- year*10000+month*100+day
		`Date`			DATE NOT NULL,
	   `IdPeriod`		INTEGER NOT NULL,
        `Day`			INTEGER NOT NULL, -- 1 to 31
        `Week of year`	INTEGER NOT NULL, -- 1 to 52/53
        `Name day`		VARCHAR(9) NOT NULL, -- 'Monday', 'Tuesday'...
        PRIMARY KEY (IdDate),
        FOREIGN KEY(IdPeriod) references period (IdPeriod)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

CALL Llenar_dimension_calendario('2015-01-01','2020-12-31');

-- *******************************************************************************
-- Creamos tabla de dimensiones causas de cancelaciones
DROP TABLE IF EXISTS cancellation;
CREATE TABLE IF NOT EXISTS cancellation (
	`CANCELLATION_REASON`	VARCHAR(4),
  	`DESCRIPTION`			VARCHAR(100),
   
    PRIMARY KEY (CANCELLATION_REASON)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

INSERT INTO cancellation (`CANCELLATION_REASON`, `DESCRIPTION`) 
VALUES ('N', 'not apply'), 
		('A', 'carrier'),
		('B', 'weather'),  
		('C', 'NAS'),  
		('D', 'security');  
        
-- ***************************************************************************
DROP TABLE IF EXISTS flight_2015;
CREATE TABLE IF NOT EXISTS flight_2015 (
	`IdFlight`			VARCHAR(20) NOT NULL,
    `IdDate` 			INTEGER,
	`YEAR`				INTEGER,
    `MONTH`				INTEGER,
    `DAY`				INTEGER,
    `DAY_OF_WEEK`		INTEGER,
    `IATA_CODE_AIRLINE`	VARCHAR(7),
    `TAIL_NUMBER`		VARCHAR(7),
  	`ORIGIN_AIRPORT`	VARCHAR(4), 
    `DESTINATION_AIRPORT`VARCHAR(4),
    `SCHEDULED_DEPARTURE`INTEGER,
    `DEPARTURE_TIME`	FLOAT,
    `DEPARTURE_DELAY`	FLOAT,
	`SCHEDULED_TIME`	FLOAT,
    `ELAPSED_TIME`		FLOAT,
    `AIR_TIME`			FLOAT,
    `DISTANCE`			INTEGER,
    `SCHEDULED_ARRIVAL`	INTEGER,
    `ARRIVAL_TIME`		FLOAT,
    `ARRIVAL_DELAY`		FLOAT,
    `DIVERTED`			INTEGER,
    `CANCELLED`			INTEGER,
    `CANCELLATION_REASON`VARCHAR(1),
    `AIR_SYSTEM_DELAY`	FLOAT,
    `SECURITY_DELAY`	FLOAT,
    `AIRLINE_DELAY`		FLOAT,
    `LATE_AIRCRAFT_DELAY`FLOAT,
    `WEATHER_DELAY`		FLOAT,
    PRIMARY KEY(`IdFlight`),
    FOREIGN KEY(`IdDate`) references calendar (`IdDate`),
    FOREIGN KEY(IATA_CODE_AIRLINE) references airline (IATA_CODE_AIRLINE),
    FOREIGN KEY(CANCELLATION_REASON) references cancellation (CANCELLATION_REASON),
    FOREIGN KEY(TAIL_NUMBER) references plane_data (tailnum),
    FOREIGN KEY(ORIGIN_AIRPORT) references airport (IATA_CODE_AIRPORT),
    FOREIGN KEY(DESTINATION_AIRPORT) references airport (IATA_CODE_AIRPORT)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;	

-- **************************************************************************************
-- Tabla de asientos disponibles
DROP TABLE IF EXISTS available_seat;
CREATE TABLE IF NOT EXISTS available_seat (
	`YEAR`				INTEGER,
    `MONTH`				INTEGER,
    `IdPeriod`			INTEGER NOT NULL,
    `DOMESTIC`			INTEGER,
    `INTERNATIONAL`	INTEGER,
    `TOTAL`			INTEGER,
    FOREIGN KEY(IdPeriod) references period (IdPeriod)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- Tabla de asientos vendidos ¿?
DROP TABLE IF EXISTS revenue_passenger;
CREATE TABLE IF NOT EXISTS revenue_passenger (
	`YEAR`				INTEGER,
    `MONTH`				INTEGER,
    `IdPeriod`			INTEGER NOT NULL, 
    `DOMESTIC`			INTEGER,
    `INTERNATIONAL`	INTEGER,
    `TOTAL`			INTEGER,
    FOREIGN KEY(IdPeriod) references period (IdPeriod)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;
