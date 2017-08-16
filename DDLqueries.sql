drop schema IF EXISTS dbms_projectphase3;
create schema dbms_projectphase3;
use dbms_projectphase3;

CREATE TABLE IF NOT EXISTS Hall (
    hall_id VARCHAR(25) ,
    capacity VARCHAR(10),
    availability_label VARCHAR(5),
    location VARCHAR(10),
    name_hall VARCHAR(120),
    PRIMARY KEY (hall_id)
);

DELIMITER $$
DROP TRIGGER IF EXISTS dbms_projectphase3.hall_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `dbms_projectphase3`.`hall_BEFORE_INSERT` BEFORE INSERT ON `hall` FOR EACH ROW
BEGIN
IF NEW.capacity = 0 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
          END IF;
END$$
DELIMITER ;
CREATE TABLE IF NOT EXISTS Auditorium (
    hall_id VARCHAR(25) NOT NULL,
    stage_size VARCHAR(25),
    green_rooms INT(5),
    CONSTRAINT FOREIGN KEY (hall_id)
        REFERENCES hall (hall_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.auditorium_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`auditorium_BEFORE_INSERT` BEFORE INSERT ON `auditorium` FOR EACH ROW
BEGIN
IF NEW.stage_size <= '0' or NEW.green_rooms <= 0
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
          END IF;
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS Screen (
    hall_id VARCHAR(25) NOT NULL,
    size VARCHAR(25),
    screen_type VARCHAR(20),
    experience VARCHAR(10),
    CONSTRAINT FOREIGN KEY (hall_id)
        REFERENCES hall (hall_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER $$

DROP TRIGGER IF EXISTS dbms_projectphase3.screen_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`screen_BEFORE_INSERT` BEFORE INSERT ON `screen` FOR EACH ROW
BEGIN
IF NEW.size = '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
          END IF;
END$$
DELIMITER ;

DELIMITER $$

DROP TRIGGER IF EXISTS dbms_projectphase3.hall_AFTER_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`hall_AFTER_INSERT` AFTER INSERT ON `hall` FOR EACH ROW
BEGIN
DECLARE HALLcount INT;
DECLARE SCREENcount INT;
DECLARE Audicount INT;
set HALLcount = (select COUNT(HALL_ID) from HALL );
SET SCREENcount = (select COUNT(HALL_ID) from SCREEN );
SET Audicount = (select COUNT(HALL_ID) from auditorium );
IF SCREENcount + Audicount > HALLcount
		THEN
			SIGNAL SQLSTATE '45000'
				  SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
    END IF;
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS shows (
    show_id VARCHAR(25),
    show_name VARCHAR(100),
    PRIMARY KEY (show_id)
);


DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.shows_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `dbms_projectphase3`.`shows_BEFORE_INSERT` BEFORE INSERT ON `shows` FOR EACH ROW
BEGIN
IF NEW.show_name = '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
          END IF;
 
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS reservation (
    r_id VARCHAR(25),
    r_date DATE,
    r_time TIME,
    hall_id VARCHAR(25) NOT NULL,
    show_id VARCHAR(25) NOT NULL,
    PRIMARY KEY (r_id),
    CONSTRAINT FOREIGN KEY (hall_id)
        REFERENCES hall (hall_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (show_id)
        REFERENCES shows (show_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX index_reservation ON reservation (r_date);

DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.reservation_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`reservation_BEFORE_INSERT` BEFORE INSERT ON `reservation` FOR EACH ROW
BEGIN
IF NEW.r_date = 0 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
  END IF;
 
END$$
DELIMITER ;


CREATE TABLE IF NOT EXISTS movie (
    show_id VARCHAR(25),
    release_date INT(10),
    movie_cast VARCHAR(60),
    director VARCHAR(40),
    rating VARCHAR(25),
    CONSTRAINT FOREIGN KEY (show_id)
        REFERENCES shows (show_id)
);

DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.movie_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`movie_BEFORE_INSERT` BEFORE INSERT ON `movie` FOR EACH ROW
BEGIN
IF NEW.rating < '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input ';
          END IF;
 
 
END$$
DELIMITER ;



CREATE TABLE IF NOT EXISTS performance (
    show_id VARCHAR(25),
    performers VARCHAR(50),
    performance_type VARCHAR(25),
    CONSTRAINT FOREIGN KEY (show_id)
        REFERENCES shows (show_id)
);

 
DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.performance_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`performance_BEFORE_INSERT` BEFORE INSERT ON `performance` FOR EACH ROW
BEGIN
IF NEW.performers = '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
  END IF;
 
 
END$$
DELIMITER ;


CREATE TABLE IF NOT EXISTS eventTable (
    e_id mediumint NOT NULL auto_increment,
    show_id VARCHAR(25) NOT NULL,
    time_event TIME,
    date_event DATE,
    ticket_price VARCHAR(10),
    PRIMARY KEY (e_id),
    CONSTRAINT FOREIGN KEY (show_id)
        REFERENCES shows (show_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX index_eventtable ON eventTable (date_event);

USE `dbms_projectphase3`;
 
DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.eventTable_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`eventTable_BEFORE_INSERT` BEFORE INSERT ON `eventTable` FOR EACH ROW
BEGIN
IF NEW.ticket_price <= '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
  END IF;
 
 
END$$
DELIMITER ;
DELIMITER $$

DROP TRIGGER IF EXISTS dbms_projectphase3.eventtable_AFTER_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`eventtable_AFTER_INSERT` AFTER INSERT ON `eventtable` FOR EACH ROW
BEGIN
DECLARE EVENTDATE INT;
set EVENTDATE = (select count(*) from eventTable ET, reservation  RES WHERE ET.show_id  = RES.show_id  and ET.date_event  < RES.R_DATE) ;

	IF EVENTDATE != 0
		THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
	END IF;
END$$
DELIMITER ;

CREATE TABLE IF NOT EXISTS customer (
    customer_id mediumint NOT NULL auto_increment,
    customer_name VARCHAR(25),
    phone_no VARCHAR(25),
    email_id VARCHAR(70),
    payment_details VARCHAR(25),
    PRIMARY KEY (customer_id)
);

CREATE TABLE IF NOT EXISTS booking (
    booking_id mediumint NOT NULL auto_increment,
    e_id mediumint NOT NULL,
    customer_id mediumint NOT NULL,
    num_tickets INT(3),
    price INT(10),
    booking_date DATE,
    booking_time TIME,
    booking_lable VARCHAR(10),
    PRIMARY KEY (booking_id),
    index(booking_date),
    CONSTRAINT FOREIGN KEY (e_id)
        REFERENCES eventTable (e_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
USE `dbms_projectphase3`;
 
DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.booking_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`booking_BEFORE_INSERT` BEFORE INSERT ON `booking` FOR EACH ROW
BEGIN
IF NEW.num_tickets <= 0 or new.price = 0 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
  END IF;
 
 
END$$
DELIMITER ;

DELIMITER $$
 
DROP TRIGGER IF EXISTS dbms_projectphase3.customer_BEFORE_INSERT$$
USE `dbms_projectphase3`$$
CREATE DEFINER = CURRENT_USER TRIGGER `dbms_projectphase3`.`customer_BEFORE_INSERT` BEFORE INSERT ON `customer` FOR EACH ROW
BEGIN
IF NEW.phone_no = '0' 
          THEN
               SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'Cannot add or update row: invalid input';
  END IF;
END$$
DELIMITER ;

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/shows.csv'
INTO TABLE shows
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(show_id, show_name);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/movies.csv'
INTO TABLE movie
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(show_id,movie_cast, release_date, director, rating);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/performances.csv'
INTO TABLE performance
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(show_id, performers, performance_type);


LOAD DATA LOCAL INFILE 'C:/DBMS_Project/customer.csv'
INTO TABLE customer
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(customer_id,customer_name, phone_no, email_id, payment_details );

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/hall.csv'
INTO TABLE hall
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(hall_id, capacity, availability_label, location, name_hall);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/auditorium.csv'
INTO TABLE auditorium
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(hall_id, stage_size, green_rooms);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/screen.csv'
INTO TABLE screen
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(hall_id, size, screen_type, experience);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/reservation.csv'
INTO TABLE reservation
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(r_id, show_id, hall_id, r_date, r_time);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/eventTable.csv'
INTO TABLE eventtable
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(e_id, show_id, time_event, date_event, ticket_price);

LOAD DATA LOCAL INFILE 'C:/DBMS_Project/booking.csv'
INTO TABLE booking
FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(booking_id, e_id, customer_id, num_tickets, price, booking_date, booking_time, booking_lable);


SET @a='no';

insert into hall values('1001','1022',@a,'Tempe','Improv');
