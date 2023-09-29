if not exists(select * from sys.databases where name='dps_database')
    CREATE DATABASE dps_database
GO

use dps_database
GO

--DOWN
-- drop constraints firsts 
if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_employees_employee_role')
  alter table employees drop constraint fk_employees_employee_role

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_trips_trip_student_id')
  alter table trips drop constraint fk_trips_trip_student_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_trips_trip_employee_id')
  alter table trips drop constraint fk_trips_trip_employee_id

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_trips_trip_starting_location')
  alter table trips drop constraint fk_trips_trip_starting_location

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_trips_trip_arriving_location')
  alter table trips drop constraint fk_trips_trip_arriving_location

if exists (select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  where CONSTRAINT_NAME='fk_trips_trip_car_id')
  alter table trips drop constraint fk_trips_trip_car_id

-- Drop Trip table
DROP TABLE IF EXISTS trips;

-- Drop Student table
DROP TABLE IF EXISTS students;

-- Drop Cars table
DROP TABLE IF EXISTS cars;

-- Drop Location table
DROP TABLE IF EXISTS locations;

-- Drop Employee table
DROP TABLE IF EXISTS employees;

-- Drop Roles table
DROP TABLE IF EXISTS roles;

--UP Metadata
-- Create Roles table
CREATE TABLE roles (
  role_name VARCHAR(50) PRIMARY KEY,
  role_description VARCHAR(100)
);

-- Create Employee table
CREATE TABLE employees (
  employee_id INT PRIMARY KEY,
  employee_firstname VARCHAR(50),
  employee_lastname VARCHAR(50),
  employee_role VARCHAR(50),
  employee_mobile VARCHAR(15),
  CONSTRAINT fk_employees_employee_role FOREIGN KEY (employee_role) REFERENCES Roles(role_name)
);

-- Create Location table
CREATE TABLE locations (
  location_id INT PRIMARY KEY,
  location_address VARCHAR(100),
  location_zipcode VARCHAR(10),
  location_city VARCHAR(50),
  location_state VARCHAR(50)
);

-- Create Cars table
CREATE TABLE cars (
  car_id INT PRIMARY KEY,
  car_register_number VARCHAR(50),
  car_type VARCHAR(50),
  car_year VARCHAR(4)
  CONSTRAINT u_cars_car_register_number unique (car_register_number)
);

-- Create Student table
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  student_suid VARCHAR(10),
  student_firstname VARCHAR(50),
  student_lastname VARCHAR(50),
  student_mobile VARCHAR(15)
  CONSTRAINT u_students_student_suid unique (student_suid)
);

-- Create Trip table
CREATE TABLE trips (
  trip_id INT PRIMARY KEY,
  trip_student_id INT,
  trip_employee_id INT,
  trip_request_start_time DATETIME,
  trip_pickup_time DATETIME,
  trip_arrival_time DATETIME,
  trip_rating INT,
  trip_starting_location INT,
  trip_arriving_location INT,
  trip_car_id INT,
  CONSTRAINT date_range CHECK (trip_pickup_time < trip_arrival_time),
  CONSTRAINT fk_trips_trip_student_id FOREIGN KEY (trip_student_id) REFERENCES students(student_id),
  CONSTRAINT fk_trips_trip_employee_id FOREIGN KEY (trip_employee_id) REFERENCES employees(employee_id),
  CONSTRAINT fk_trips_trip_starting_location FOREIGN KEY (trip_starting_location) REFERENCES locations(location_id),
  CONSTRAINT fk_trips_trip_arriving_location FOREIGN KEY (trip_arriving_location) REFERENCES locations(location_id),
  CONSTRAINT fk_trips_trip_car_id FOREIGN KEY (trip_car_id) REFERENCES cars(car_id)
);


-- populate database
INSERT INTO roles (role_name, role_description)
VALUES ('Driver', 'Responsible for driving students'),
       ('Coordinator', 'Manages trip requests and assigns drivers'),
       ('Maintenance', 'Responsible for vehicle maintenance and repairs'),
       ('Administrator', 'Manages the system and data'),
       ('Accountant', 'Manages finances and billing'),
       ('Instructor', 'Provides training and guidance to students'),
       ('Recruiter', 'Responsible for attracting and hiring new employees'),
       ('Marketing', 'Promotes the services and expands the customer base'),
       ('Human Resources', 'Manages employee relations and benefits'),
       ('IT Support', 'Provides technical assistance and maintains IT infrastructure');

