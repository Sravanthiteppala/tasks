DROP TABLE IF EXISTS OrderItems;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE OrderItems (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO Customers VALUES 
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO Products VALUES 
(1, 'Laptop', 1000.00),
(2, 'Phone', 500.00),
(3, 'Tablet', 300.00);

INSERT INTO Orders VALUES 
(101, 1, '2025-05-01', 1500.00),
(102, 2, '2025-05-02', 800.00),
(103, 1, '2025-05-15', 500.00),
(104, 3, '2025-05-20', 300.00);

INSERT INTO OrderItems VALUES
(1, 101, 1, 1),
(2, 101, 2, 1),
(3, 102, 2, 1),
(4, 103, 3, 1),
(5, 104, 3, 1);

-- Monthly Sales and Customer Rankings
WITH MonthlySales AS (
    SELECT 
        o.customer_id,
        c.customer_name,
        DATE_TRUNC('month', o.order_date) AS sale_month,
        SUM(o.total_amount) AS monthly_spending
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name, DATE_TRUNC('month', o.order_date)
),
RankedSales AS (
    SELECT *,
        RANK() OVER (PARTITION BY sale_month ORDER BY monthly_spending DESC) AS customer_rank
    FROM MonthlySales
)
SELECT * FROM RankedSales;

-- Expected Output:
/*
 customer_id | customer_name | sale_month | monthly_spending | customer_rank
-------------+----------------+------------+------------------+---------------
 1           | Alice          | 2025-05-01 | 2000.00          | 1
 2           | Bob            | 2025-05-01 | 800.00           | 2
 3           | Charlie        | 2025-05-01 | 300.00           | 3
*/

-- Most Frequently Purchased Products
SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

-- Expected Output:
/*
 product_name | total_quantity_sold
--------------+----------------------
 Tablet       | 2
 Phone        | 2
 Laptop       | 1
*/

-- First Purchase Date per Customer
SELECT * FROM (
    SELECT 
        o.customer_id,
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date ASC) AS rn
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
) t
WHERE rn = 1;

-- Expected Output:
/*
 customer_id | customer_name | order_id | order_date
-------------+----------------+----------+-------------
 1           | Alice          | 101      | 2025-05-01
 2           | Bob            | 102      | 2025-05-02
 3           | Charlie        | 104      | 2025-05-20
*/

-- Average Order Value by Month
SELECT 
    DATE_TRUNC('month', order_date) AS order_month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS total_sales,
    AVG(total_amount) AS average_order_value
FROM Orders
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;

-- Expected Output:
/*
 order_month | total_orders | total_sales | average_order_value
-------------+--------------+-------------+----------------------
 2025-05-01  | 4            | 3100.00     | 775.00
*/
