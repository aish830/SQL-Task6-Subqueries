-- Drop existing tables (for safety)
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50)
);

-- Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    product VARCHAR(100),
    amount NUMERIC(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- Customers
INSERT INTO customers (customer_name, city) VALUES
('Radha', 'Pune'),
('Raj', 'Mumbai'),
('Darsh', 'Delhi'),
('Gita', 'Bangalore'),
('Dev', 'Pune');

select *from customers;

-- Orders
INSERT INTO orders (customer_id, product, amount) VALUES
(1, 'Laptop', 55000),
(2, 'Mobile', 20000),
(1, 'Tablet', 30000),
(3, 'Headphones', 5000),
(4, 'Monitor', 15000);

select *from orders;

-- Scalar subquery
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE amount > (SELECT AVG(amount) FROM orders)
);

-- Subquery in SELECT
SELECT customer_name,
       (SELECT SUM(amount) FROM orders o WHERE o.customer_id = c.customer_id) AS total_spent
FROM customers c;


-- Subquery in FROM
SELECT customer_name, total_spent
FROM (
    SELECT c.customer_name, SUM(o.amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_name
) AS customer_totals
WHERE total_spent > 30000;


-- EXISTS Subquery
SELECT customer_name
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);



---NOT EXISTS
SELECT customer_name
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


--IN Subquery
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE product = 'Laptop'
);



-- Nested multiple levels
SELECT customer_name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(amount) > (
        SELECT SUM(amount)
        FROM orders
        WHERE customer_id = (SELECT customer_id FROM customers WHERE customer_name = 'Bob')
    )
);