-- Insert Employees
INSERT INTO employees (employee_id, employee_firstname, employee_lastname, employee_role, employee_mobile)
VALUES (1, 'Alex', 'Turner', 'IT Support', '555-123-4567'),
       (2, 'Jane', 'Smith', 'Coordinator', '555-987-6543'),
       (3, 'Mark', 'Brown', 'Maintenance', '555-456-7890'),
       (4, 'Emily', 'Johnson', 'Administrator', '555-321-6549'),
       (5, 'Robert', 'Lee', 'Accountant', '555-123-9876'),
       (6, 'Sophia', 'Hernandez', 'Instructor', '555-654-3210'),
       (7, 'Oliver', 'Garcia', 'Recruiter', '555-123-7890'),
       (8, 'Liam', 'Martinez', 'Marketing', '555-987-1234'),
       (9, 'Charlotte', 'Jackson', 'Human Resources', '555-789-0123'),
       (10, 'Mia', 'White', 'IT Support', '555-123-0123'),
       -- Drivers
       (11, 'Brian', 'Taylor', 'Driver', '555-111-1111'),
       (12, 'Christina', 'Parker', 'Driver', '555-222-2222'),
       (13, 'Daniel', 'Rodriguez', 'Driver', '555-333-3333'),
       (14, 'Eleanor', 'Miller', 'Driver', '555-444-4444'),
       (15, 'Frank', 'Garcia', 'Driver', '555-555-5555'),
       (16, 'Grace', 'Lee', 'Driver', '555-666-6666'),
       (17, 'Henry', 'Martinez', 'Driver', '555-777-7777'),
       (18, 'Isabel', 'Thompson', 'Driver', '555-888-8888'),
       (19, 'Jack', 'Rodriguez', 'Driver', '555-999-9999'),
       (20, 'Kathy', 'Taylor', 'Driver', '555-000-0000'),
       (21, 'Larry', 'Wilson', 'Driver', '555-010-1010'),
       (22, 'Molly', 'Anderson', 'Driver', '555-020-2020'),
       (23, 'Nathan', 'Thomas', 'Driver', '555-030-3030'),
       (24, 'Olivia', 'Moore', 'Driver', '555-040-4040'),
       (25, 'Patrick', 'Lee', 'Driver', '555-050-5050'),
       (26, 'Rachel', 'Jackson', 'Driver', '555-060-6060'),
       (27, 'Samuel', 'White', 'Driver', '555-070-7070'),
       (28, 'Tina', 'Harris', 'Driver', '555-080-8080'),
       (29, 'Uma', 'Martin', 'Driver', '555-090-9090'),
       (30, 'Victor', 'Clark', 'Driver', '555-100-0001');

-- Insert Locations
INSERT INTO locations (location_id, location_address, location_zipcode, location_city, location_state)
VALUES (1, '9135 Bartelt Lane', '12205', 'Syracuse', 'New York'),
       (2, '912 Crownhardt Circle', '14225', 'Syracuse', 'New York'),
       (3, '491 Browning Parkway', '11205', 'Syracuse', 'New York'),
       (4, '4 Schlimgen Street', '11854', 'Syracuse', 'New York'),
       (5, '91 Coolidge Hill', '10175', 'Syracuse', 'New York'),
       (6, '19 Westport Point', '10469', 'Syracuse', 'New York'),
       (7, '38720 Prentice Way', '12247', 'Syracuse', 'New York'),
       (8, '67 Melrose Pass', '14604', 'Syracuse', 'NY'),
       (9, '94947 Boyd Junction', '14225', 'Syracuse', 'NY'),
       (10, '963 Grayhawk Avenue', '14604', 'Syracuse', 'NY');

-- Insert Cars
INSERT INTO cars (car_id, car_register_number, car_type, car_year)
VALUES (1, 'ABC-123', 'Sedan', '2020'),
       (2, 'XYZ-789', 'Van', '2019'),
       (3, 'DEF-456', 'SUV', '2018'),
       (4, 'GHI-012', 'Sedan', '2021'),
       (5, 'JKL-345', 'Van', '2019'),
       (6, 'MNO-678', 'SUV', '2017'),
       (7, 'PQR-901', 'Sedan', '2022'),
       (8, 'STU-234', 'Van', '2018'),
       (9, 'VWX-567', 'SUV', '2021'),
       (10, 'YZA-890', 'Sedan', '2020'),
       (11, 'AAB-123', 'Sedan', '2019'),
       (12, 'XYY-789', 'Van', '2020'),
       (13, 'DFF-456', 'SUV', '2017'),
       (14, 'GHJ-012', 'Sedan', '2022'),
       (15, 'JKM-345', 'Van', '2018'),
       (16, 'MNP-678', 'SUV', '2019'),
       (17, 'PQS-901', 'Sedan', '2021'),
       (18, 'STV-234', 'Van', '2020'),
       (19, 'VWY-567', 'SUV', '2018'),
       (20, 'YAB-890', 'Sedan', '2019');

