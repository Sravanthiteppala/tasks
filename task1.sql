-- Drop tables if they exist (for rerunning the script safely)
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT
);

-- Insert data into Departments
INSERT INTO Departments (department_id, department_name) VALUES
(10, 'HR'),
(20, 'Engineering'),
(40, 'Marketing');
--outputs🗂️ Given Tables
Employees
employee_id	name	department_id
1	Alice	10
2	Bob	20
3	Charlie	NULL
4	David	30

Departments
department_id	department_name
10	HR
20	Engineering
40	Marketing


-- Insert data into Employees
INSERT INTO Employees (employee_id, name, department_id) VALUES
(1, 'Alice', 10),
(2, 'Bob', 20),
(3, 'Charlie', NULL),
(4, 'David', 30);

-- Perform all joins with labels
SELECT 
    'INNER JOIN' AS join_type,
    e.name AS employee_name,
    d.department_name
FROM 
    Employees e
INNER JOIN 
    Departments d 
ON 
    e.department_id = d.department_id

UNION ALL

SELECT 
    'LEFT JOIN',
    e.name,
    d.department_name
FROM 
    Employees e
LEFT JOIN 
    Departments d 
ON 
    e.department_id = d.department_id

UNION ALL

SELECT 
    'RIGHT JOIN',
    e.name,
    d.department_name
FROM 
    Employees e
RIGHT JOIN 
    Departments d 
ON 
    e.department_id = d.department_id

UNION ALL

SELECT 
    'FULL JOIN',
    e.name,
    d.department_name
FROM 
    Employees e
FULL JOIN 
    Departments d 
ON 
    e.department_id = d.department_id;
--outputs🗂️ Given Tables
Employees
employee_id	name	department_id
1	Alice	10
2	Bob	20
3	Charlie	NULL
4	David	30

Departments
department_id	department_name
10	HR
20	Engineering
40	Marketing

✅ Output of the Combined Query
join_type	employee_name	department_name
INNER JOIN	Alice	HR
INNER JOIN	Bob	Engineering
LEFT JOIN	Alice	HR
LEFT JOIN	Bob	Engineering
LEFT JOIN	Charlie	NULL
LEFT JOIN	David	NULL
RIGHT JOIN	Alice	HR
RIGHT JOIN	Bob	Engineering
RIGHT JOIN	NULL	Marketing
FULL JOIN	Alice	HR
FULL JOIN	Bob	Engineering
FULL JOIN	Charlie	NULL
FULL JOIN	David	NULL
FULL JOIN	NULL	Marketing

