CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    customer_code VARCHAR(10) GENERATED ALWAYS AS 
        ('CUST' || LPAD(customer_id::TEXT, 3, '0')) STORED,

    customer_fname VARCHAR(30) NOT NULL,
    customer_lname VARCHAR(30) NOT NULL,
    contact_number VARCHAR(11) NOT NULL UNIQUE,
    customer_email VARCHAR(50) UNIQUE,

    address_house_number VARCHAR(50) NOT NULL,
    barangay VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customers (
customer_fname, customer_lname, contact_number, customer_email,
address_house_number, barangay, city, province
)
VALUES
('Nico','Nunez','09170000001','nico1@gmail.com','12A','Bucandala','Imus','Cavite'),
('Nicole','Pizarro','09170000002','nicole@gmail.com','45B','Anabu','Imus','Cavite'),
('Nilo','Perez','09170000003','nilo@gmail.com','78C','Bayanan','Dasma','Cavite'),
('James','Vea','09170000004','james@gmail.com','11D','Salawag','Dasma','Cavite'),
('AJ','Mayormente','09170000005','aj@gmail.com','22E','Habay','Bacoor','Cavite'),
('Bong','Sigayan','09170000006','bong@gmail.com','33F','Mambog','Bacoor','Cavite'),
('Jasper','Durana','09170000007','jasper@gmail.com','44G','Talon','Las Pinas','Metro Manila'),
('Vic','Ventura','09170000008','vic@gmail.com','55H','Moonwalk','Paranaque','Metro Manila'),
('Renyl','Dionson','09170000009','renyl@gmail.com','66I','BF Homes','Paranaque','Metro Manila'),
('Philip','Villegas','09170000010','philip@gmail.com','77J','Don Bosco','Paranaque','Metro Manila'),
('Yshin','Jimenez','09170000011','yshin@gmail.com','88K','Zapote','Bacoor','Cavite'),
('Harell','Diaz','09170000012','harell@gmail.com','99L','Talaba','Bacoor','Cavite'),
('Andrei','Magpali','09170000013','andrei@gmail.com','101M','Manggahan','Gen Trias','Cavite'),
('Carlo','Reyes','09170000014','carlo@gmail.com','202N','Pasong Kawayan','Gen Trias','Cavite'),
('Mark','Santos','09170000015','mark@gmail.com','303O','Langkaan','Dasma','Cavite'),
('Paolo','Cruz','09170000016','paolo@gmail.com','404P','San Agustin','Dasma','Cavite'),
('Kevin','Lopez','09170000017','kevin@gmail.com','505Q','Poblacion','Makati','Metro Manila'),
('Ryan','Garcia','09170000018','ryan@gmail.com','606R','Guadalupe','Makati','Metro Manila'),
('Leo','Torres','09170000019','leo@gmail.com','707S','Fort Bonifacio','Taguig','Metro Manila'),
('Ian','Morales','09170000020','ian@gmail.com','808T','Ususan','Taguig','Metro Manila');

CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    booking_code VARCHAR(10) GENERATED ALWAYS AS 
        ('B' || LPAD(booking_id::TEXT, 3, '0')) STORED,

    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    unit_id INT NOT NULL,

    booking_date DATE NOT NULL,

    service_house_number VARCHAR(50) NOT NULL,
    service_barangay VARCHAR(50) NOT NULL,
    service_city VARCHAR(50) NOT NULL,
    service_province VARCHAR(50) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (service_id)
        REFERENCES services(service_id),

    FOREIGN KEY (unit_id)
        REFERENCES aircon_units(unit_id)
);