-- Insert Students
INSERT INTO students (student_id, student_suid, student_firstname, student_lastname, student_mobile)
VALUES (1, '246292306', 'Alice', 'Johnson', '555-111-2222'),
       (2, '576945736', 'Bob', 'Williams', '555-333-4444'),
       (3, '576164651', 'Chris', 'Miller', '555-555-6666'),
       (4, '613764941', 'David', 'Anderson', '555-777-8888'),
       (5, '364579146', 'Emma', 'Thomas', '555-999-0000'),
       (6, '808764347', 'Fiona', 'Taylor', '555-111-3333'),
       (7, '569184202', 'George', 'Moore', '555-444-5555'),
       (8, '303645987', 'Hannah', 'Clark', '555-666-7777'),
       (9, '294815213', 'Ian', 'Johnson', '555-888-9999'),
       (10, '946761377', 'Jack', 'Lewis', '555-000-1111'),
       (11, '123456789', 'Lily', 'Parker', '555-234-5678'),
       (12, '234567890', 'Mason', 'Nguyen', '555-345-6789'),
       (13, '345678901', 'Nora', 'Phillips', '555-456-7890'),
       (14, '456789012', 'Aiden', 'Edwards', '555-567-8901'),
       (15, '567890123', 'Scarlett', 'Baker', '555-678-9012'),
       (16, '678901234', 'Lucas', 'Adams', '555-789-0123'),
       (17, '789012345', 'Grace', 'Sanchez', '555-890-1234'),
       (18, '890123456', 'Benjamin', 'Mitchell', '555-901-2345'),
       (19, '901234567', 'Aubrey', 'Perez', '555-012-3456'),
       (20, '012345678', 'Daniel', 'Carter', '555-123-4567'),
       (21, '123450987', 'Chloe', 'Roberts', '555-234-5679'),
       (22, '234560123', 'Jackson', 'Campbell', '555-345-6789'),
       (23, '345670456', 'Zoey', 'Turner', '555-456-7890'),
       (24, '456780789', 'Jayden', 'Morgan', '555-567-8901'),
       (25, '567890987', 'Eliana', 'Cook', '555-678-9012'),
       (26, '678900123', 'Sebastian', 'Rogers', '555-789-0123'),
       (27, '789010456', 'Stella', 'Peterson', '555-890-1234'),
       (28, '890120789', 'Jeremiah', 'Cooper', '555-901-2345'),
       (29, '901230123', 'Hazel', 'Reed', '555-012-3456'),
       (30, '012340456', 'Zachary', 'Graham', '555-123-4567'),
       (31, '123450789', 'Lila', 'Long', '555-234-5680'),
       (32, '234560987', 'Brandon', 'Fisher', '555-345-6789'),
       (33, '345670123', 'Violet', 'Patterson', '555-456-7890'),
       (34, '456780456', 'Michael', 'Bell', '555-989-8514'),
       (35, '567890124', 'Isabella', 'Kelly', '555-567-8901'),
       (36, '678900456', 'Tyler', 'Simmons', '555-678-9012'),
       (37, '789010789', 'Madeline', 'Bennett', '555-789-0123'),
       (38, '890120124', 'Nathan', 'Jenkins', '555-890-1234'),
       (39, '901230456', 'Lucy', 'Ward', '555-901-2345'),
       (40, '012340789', 'Carter', 'Chapman', '555-012-3456'),
       (41, '123450123', 'Leah', 'Arnold', '555-123-4567'),
       (42, '234560456', 'Gabriel', 'Harper', '555-234-5678'),
       (43, '345670789', 'Riley', 'Duncan', '555-345-6789'),
       (44, '456780123', 'Leo', 'Hawkins', '555-456-7890'),
       (45, '567890457', 'Mila', 'Hunter', '555-567-8901'),
       (46, '678900789', 'Adam', 'George', '555-678-9012'),
       (47, '789010124', 'Natalie', 'Cunningham', '555-789-0123'),
       (48, '890120456', 'Jaxon', 'Rhodes', '555-890-1234'),
       (49, '901230789', 'Aurora', 'Miles', '555-901-2345'),
       (50, '012340124', 'Ethan', 'Barnett', '555-012-3456');


