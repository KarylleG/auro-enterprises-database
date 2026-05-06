
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

-- SERVICES
CREATE TABLE services (
    service_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY 
        (START WITH 101 INCREMENT BY 1),

    service_code VARCHAR(10) GENERATED ALWAYS AS 
        ('SV' || LPAD(service_id::TEXT, 3, '0')) STORED,

    service_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

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