INSERT INTO bookings (
customer_id, service_id, unit_id,
booking_date,
service_house_number, service_barangay, service_city, service_province,
status
)
VALUES
(101,101,101,'2026-05-01','12A','Bucandala','Imus','Cavite','Pending'),
(102,102,102,'2026-05-02','45B','Anabu','Imus','Cavite','In Progress'),
(103,103,103,'2026-05-03','78C','Bayanan','Dasma','Cavite','Completed'),
(104,104,104,'2026-05-04','11D','Salawag','Dasma','Cavite','Pending'),
(105,105,105,'2026-05-05','22E','Habay','Bacoor','Cavite','Completed'),
(106,101,106,'2026-05-06','33F','Mambog','Bacoor','Cavite','In Progress'),
(107,102,107,'2026-05-07','44G','Talon','Las Pinas','Metro Manila','Pending'),
(108,103,108,'2026-05-08','55H','Moonwalk','Paranaque','Metro Manila','Completed'),
(109,104,109,'2026-05-09','66I','BF Homes','Paranaque','Metro Manila','Pending'),
(110,105,110,'2026-05-10','77J','Don Bosco','Paranaque','Metro Manila','Completed'),
(111,101,111,'2026-05-11','88K','Zapote','Bacoor','Cavite','Pending'),
(112,102,112,'2026-05-12','99L','Talaba','Bacoor','Cavite','In Progress'),
(113,103,113,'2026-05-13','101M','Manggahan','Gen Trias','Cavite','Completed'),
(114,104,114,'2026-05-14','202N','Pasong Kawayan','Gen Trias','Cavite','Pending'),
(115,105,115,'2026-05-15','303O','Langkaan','Dasma','Cavite','Completed'),
(116,101,116,'2026-05-16','404P','San Agustin','Dasma','Cavite','In Progress'),
(117,102,117,'2026-05-17','505Q','Poblacion','Makati','Metro Manila','Pending'),
(118,103,118,'2026-05-18','606R','Guadalupe','Makati','Metro Manila','Completed'),
(119,104,119,'2026-05-19','707S','Fort Bonifacio','Taguig','Metro Manila','Pending'),
(120,105,120,'2026-05-20','808T','Ususan','Taguig','Metro Manila','Completed');


