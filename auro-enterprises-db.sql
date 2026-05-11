CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1),

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
    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1),

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
    unit_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1),

    booking_id INT NOT NULL,

    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    unit_type VARCHAR(50) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
);

CREATE TABLE services (
    service_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY (START WITH 101 INCREMENT BY 1),

    service_code VARCHAR(10) GENERATED ALWAYS AS 
        ('SV' || LPAD(service_id::TEXT, 3, '0')) STORED,

    service_name VARCHAR(50) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0)
);

CREATE TABLE technicians (
    technician_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    technician_fname VARCHAR(30) NOT NULL,
    technician_lname VARCHAR(30) NOT NULL,
    contact_number VARCHAR(11),
    specialization VARCHAR(50)
);

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

CREATE TABLE service_history (
    history_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

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