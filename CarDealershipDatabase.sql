
DROP DATABASE IF EXISTS CarDealership;
CREATE DATABASE IF NOT EXISTS CarDealership;
USE CarDealership;



-- ------------------------
-- Table: dealerships
-- ------------------------
CREATE TABLE IF NOT EXISTS dealerships (
    dealership_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20)
) ENGINE=InnoDB;

-- ------------------------
-- Table: vehicles
-- VIN is primary key (not auto-increment). Include SOLD flag.
-- ------------------------
CREATE TABLE IF NOT EXISTS vehicles (
    VIN VARCHAR(17) PRIMARY KEY,            -- typical VIN length max 17
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INT,
    color VARCHAR(30),
    mileage INT,
    price DECIMAL(12,2),
    sold TINYINT(1) NOT NULL DEFAULT 0,    -- 0 = not sold, 1 = sold
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ------------------------
-- Table: inventory
-- track which dealership has which vehicle
-- Many-to-many not needed; vehicle at one dealership at a time
-- ------------------------
CREATE TABLE IF NOT EXISTS inventory (
    dealership_id INT NOT NULL,
    VIN VARCHAR(17) NOT NULL,
    received_date DATE,
    CONSTRAINT pk_inventory PRIMARY KEY (dealership_id, VIN),
    CONSTRAINT fk_inventory_dealer FOREIGN KEY (dealership_id)
        REFERENCES dealerships(dealership_id) ON DELETE CASCADE,
    CONSTRAINT fk_inventory_vehicle FOREIGN KEY (VIN)
        REFERENCES vehicles(VIN) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ------------------------
-- Table: sales_contracts
-- Each sale references a VIN and the dealership that sold it
-- ------------------------
CREATE TABLE IF NOT EXISTS sales_contracts (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    VIN VARCHAR(17) NOT NULL,
    dealership_id INT NOT NULL,
    sale_date DATE NOT NULL,
    sale_price DECIMAL(12,2) NOT NULL,
    buyer_name VARCHAR(150),
    buyer_contact VARCHAR(100),
    notes TEXT,
    CONSTRAINT fk_sales_vehicle FOREIGN KEY (VIN) REFERENCES vehicles(VIN),
    CONSTRAINT fk_sales_dealer FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id)
) ENGINE=InnoDB;

-- ------------------------
-- Table: lease_contracts 
-- ------------------------
CREATE TABLE IF NOT EXISTS lease_contracts (
    lease_id INT AUTO_INCREMENT PRIMARY KEY,
    VIN VARCHAR(17) NOT NULL,
    dealership_id INT NOT NULL,
    lease_start DATE NOT NULL,
    lease_end DATE,
    monthly_payment DECIMAL(10,2),
    lessee_name VARCHAR(150),
    notes TEXT,
    CONSTRAINT fk_lease_vehicle FOREIGN KEY (VIN) REFERENCES vehicles(VIN),
    CONSTRAINT fk_lease_dealer FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id)
) ENGINE=InnoDB;

-- ------------------------
-- Sample data insertion
-- Insert only if tables are empty to avoid duplicates on reruns.
-- ------------------------

-- Dealerships
INSERT INTO dealerships (name, address, phone)
SELECT * FROM (SELECT 'City Auto Mall' AS name, '123 Main St, Anytown, USA' AS address, '555-0100' AS phone) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM dealerships WHERE name='City Auto Mall');

INSERT INTO dealerships (name, address, phone)
SELECT * FROM (SELECT 'Highway Motors' , '789 Highway Rd, Townsville, USA', '555-0200') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM dealerships WHERE name='Highway Motors');

INSERT INTO dealerships (name, address, phone)
SELECT * FROM (SELECT 'Suburb Cars', '456 Suburb Ln, Suburbia, USA', '555-0300') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM dealerships WHERE name='Suburb Cars');

-- Vehicles 
INSERT INTO vehicles (VIN, make, model, year, color, mileage, price, sold)
SELECT * FROM (SELECT '1HGBH41JXMN109186' AS VIN,'Ford' AS make,'Mustang' AS model,2019 AS year,'Red' AS color,25000 AS mileage,26000.00 AS price,0 AS sold) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE VIN='1HGBH41JXMN109186');

INSERT INTO vehicles (VIN, make, model, year, color, mileage, price, sold)
SELECT * FROM (SELECT '1HGCM82633A004352','Toyota','Camry',2018,'Blue',42000,18500.00,1) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE VIN='1HGCM82633A004352');

INSERT INTO vehicles (VIN, make, model, year, color, mileage, price, sold)
SELECT * FROM (SELECT '2T1BURHE5JC074596','Honda','Civic',2021,'Black',12000,19500.00,0) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE VIN='2T1BURHE5JC074596');

INSERT INTO vehicles (VIN, make, model, year, color, mileage, price, sold)
SELECT * FROM (SELECT 'JH4TB2H26CC000000','Ford','F-150',2022,'White',8000,33000.00,0) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE VIN='JH4TB2H26CC000000');

INSERT INTO vehicles (VIN, make, model, year, color, mileage, price, sold)
SELECT * FROM (SELECT '3CZRE4H59BG704395','Chevrolet','Malibu',2017,'Red',54000,12500.00,0) AS tmp
WHERE NOT EXISTS (SELECT 1 FROM vehicles WHERE VIN='3CZRE4H59BG704395');

-- Inventory (map vehicles to dealerships)
-- Find dealership ids
SET @city_id = (SELECT dealership_id FROM dealerships WHERE name='City Auto Mall' LIMIT 1);
SET @highway_id = (SELECT dealership_id FROM dealerships WHERE name='Highway Motors' LIMIT 1);
SET @suburb_id = (SELECT dealership_id FROM dealerships WHERE name='Suburb Cars' LIMIT 1);

INSERT IGNORE INTO inventory (dealership_id, VIN, received_date) VALUES
(@city_id,'1HGBH41JXMN109186','2023-09-01'),
(@highway_id,'1HGCM82633A004352','2023-08-15'),
(@suburb_id,'2T1BURHE5JC074596','2024-03-20'),
(@city_id,'JH4TB2H26CC000000','2024-01-05'),
(@highway_id,'3CZRE4H59BG704395','2022-11-11');

-- Sales contracts: sample sale for the sold vehicle (VIN 1HGCM82633A004352)
-- Only create sale if it doesn't exist
INSERT INTO sales_contracts (VIN, dealership_id, sale_date, sale_price, buyer_name, buyer_contact, notes)
SELECT VIN, dealership_id, '2024-06-30', 17000.00, 'Alice Johnson', 'alice.j@example.com', 'Trade-in accepted'
FROM (SELECT '1HGCM82633A004352' AS VIN, @highway_id AS dealership_id) AS x
WHERE NOT EXISTS (SELECT 1 FROM sales_contracts WHERE VIN='1HGCM82633A004352');

-- Sample lease
INSERT INTO lease_contracts (VIN, dealership_id, lease_start, lease_end, monthly_payment, lessee_name)
SELECT * FROM (SELECT '3CZRE4H59BG704395', @highway_id, '2024-07-01', '2025-06-30', 250.00, 'Bob Lease') AS tmp
WHERE NOT EXISTS (SELECT 1 FROM lease_contracts WHERE VIN='3CZRE4H59BG704395');

-- Update vehicle sold flag explicitly when sale exists
UPDATE vehicles v
JOIN sales_contracts s ON v.VIN = s.VIN
SET v.sold = 1;

-- Final check: ensure all FKs OK