-- Insert Trips
INSERT INTO trips (trip_id, trip_student_id, trip_employee_id, trip_request_start_time, trip_pickup_time, trip_arrival_time, trip_rating, trip_starting_location, trip_arriving_location, trip_car_id)
VALUES (1, 1, 11, '2023-04-05 20:00:00', '2023-04-05 20:15:00', '2023-04-05 20:45:00', 5, 1, 2, 1),
       (2, 2, 11, '2023-04-05 21:00:00', '2023-04-05 21:15:00', '2023-04-05 21:45:00', 4, 2, 1, 2),
       (3, 3, 12, '2023-04-06 20:00:00', '2023-04-06 20:15:00', '2023-04-06 20:45:00', 5, 3, 4, 3),
       (4, 4, 12, '2023-04-06 21:00:00', '2023-04-06 21:15:00', '2023-04-06 21:45:00', 4, 4, 3, 4),
       (5, 5, 13, '2023-04-07 22:00:00', '2023-04-07 22:15:00', '2023-04-07 22:45:00', 5, 5, 6, 5),
       (6, 6, 13, '2023-04-08 23:00:00', '2023-04-08 23:15:00', '2023-04-08 23:45:00', 4, 6, 5, 6),
       (7, 7, 14, '2023-04-08 00:00:00', '2023-04-08 00:15:00', '2023-04-08 00:45:00', 5, 7, 8, 7),
       (8, 8, 14, '2023-04-08 01:00:00', '2023-04-08 01:15:00', '2023-04-08 01:45:00', 4, 8, 7, 8),
       (9, 9, 15, '2023-04-09 02:00:00', '2023-04-09 02:15:00', '2023-04-09 02:45:00', 5, 9, 10, 9),
       (10, 10, 15, '2023-04-09 03:00:00', '2023-04-09 03:15:00', '2023-04-09 03:45:00', 4, 10, 9, 10),
       (11, 11, 16, '2023-04-10 20:00:00', '2023-04-10 20:15:00', '2023-04-10 20:45:00', 5, 1, 2, 11),
       (12, 12, 16, '2023-04-10 21:00:00', '2023-04-10 21:15:00', '2023-04-10 21:45:00', 4, 2, 1, 12),
       (13, 13, 17, '2023-04-11 22:00:00', '2023-04-11 22:15:00', '2023-04-11 22:45:00', 5, 3, 4, 13),
       (14, 14, 17, '2023-04-12 23:00:00', '2023-04-12 23:15:00', '2023-04-12 23:45:00', 4, 4, 3, 14),
       (15, 15, 18, '2023-04-13 00:00:00', '2023-04-13 00:15:00', '2023-04-13 00:45:00', 5, 5, 6, 15),
       (16, 16, 18, '2023-04-13 01:00:00', '2023-04-13 01:15:00', '2023-04-13 01:45:00', 4, 6, 5, 16),
       (17, 17, 19, '2023-04-14 02:00:00', '2023-04-14 02:15:00', '2023-04-14 02:45:00', 5, 7, 8, 17),
       (18, 18, 19, '2023-04-15 03:00:00', '2023-04-15 03:15:00', '2023-04-15 03:45:00', 4, 8, 7, 18),
       (19, 19, 20, '2023-04-15 04:00:00', '2023-04-15 04:15:00', '2023-04-15 04:45:00', 5, 9, 10, 19),
       (20, 20, 20, '2023-04-15 05:00:00', '2023-04-15 05:15:00', '2023-04-15 05:45:00', 4, 10, 9, 20),
       (21, 21, 21, '2023-04-16 20:00:00', '2023-04-16 20:15:00', '2023-04-16 20:45:00', 5, 1, 2, 1),
       (22, 22, 11, '2023-04-16 21:00:00', '2023-04-16 21:15:00', '2023-04-16 21:45:00', 4, 2, 1, 2),
       (23, 23, 22, '2023-04-17 22:00:00', '2023-04-17 22:15:00', '2023-04-17 22:45:00', 5, 3, 4, 3),
       (24, 24, 12, '2023-04-18 23:00:00', '2023-04-18 23:15:00', '2023-04-18 23:45:00', 4, 4, 3, 4),
       (25, 25, 23, '2023-04-19 00:00:00', '2023-04-19 00:15:00', '2023-04-19 00:45:00', 5, 5, 6, 5),
       (26, 26, 13, '2023-04-19 01:00:00', '2023-04-19 01:15:00', '2023-04-19 01:45:00', 4, 6, 5, 6),
       (27, 27, 24, '2023-04-20 02:00:00', '2023-04-20 02:15:00', '2023-04-20 02:45:00', 5, 7, 8, 7),
       (28, 28, 14, '2023-04-20 03:00:00', '2023-04-20 03:15:00', '2023-04-20 03:45:00', 4, 8, 7, 8),
       (29, 29, 25, '2023-04-21 04:00:00', '2023-04-21 04:15:00', '2023-04-21 04:45:00', 5, 9, 10, 9),
       (30, 30, 15, '2023-04-21 05:00:00', '2023-04-21 05:15:00', '2023-04-21 05:45:00', 4, 10, 9, 10),
       (31, 31, 26, '2023-04-22 20:00:00', '2023-04-22 20:15:00', '2023-04-22 20:45:00', 5, 1, 2, 11),
       (32, 32, 16, '2023-04-22 21:00:00', '2023-04-22 21:15:00', '2023-04-22 21:45:00', 4, 2, 1, 12),
       (33, 33, 27, '2023-04-23 22:00:00', '2023-04-23 22:15:00', '2023-04-23 22:45:00', 5, 3, 4, 13),
       (34, 34, 17, '2023-04-24 23:00:00', '2023-04-24 23:15:00', '2023-04-24 23:45:00', 4, 4, 3, 14),
       (35, 35, 28, '2023-04-25 00:00:00', '2023-04-25 00:15:00', '2023-04-25 00:45:00', 5, 5, 6, 15),
       (36, 36, 18, '2023-04-25 01:00:00', '2023-04-25 01:15:00', '2023-04-25 01:45:00', 4, 6, 5, 16),
       (37, 37, 29, '2023-04-26 02:00:00', '2023-04-26 02:15:00', '2023-04-26 02:45:00', 5, 7, 8, 17),
       (38, 38, 19, '2023-04-26 03:00:00', '2023-04-26 03:15:00', '2023-04-26 03:45:00', 4, 8, 7, 18),
       (39, 39, 30, '2023-04-27 04:00:00', '2023-04-27 04:15:00', '2023-04-27 04:45:00', 5, 9, 10, 19),
       (40, 40, 20, '2023-04-27 05:00:00', '2023-04-27 05:15:00', '2023-04-27 05:45:00', 4, 10, 9, 20),
       (41, 41, 19, '2023-04-28 20:00:00', '2023-04-28 20:15:00', '2023-04-28 20:45:00', 5, 1, 2, 1),
       (42, 42, 17, '2023-04-28 21:00:00', '2023-04-28 21:15:00', '2023-04-28 21:45:00', 4, 2, 1, 2),
       (43, 43, 14, '2023-04-29 22:00:00', '2023-04-29 22:15:00', '2023-04-29 22:45:00', 5, 3, 4, 3),
       (44, 44, 12, '2023-04-30 23:00:00', '2023-04-30 23:15:00', '2023-04-30 23:45:00', 4, 4, 3, 4),
       (45, 45, 17, '2023-05-01 00:00:00', '2023-05-01 00:15:00', '2023-05-01 00:45:00', 5, 5, 6, 5),
       (46, 46, 13, '2023-05-01 01:00:00', '2023-05-01 01:15:00', '2023-05-01 01:45:00', 4, 6, 5, 6),
       (47, 47, 14, '2023-05-02 02:00:00', '2023-05-02 02:15:00', '2023-05-02 02:45:00', 5, 7, 8, 7),
       (48, 48, 11, '2023-05-02 03:00:00', '2023-05-02 03:15:00', '2023-05-02 03:45:00', 4, 8, 7, 8),
       (49, 49, 15, '2023-05-03 04:00:00', '2023-05-03 04:15:00', '2023-05-03 04:45:00', 5, 9, 10, 9),
       (50, 50, 11, '2023-05-03 05:00:00', '2023-05-03 05:15:00', '2023-05-03 05:45:00', 4, 10, 9, 10);






