-- MYSQL TO POSTGRESQL DATA MIGRATION SCRIPT
-- Source: MySQL | Target: PostgreSQL
-- Includes table creation, data validation, and integrity checks

-- STEP 1: PostgreSQL Table Setup

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10, 2)
);

-- STEP 2: Insert Sample Data (Simulating Imported Data)

INSERT INTO customers VALUES 
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO orders VALUES 
(101, 1, '2025-05-01', 1500.00),
(102, 2, '2025-05-02', 800.00),
(103, 1, '2025-05-15', 500.00),
(104, 3, '2025-05-20', 300.00);

-- STEP 3: Verify Record Counts

SELECT COUNT(*) FROM customers;
-- Output: 3

SELECT COUNT(*) FROM orders;
-- Output: 4

-- STEP 4: Validate Foreign Key Integrity

SELECT o.order_id
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
-- Output: No rows (all foreign keys valid)

-- STEP 5: Validate Sample Data

SELECT * FROM customers;
-- Output:
-- 1 | Alice
-- 2 | Bob
-- 3 | Charlie

SELECT * FROM orders;
-- Output:
-- 101 | 1 | 2025-05-01 | 1500.00
-- 102 | 2 | 2025-05-02 | 800.00
-- 103 | 1 | 2025-05-15 | 500.00
-- 104 | 3 | 2025-05-20 | 300.00

-- STEP 6: Data Summary by Customer

SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;
-- Output:
-- Alice   | 2000.00
-- Bob     | 800.00
-- Charlie | 300.00
