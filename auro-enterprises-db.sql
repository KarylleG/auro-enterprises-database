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



CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY 
		(START WITH 101 INCREMENT BY 1),

    booking_code VARCHAR(10) GENERATED ALWAYS AS 
        ('B' || LPAD(booking_id::TEXT, 3, '0')) STORED,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
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
        REFERENCES services(service_id)
);

CREATE TABLE aircon_units (
    unit_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY 
		(START WITH 101 INCREMENT BY 1),
    unit_code VARCHAR(10) GENERATED ALWAYS AS 
        ('AU' || LPAD(unit_id::TEXT, 3, '0')) STORED,
    booking_id INT NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    unit_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

/*Data is fixed*/
CREATE TABLE services (
    service_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY 
		(START WITH 101 INCREMENT BY 1),
    service_code VARCHAR(10) GENERATED ALWAYS AS 
        ('SV' || LPAD(service_id::TEXT, 3, '0')) STORED,
    service_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

/*Data is fixed*/
CREATE TABLE technicians (
    technician_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
		(START WITH 101 INCREMENT BY 1),
    technician_code VARCHAR(10) GENERATED ALWAYS AS 
        ('TECH' || LPAD(technician_id::TEXT, 3, '0')) STORED,
    technician_fname VARCHAR(30) NOT NULL,
    technician_lname VARCHAR(30) NOT NULL,
    contact_number VARCHAR(11),
    specialization VARCHAR(50)
);



CREATE TABLE booking_technicians (
    assignment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
		(START WITH 101 INCREMENT BY 1),
    assignment_code VARCHAR(10) GENERATED ALWAYS AS 
        ('B' || LPAD(assignment_id::TEXT, 3, '0')) STORED,
    booking_id INT NOT NULL,
    technician_id INT NOT NULL,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE,
    FOREIGN KEY (technician_id)
        REFERENCES technicians(technician_id)
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
		(START WITH 101 INCREMENT BY 1),
    payment_code VARCHAR(10) GENERATED ALWAYS AS 
        ('PAY' || LPAD(payment_id::TEXT, 3, '0')) STORED,
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

CREATE TABLE service_history (
    history_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
		(START WITH 101 INCREMENT BY 1),
    history_code VARCHAR(10) GENERATED ALWAYS AS 
        ('H' || LPAD(history_id::TEXT, 3, '0')) STORED,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    technician_id INT,
    service_date DATE NOT NULL,
    remarks TEXT,

    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id),
    FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);

/* Trigger function to archive completed bookings into service_history */
CREATE OR REPLACE FUNCTION archive_completed_booking()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN

    -- Only run when status changes TO Completed
    IF NEW.status = 'Completed' AND OLD.status <> 'Completed' THEN

        INSERT INTO service_history (
            booking_id,
            customer_id,
            service_id,
            technician_id,
            service_date,
            remarks
        )
        SELECT
            NEW.booking_id,
            NEW.customer_id,
            NEW.service_id,
            bt.technician_id,
            CURRENT_DATE,
            'Auto recorded after completion'
        FROM booking_technicians bt
        WHERE bt.booking_id = NEW.booking_id
        LIMIT 1;

    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_booking_completed
AFTER UPDATE OF status ON bookings
FOR EACH ROW
WHEN (NEW.status = 'Completed')
EXECUTE FUNCTION archive_completed_booking();

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

INSERT INTO services (service_name, price)
VALUES
('Aircon Cleaning', 800.00),
('Aircon Repair', 1200.00),
('Aircon Installation', 2500.00),
('Freon Refill', 1500.00),
('General Maintenance', 1000.00);

INSERT INTO technicians (
technician_fname, technician_lname, contact_number, specialization
)
VALUES
('Mark','Dela Cruz','09170000001','Cleaning'),
('John','Reyes','09170000002','Repair'),
('Luis','Torres','09170000003','Installation'),
('Paolo','Santos','09170000004','Electrical'),
('Ramon','Garcia','09170000005','Freon'),
('Jomar','Lopez','09170000006','General'),
('Erwin','Cruz','09170000007','Repair'),
('Neil','Rivera','09170000008','Installation'),
('Bryan','Mendoza','09170000009','Cleaning'),
('Carlo','Navarro','09170000010','Maintenance');

INSERT INTO bookings (
customer_id, service_id,
booking_date,
service_house_number, service_barangay, service_city, service_province,
status
)
VALUES
(101,101,'2026-05-01','12A','Bucandala','Imus','Cavite','Completed'),
(102,102,'2026-05-02','45B','Anabu','Imus','Cavite','Completed'),
(103,103,'2026-05-03','78C','Bayanan','Dasma','Cavite','In Progress'),
(104,104,'2026-05-04','11D','Salawag','Dasma','Cavite','Pending'),
(105,105,'2026-05-05','22E','Habay','Bacoor','Cavite','Completed'),
(106,101,'2026-05-06','33F','Mambog','Bacoor','Cavite','Completed'),
(107,102,'2026-05-07','44G','Talon','Las Pinas','Metro Manila','Pending'),
(108,103,'2026-05-08','55H','Moonwalk','Paranaque','Metro Manila','Completed'),
(109,104,'2026-05-09','66I','BF Homes','Paranaque','Metro Manila','Pending'),
(110,105,'2026-05-10','77J','Don Bosco','Paranaque','Metro Manila','Completed'),
(111,101,'2026-05-11','88K','Zapote','Bacoor','Cavite','Completed'),
(112,102,'2026-05-12','99L','Talaba','Bacoor','Cavite','In Progress'),
(113,103,'2026-05-13','101M','Manggahan','Gen Trias','Cavite','Completed'),
(114,104,'2026-05-14','202N','Pasong Kawayan','Gen Trias','Cavite','Pending'),
(115,105,'2026-05-15','303O','Langkaan','Dasma','Cavite','Completed'),
(116,101,'2026-05-16','404P','San Agustin','Dasma','Cavite','Completed'),
(117,102,'2026-05-17','505Q','Poblacion','Makati','Metro Manila','Pending'),
(118,103,'2026-05-18','606R','Guadalupe','Makati','Metro Manila','Completed'),
(119,104,'2026-05-19','707S','Fort Bonifacio','Taguig','Metro Manila','Pending'),
(120,105,'2026-05-20','808T','Ususan','Taguig','Metro Manila','Completed');

INSERT INTO aircon_units (booking_id, brand, model, unit_type)
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

INSERT INTO booking_technicians (booking_id, technician_id)
VALUES
(101,101),(102,102),(103,103),(104,104),(105,105),
(106,106),(107,107),(108,108),(109,109),(110,110),
(111,101),(112,102),(113,103),(114,104),(115,105),
(116,106),(117,107),(118,108),(119,109),(120,110);

select * from technicians

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

INSERT INTO service_history (
booking_id, customer_id, service_id, technician_id,
service_date, remarks
)
VALUES
(101,101,101,101,'2026-05-01','Completed cleaning'),
(102,102,102,105,'2026-05-02','Repair done'),
(105,105,105,101,'2026-05-05','Installation completed'),
(106,106,101,106,'2026-05-06','Cleaning done'),
(108,108,103,108,'2026-05-08','Installed properly'),
(110,110,105,101,'2026-05-10','Maintenance done'),
(111,111,101,101,'2026-05-11','Service completed'),
(113,113,103,103,'2026-05-13','Repair successful'),
(115,115,105,105,'2026-05-15','Unit cleaned'),
(116,116,101,106,'2026-05-16','Checked and completed'),
(118,118,103,108,'2026-05-18','Freon refilled'),
(120,120,105,110,'2026-05-20','System checked');