-- Get table constraints for Roles table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'roles';

-- Get table constraints for Employee table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'employees';

-- Get table constraints for Location table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'locations';

-- Get table constraints for Cars table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'cars';

-- Get table constraints for Student table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'students';

-- Get table constraints for Trip table
SELECT *
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'trips';
--UP Data

--Verify
-- Verify Roles table
SELECT * FROM roles;
-- Verify Employee table
SELECT * FROM employees;
-- Verify Location table
SELECT * FROM locations;
-- Verify Cars table
SELECT * FROM cars;
-- Verify Student table
SELECT * FROM students;
-- Verify Trip table
SELECT * FROM trips;

-- procedures
drop procedure if exists p_add_trip
GO
create PROCEDURE dbo.p_add_trip(
    @trip_student_id int,
    @trip_employee_id int,
    @trip_request_start_time datetime,
    @trip_pickup_time datetime, 
    @trip_arrival_time datetime,
    @trip_rating varchar(20),
    @trip_starting_location int,
    @trip_arriving_location int,
    @trip_car_id int
) as BEGIN
    begin transaction 
        begin try 
        declare @id int = (select max(trip_id) from trips) +1
            if  @trip_rating > 5
                throw 50001, 'rating_value accepted values: 1:5',1
            
            insert into trips 
            (trip_id,trip_student_id, trip_employee_id, trip_request_start_time, trip_pickup_time, trip_arrival_time, trip_rating, trip_starting_location, trip_arriving_location, trip_car_id)
            values (@id, @trip_student_id, @trip_employee_id, @trip_request_start_time, @trip_pickup_time, @trip_arrival_time, @trip_rating, @trip_starting_location, @trip_arriving_location, @trip_car_id)
            COMMIT
            return @@identity
        end try 
        begin catch 
            ROLLBACK
            ;
            THROW
        end CATCH
    END
  GO