CREATE TABLE services (
    service_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    service_code VARCHAR(10) GENERATED ALWAYS AS 
        ('SV' || LPAD(service_id::TEXT, 3, '0')) STORED,

    service_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

INSERT INTO services (service_name, price)
VALUES
('Aircon Cleaning', 800.00),
('Aircon Repair', 1200.00),
('Aircon Installation', 2500.00),
('Freon Refill', 1500.00),
('General Maintenance', 1000.00);

CREATE TABLE aircon_units (
    unit_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    customer_id INT NOT NULL,

    brand VARCHAR(50),
    model VARCHAR(50),
    unit_type VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

INSERT INTO aircon_units (customer_id, brand, model, unit_type)
VALUES
(101,'LG','DualCool','Split'),
(102,'Samsung','WindFree','Split'),
(103,'Carrier','Optima','Window'),
(104,'Panasonic','Econavi','Split'),
(105,'Daikin','Inverter','Split'),
(106,'Kolin','KAG','Window'),
(107,'TCL','Elite','Split'),
(108,'Sharp','Plasmacluster','Window'),
(109,'Hitachi','RAS','Split'),
(110,'Condura','Basic','Window'),
(111,'LG','Smart Inverter','Split'),
(112,'Samsung','AR Series','Window'),
(113,'Carrier','Inverter','Split'),
(114,'Panasonic','Sky Series','Window'),
(115,'Daikin','Premium','Split'),
(116,'Kolin','Standard','Split'),
(117,'TCL','CoolPro','Window'),
(118,'Sharp','Eco','Window'),
(119,'Hitachi','Premium','Split'),
(120,'Condura','Energy Saver','Split');

CREATE TABLE technicians (
    technician_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    technician_fname VARCHAR(30) NOT NULL,
    technician_lname VARCHAR(30) NOT NULL,
    contact_number VARCHAR(11),
    specialization VARCHAR(50)
);

INSERT INTO technicians (
technician_fname, technician_lname, contact_number, specialization
)
VALUES
('Mark','Dela Cruz','09910000001','Cleaning'),
('John','Reyes','09910000002','Repair'),
('Luis','Torres','09910000003','Installation'),
('Paulo','Santos','09910000004','Electrical'),
('Ramon','Garcia','09910000005','Freon'),
('Jomar','Lopez','09910000006','General'),
('Erwin','Cruz','09910000007','Repair'),
('Neil','Rivera','09910000008','Installation'),
('Bryan','Mendoza','09910000009','Cleaning'),
('Carlo','Navarro','09910000010','Maintenance'),
('Jason','Pascual','09910000011','Repair'),
('Miguel','Flores','09910000012','Cooling'),
('Ian','Morales','09910000013','Electrical'),
('Kevin','Dizon','09910000014','Freon'),
('Alfred','Castro','09910000015','Installation'),
('Ronald','Villar','09910000016','Repair'),
('Edgar','Domingo','09910000017','Inspection'),
('Paolo','Aquino','09910000018','Freon'),
('Jeff','Bautista','09910000019','Maintenance'),
('Henry','Lim','09910000020','General');

CREATE TABLE booking_technicians (
    assignment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    booking_id INT NOT NULL,
    technician_id INT NOT NULL,

    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE,

    FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
);

INSERT INTO booking_technicians (booking_id, technician_id)
VALUES
(101,1),(102,2),(103,3),(104,4),(105,5),
(106,6),(107,7),(108,8),(109,9),(110,10),
(111,11),(112,12),(113,13),(114,14),(115,15),
(116,16),(117,17),(118,18),(119,19),(120,20);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,

    payment_method VARCHAR(20)
        CHECK (payment_method IN ('GCASH', 'CASH', 'MAYA', 'DEBIT CARD')),

    status VARCHAR(20) DEFAULT 'Paid',

    payment_date DATE DEFAULT CURRENT_DATE,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

INSERT INTO payments (booking_id, amount, payment_method, status)
VALUES
(101,800,'GCASH','Paid'),
(102,1200,'CASH','Paid'),
(103,2500,'MAYA','Paid'),
(104,1500,'GCASH','Paid'),
(105,1000,'DEBIT CARD','Paid'),
(106,800,'CASH','Paid'),
(107,1200,'GCASH','Paid'),
(108,2500,'MAYA','Paid'),
(109,1500,'CASH','Paid'),
(110,1000,'GCASH','Paid'),
(111,800,'DEBIT CARD','Paid'),
(112,1200,'CASH','Paid'),
(113,2500,'GCASH','Paid'),
(114,1500,'MAYA','Paid'),
(115,1000,'CASH','Paid'),
(116,800,'GCASH','Paid'),
(117,1200,'DEBIT CARD','Paid'),
(118,2500,'MAYA','Paid'),
(119,1500,'CASH','Paid'),
(120,1000,'GCASH','Paid');

CREATE TABLE service_history (
    history_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    unit_id INT NOT NULL,
    service_id INT NOT NULL,
    technician_id INT,

    service_date DATE NOT NULL,
    remarks TEXT,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (unit_id)
        REFERENCES aircon_units(unit_id),

    FOREIGN KEY (service_id)
        REFERENCES services(service_id),

    FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
);

INSERT INTO service_history (
booking_id, customer_id, unit_id, service_id, technician_id,
service_date, remarks
)
VALUES
(103,103,103,103,3,'2026-05-03','Completed cleaning'),
(105,105,105,105,5,'2026-05-05','Repair done'),
(108,108,108,103,8,'2026-05-08','Installed properly'),
(110,110,110,105,10,'2026-05-10','Maintenance done'),
(113,113,113,103,13,'2026-05-13','Successful repair'),
(115,115,115,105,15,'2026-05-15','Unit cleaned'),
(118,118,118,103,18,'2026-05-18','Freon refilled'),
(120,120,120,105,20,'2026-05-20','System checked'),
(101,101,101,101,1,'2026-05-01','Initial service'),
(102,102,102,102,2,'2026-05-02','Ongoing work'),
(104,104,104,104,4,'2026-05-04','Pending completion'),
(106,106,106,101,6,'2026-05-06','Good condition'),
(107,107,107,102,7,'2026-05-07','Inspection done'),
(109,109,109,104,9,'2026-05-09','Needs follow-up'),
(111,111,111,101,11,'2026-05-11','OK'),
(112,112,112,102,12,'2026-05-12','Repair done'),
(114,114,114,104,14,'2026-05-14','Scheduled follow-up'),
(116,116,116,101,16,'2026-05-16','Checked'),
(117,117,117,102,17,'2026-05-17','Minor issue fixed'),
(119,119,119,104,19,'2026-05-19','Inspection done');