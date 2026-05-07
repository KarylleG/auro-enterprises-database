
-- CUSTOMERS
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
('Nico','Nunez','09876543212','Nico123@gmail.com','blk 12 lot 7','Bagong Karsada','Naic','Cavite'),
('Nicole','Pizarro','09123456789','nicole@gmail.com','84','Habay II','Bacoor','Cavite'),
('Nilo','Perez','09123456780','Nilo8321@gmail.com','938','Anabu I-A','Imus','Cavite'),
('Glexier','Tumala','09123456781','Glexier2831@gmail.com','blk 18 lot 4','Bucandala','Imus','Cavite'),
('James','Vea','09123456782','James9087@gmail.com','blk 4 lot 20','Panapaan','Bacoor','Cavite'),
('AJ','Mayormente','09123456783','AJ239@gmail.com','821','Sabang','Kawit','Cavite'),
('Bong','Sigayan','09123456784','Bong183@gmail.com','971','Salawag','Dasmariñas','Cavite'),
('Jasper','Durana','09123456785','Durana28@gmail.com','blk 7 lot 8','659','Ermita','Manila'),
('Vic','Ventura','09123456786','Ventura923@gmail.com','blk 9 lot 3','393','Sampaloc','Manila'),
('Renyl','Dionson','09123456787','renyl.92@gmail.com','blk 5 lot 12','Moonwalk','Parañaque','Metro Manila'),
('Philip','Villegas','09123456788','Philip32@gmail.com','blk 9 lot 2','Don Bosco','Parañaque','Metro Manila'),
('Yshin','Jimenez','09123488789','jimenez23@gmail.com','42','Salinas','Bacoor','Cavite'),
('Harell','Diaz','09123456790','harell82@gmail.com','blk 3 lot 7','Bucandala','Imus','Cavite'),
('Andrei','Magpali','09123456791','drei827@gmail.com','333','Manggahan','General Trias','Cavite'),
('Carlo','Reyes','09123456792','carlo@gmail.com','120','Talaba II','Bacoor','Cavite'),
('Mark','Santos','09123456793','mark@gmail.com','88','San Agustin','Dasmariñas','Cavite'),
('Paolo','Cruz','09123456794','paolo@gmail.com','55','Navarro','General Trias','Cavite'),
('Kevin','Lopez','09123456795','kevin@gmail.com','77','San Antonio','Makati','Metro Manila'),
('Ryan','Garcia','09123456796','ryan@gmail.com','66','Poblacion','Makati','Metro Manila'),
('Leo','Torres','09123456797','leo@gmail.com','101','Fort Bonifacio','Taguig','Metro Manila');

-- SERVICES
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
('General Maintenance', 1000.00),
('Leak Repair', 1300.00),
('Compressor Replacement', 3500.00),
('Thermostat Repair', 900.00),
('Fan Motor Replacement', 1800.00),
('Drain Cleaning', 600.00),
('Electrical Wiring Fix', 1100.00),
('Aircon Inspection', 500.00),
('Deep Cleaning', 900.00),
('Noise Issue Fix', 1000.00),
('Cooling Problem Fix', 1400.00),
('Remote Repair', 400.00),
('PCB Replacement', 3000.00),
('Gas Leak Detection', 700.00),
('Aircon Relocation', 2200.00),
('Preventive Maintenance', 950.00);