execute dbo.p_add_trip
@trip_student_id = 1,
@trip_employee_id = 1,
@trip_request_start_time = '2023-04-09 05:00:00',
@trip_pickup_time = '2023-04-09 05:00:00', 
@trip_arrival_time = '2023-04-09 05:00:00',
@trip_rating ='6',
@trip_starting_location = 1,
@trip_arriving_location = 1,
@trip_car_id = 1
  
-- trigger: check date before and after 
drop trigger if exists t_pickup_arrival
go
CREATE TRIGGER t_pickup_arrival
ON trips
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT *
        FROM inserted
        WHERE trip_request_start_time >= trip_pickup_time
    )
    BEGIN
        RAISERROR('trip_request_start_time must be before trip_pickup_time', 16, 1)
        ROLLBACK TRANSACTION
    END
END;
-- Query to find the employee of the month:*
SELECT employee_id, SUM(DATEDIFF (MINUTE, trips.trip_pickup_time, trips.trip_arrival_time)) AS running_total_duration, employees.employee_firstname, employees.employee_lastname
FROM trips, employees
WHERE employee_id = trip_employee_id
GROUP BY employee_id, employee_firstname,employee_lastname;

--Query to find the highest number of trips at a particular starting location
SELECT 
  locations.location_address AS starting_location,
  COUNT(*) AS num_trips
FROM 
  trips 
  JOIN locations ON trips.trip_starting_location = locations.location_id 
GROUP BY 
  trip_starting_location, location_address
ORDER BY 
  num_trips DESC;

--Query to find the top 3 students with the highest average trip ratings, along with their individual trip ratings:
SELECT 
    c.car_register_number, COUNT(t.trip_id) AS trip_count
FROM 
    cars c
    LEFT JOIN trips t ON c.car_id = t.trip_car_id
GROUP BY 
    c.car_id, car_register_number
ORDER BY 
    trip_count DESC;

-- Query to find the number of trips per student
SELECT location_address, COUNT(*) AS trip_count, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage
FROM locations
JOIN trips ON locations.location_id = trips.trip_starting_location
GROUP BY location_id,location_address
ORDER BY percentage DESC;

-- Query to find the employee who has completed the most trips
SELECT employee_firstname, employee_lastname, COUNT(*) AS trip_count
FROM employees
JOIN trips ON employees.employee_id = trips.trip_employee_id
GROUP BY employee_id, employee_firstname, employee_lastname
ORDER BY trip_count DESC
 
 



 