-- TECHNICIANS
CREATE TABLE technicians (
    technician_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    technician_code VARCHAR(10) GENERATED ALWAYS AS
        ('TC' || LPAD(technician_id::TEXT, 3, '0')) STORED,

    technician_fname VARCHAR(30) NOT NULL,
    technician_lname VARCHAR(30) NOT NULL,
    contact_number VARCHAR(11) NOT NULL UNIQUE,
    specialization VARCHAR(50),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO technicians (technician_fname, technician_lname, contact_number, specialization)
VALUES
('Mark','Dela Cruz','09910000001','Installation'),
('John','Reyes','09910000002','Repair'),
('Luis','Torres','09910000003','Cleaning'),
('Paulo','Santos','09910000004','Electrical'),
('Ramon','Garcia','09910000005','Freon Systems'),
('Jomar','Lopez','09910000006','General Service'),
('Erwin','Cruz','09910000007','Diagnostics'),
('Neil','Rivera','09910000008','Installation'),
('Bryan','Mendoza','09910000009','Repair'),
('Carlo','Navarro','09910000010','Maintenance'),
('Jason','Pascual','09910000011','Cleaning'),
('Miguel','Flores','09910000012','Cooling Systems'),
('Ian','Morales','09910000013','Electrical'),
('Kevin','Dizon','09910000014','Leak Repair'),
('Alfred','Castro','09910000015','Installation'),
('Ronald','Villar','09910000016','Repair'),
('Edgar','Domingo','09910000017','Inspection'),
('Paolo','Aquino','09910000018','Freon Systems'),
('Jeff','Bautista','09910000019','Maintenance'),
('Henry','Lim','09910000020','General Service');

-- AIRCON UNITS
CREATE TABLE aircon_units (
    unit_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    unit_code VARCHAR(10) GENERATED ALWAYS AS
        ('AU' || LPAD(unit_id::TEXT, 3, '0')) STORED,

    customer_id INT NOT NULL,

    brand VARCHAR(50),
    model VARCHAR(50) NOT NULL,
    unit_type VARCHAR(50) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_aircon_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

INSERT INTO aircon_units (customer_id, brand, model, unit_type)
VALUES
(101,'LG','DualCool 1HP','Window Type'),
(102,'Samsung','WindFree 1.5HP','Split Type'),
(103,'Carrier','Optima 1HP','Window Type'),
(104,'Panasonic','Sky Series 1.5HP','Split Type'),
(105,'Daikin','Inverter 1HP','Split Type'),
(106,'Kolin','KAG 1HP','Window Type'),
(107,'TCL','Elite 1.5HP','Split Type'),
(108,'Sharp','Plasmacluster 1HP','Window Type'),
(109,'Hitachi','RAS 1.5HP','Split Type'),
(110,'Condura','Basic 1HP','Window Type'),
(111,'LG','Smart Inverter 1.5HP','Split Type'),
(112,'Samsung','AR Series 1HP','Window Type'),
(113,'Carrier','Inverter 1.5HP','Split Type'),
(114,'Panasonic','Econavi 1HP','Window Type'),
(115,'Daikin','Premium 2HP','Split Type'),
(116,'Kolin','Inverter 1.5HP','Split Type'),
(117,'TCL','CoolPro 1HP','Window Type'),
(118,'Sharp','Eco Series 1HP','Window Type'),
(119,'Hitachi','Premium Inverter 2HP','Split Type'),
(120,'Condura','Energy Saver 1.5HP','Split Type');

select *

-- BOOKINGS
CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    booking_code VARCHAR(10) GENERATED ALWAYS AS 
        ('B' || LPAD(booking_id::TEXT, 3, '0')) STORED,

    customer_id INT NOT NULL,
    service_id INT NOT NULL,
    technician_id INT,

    booking_date DATE NOT NULL,

    service_house_number VARCHAR(50) NOT NULL,
    service_barangay VARCHAR(50) NOT NULL,
    service_city VARCHAR(50) NOT NULL,
    service_province VARCHAR(50) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (status IN ('Pending', 'In Progress', 'Completed', 'Cancelled')),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_services
        FOREIGN KEY (service_id) REFERENCES services(service_id),

    CONSTRAINT fk_technicians
        FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);

-- PAYMENTS
CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    payment_code VARCHAR(10) GENERATED ALWAYS AS 
        ('P' || LPAD(payment_id::TEXT, 3, '0')) STORED,

    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL,

    payment_method VARCHAR(50) NOT NULL 
        CHECK (payment_method IN ('GCASH', 'DEBIT CARD', 'MAYA', 'CASH')), 
    status VARCHAR(20) DEFAULT 'Unpaid'
        CHECK (status IN ('Unpaid', 'Paid', 'Refunded')),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_bookings
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

-- SERVICE HISTORY
CREATE TABLE service_history (
    history_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY
        (START WITH 101 INCREMENT BY 1),

    history_code VARCHAR(10) GENERATED ALWAYS AS
        ('SH' || LPAD(history_id::TEXT, 3, '0')) STORED,

    customer_id INT NOT NULL,
    booking_id INT,
    service_id INT,
    technician_id INT,

    service_date DATE NOT NULL,
    remarks TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_history_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_history_booking
        FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),

    CONSTRAINT fk_history_service
        FOREIGN KEY (service_id) REFERENCES services(service_id),

    CONSTRAINT fk_history_technician
        FOREIGN KEY (technician_id) REFERENCES technicians(technician_id)
);


-- FUNCTION FOR DOUBLE BOOKING
CREATE OR REPLACE FUNCTION prevent_double_booking()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM bookings
        WHERE technician_id = NEW.technician_id
          AND booking_date = NEW.booking_date
          AND status <> 'Cancelled'
    ) THEN
        RAISE EXCEPTION 'Technician already booked on this date';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- TRIGGER FOR DOUBLE BOOKING
CREATE TRIGGER trg_prevent_double_booking
BEFORE INSERT ON bookings
FOR EACH ROW
EXECUTE FUNCTION prevent_double_booking();

-- PROCEDURE ADD BOOKINGS 
CREATE OR REPLACE PROCEDURE add_booking(
    p_customer_id INT,
    p_service_id INT,
    p_technician_id INT,
    p_booking_date DATE,
    p_house_number VARCHAR,
    p_barangay VARCHAR,
    p_city VARCHAR,
    p_province VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO bookings (
        customer_id,
        service_id,
        technician_id,
        booking_date,
        service_house_number,
        service_barangay,
        service_city,
        service_province
    )
    VALUES (
        p_customer_id,
        p_service_id,
        p_technician_id,
        p_booking_date,
        p_house_number,
        p_barangay,
        p_city,
        p_province
    );
END;
$$;

-- view service history 
CREATE VIEW service_history_report_view AS
SELECT
    sh.history_code,
    c.customer_fname || ' ' || c.customer_lname AS customer_name,
    s.service_name,
    t.technician_fname || ' ' || t.technician_lname AS technician_name,
    sh.service_date,
    sh.remarks,
    sh.created_at
FROM service_history sh
JOIN customers c
    ON sh.customer_id = c.customer_id
LEFT JOIN services s
    ON sh.service_id = s.service_id
LEFT JOIN technicians t
    ON sh.technician_id = t.technician_id;

-- Total Revenue From Paid Payments
CREATE OR REPLACE FUNCTION total_revenue()
RETURNS DECIMAL(10,2) AS $$
DECLARE
    revenue DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(amount),0)
    INTO revenue
    FROM payments
    WHERE status = 'Paid';

    RETURN revenue;
END;
$$ LANGUAGE plpgsql;

SELECT total_revenue();

/*For Dashboard Analytics*/
-- 1. Total Revenue
CREATE OR REPLACE FUNCTION total_revenue()
RETURNS DECIMAL(10,2) AS $$
DECLARE
    revenue DECIMAL(10,2);
BEGIN
    SELECT COALESCE(SUM(amount), 0)
    INTO revenue
    FROM payments
    WHERE status = 'Paid';

    RETURN revenue;
END;
$$ LANGUAGE plpgsql;

-- 2. Total Bookings
CREATE OR REPLACE FUNCTION total_bookings()
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM bookings;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

--Total Customers
CREATE OR REPLACE FUNCTION total_customers()
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM customers;

    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- 4. Completed Services
CREATE OR REPLACE FUNCTION completed_services()
RETURNS INT AS $$
DECLARE
    total INT;
BEGIN
    SELECT COUNT(*)
    INTO total
    FROM bookings
    WHERE status = 'Completed';

    RETURN total;
END;
$$ LANGUAGE plpgsql;

-- How to call them
SELECT total_revenue();
SELECT total_bookings();
SELECT total_customers();
SELECT completed_services();

/*Report Generator Program*/
-- Booking Report
CREATE VIEW booking_report_view AS
	SELECT
	    b.booking_code,
	    c.customer_fname || ' ' || c.customer_lname
	    AS customer_name,
	    s.service_name,
	    t.technician_fname || ' ' || t.technician_lname
	    AS technician_name,
	    b.booking_date,
	    b.status
	FROM bookings b
	JOIN customers c
	ON b.customer_id = c.customer_id
	JOIN services s
	ON b.service_id = s.service_id
	LEFT JOIN technicians t
	ON b.technician_id = t.technician_id;

-- Indexing for Booking Report
CREATE INDEX idx_bookings_booking_date
ON bookings(booking_date);

CREATE INDEX idx_bookings_customer_id
ON bookings(customer_id);

CREATE INDEX idx_bookings_service_id
ON bookings(service_id);

CREATE INDEX idx_bookings_technician_id
ON bookings(technician_id);

-- Payment Sales Report
CREATE OR REPLACE VIEW sales_report_view AS
SELECT
    p.payment_code,
    b.booking_code,
    c.customer_fname || ' ' || c.customer_lname AS customer_name,
    p.amount,
    p.payment_date
FROM payments p
JOIN bookings b ON p.booking_id = b.booking_id
JOIN customers c ON b.customer_id = c.customer_id
WHERE p.status = 'Paid';



