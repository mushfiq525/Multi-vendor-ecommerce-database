-- Active: 1766482479283@@127.0.0.1@3306@mysql

-- creating database
SHOW DATABASES;
CREATE DATABASE ecommerce;

USE ecommerce;
show tables;

-- creating tables
CREATE TABLE subscription_plans(
    plan_name VARCHAR(100) UNIQUE PRIMARY KEY,
    price DECIMAL(10,2),
    duration_days INT,
    features TEXT
);

CREATE TABLE vendors(
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    business_name VARCHAR(200),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(250),
    plan_name VARCHAR(100),

    FOREIGN KEY (plan_name) REFERENCES subscription_plans(plan_name)
);

CREATE TABLE categories(
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT
);

CREATE TABLE products(
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id),
    name VARCHAR(150),
    description TEXT,
    price DECIMAL(10,2),
    stock_quantity INT,
    status ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories(
    product_id INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY(product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers(
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20) NOT NULL,
    address VARCHAR(250)
);

CREATE TABLE orders(
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    order_date DATETIME,
    total_amount DECIMAL(10,2),
    order_status ENUM('pending', 'processing', 'completed', 'cancelled', 'refunded')
);

CREATE TABLE order_items(
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    product_id INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    quantity INT,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(10,2)
);

CREATE TABLE payments(
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    payment_method ENUM('card', 'bkash', 'nagad', 'paypal', 'cod'),
    amount DECIMAL(12,2),
    payment_date DATETIME,
    payment_status ENUM('pending', 'paid', 'failed', 'refunded')
);

-- Insert values into subscription_plans table
INSERT INTO subscription_plans(plan_name, price, duration_days, features)
VALUES
    ('Basic', 500.00, 30, 'Basic vendor features'),
    ('Standard', 1200.00, 30, 'Includes analytics, 100 product uploads, priority support'),
    ('Premium', 2500.00, 30, 'Unlimited products, advanced analytics, featured listings'),
    ('Enterprise', 5000.00, 30, 'Custom branding, dedicated support, API access'),
    ('Trial', 0.00, 7, 'Limited trial access to key features');


-- Part C
--5. Insert a new vendor named "SmartTech Ltd.", with contact person Rahim Khan, email rahim@smarttech.com, phone 017XXXXXXXX, address Dhaka, Bangladesh, under the Basic plan. 
INSERT INTO vendors(business_name, contact_person, email, phone, address, plan_name) 
VALUES(
    'SmartTech Ltd', 'Rahim Khan',  'rahim@smarttech.com',
    '01729822900', 'Dhaka, Bangladesh', 'Basic'
);

-- 6. Insert a product called "Laptop" under the Electronics category, price 75,000, stock 10, status active, belonging to SmartTech Ltd.
INSERT INTO categories(name, description)
VALUES ('Electronics', 'Electronic devices and gadgets'); -- inserted Electronic category
SELECT category_id FROM categories
WHERE name = 'Electronics'; -- got the category_id

SELECT vendor_id FROM vendors 
WHERE business_name = 'SmartTech Ltd'; -- got the vendor_id

INSERT into products(name, price, stock_quantity, status, vendor_id) VALUES(
    'Laptop', 75000, 10, 'active', 1 
); -- inserted 'Laptop' into products
SELECT LAST_INSERT_ID() AS product_id;

INSERT INTO product_categories 
VALUES(1, 1); -- updated Electronic category for Laptop




-- 7. Update the stock quantity of "Laptop" product to 15. 
UPDATE products
SET stock_quantity = 15
WHERE name = 'Laptop';

SELECT name, stock_quantity FROM products
WHERE name = 'Laptop';


-- 8. Delete a customer whose email is "oldcustomer@gmail.com".
INSERT INTO customers(name, email, phone, address) -- first we need to insert value into customer table
VALUES(
    'Akash', 'oldcustomer@gmail.com', '01587949468', 'Barisal, Bangladesh'
);

DELETE FROM customers -- delete customer with email = oldcustomer@gmail.com
WHERE email = 'oldcustomer@gmail.com';
select * FROM customers;


-- Part D


-- 9. Write a query to display all vendors along with their subscription plan name and price. 

select * FROM subscription_plans;
INSERT INTO vendors(business_name, contact_person, email, phone, address, plan_name) 
VALUES
    ('BNP Ltd', 'Zarek Tia', 'zarektia@gmail.com', '01646565656', 'Dhaka, Bangladesh', 'Basic'),
    ('Ryans Ltd', 'Adnan Hossain', 'rahin@yahoo.com', '01648984512', 'Khulna, Bangladesh', 'Premium'),
    ('Dhanmondi32 Ltd', 'Sheikh Bongoboltu', 'rahin@gmail.com', '01789654123', 'Dhaka, Bangladesh', 'Standard'),
    ('Narayonganj Ltd', 'Shamim Osman', 'rahin@gmail.com', '01325784965', 'Khulna, Bangladesh', 'Enterprise'),
    ('Tech Diversity', 'Mushfiqur Rahman', 'rahin@gmail.com', '01621893927', 'Rajshahi, Bangladesh', 'Standard');

select * from vendors;

SELECT 
    v.vendor_id,
    v.business_name,
    v.contact_person,
    v.email,
    v.phone,
    v.address,
    s.plan_name,
    s.price
FROM vendors v
JOIN subscription_plans s
    ON v.plan_name = s.plan_name;


-- 10. Find all products under the category "Electronics" with their name, price, and stock quantity. 
SELECT p.name, p.price, p.stock_quantity
FROM products p 
JOIN product_categories pc 
ON p.product_id = pc.product_id
JOIN categories c 
ON pc.category_id = c.category_id
WHERE c.name = 'Electronics';



-- 11. List all orders placed by customer "Karim Uddin", showing order_id, date, total_amount, and status. 

-- first let's insert values into customers table

SELECT * FROM orders;

INSERT INTO customers(customer_id, name, email, phone, address) VALUES
(1, 'Pranto', 'pranto9@gmail.com', '01587546123', 'Barisal, Bangladesh');
INSERT INTO customers(name, email, phone, address) VALUES
('Nabila Tabassum', 'nabila347@gmail.com', '01987546123', 'Barisal, Bangladesh'),
('Dipta Paul', 'dpaulfloyd@gmail.com', '01708009213', 'Mymensingh, Bangladesh'),
('Karim Uddin', 'karim@gmail.com', '01718225916', 'Dhaka, Bangladesh'),
('Alomgir', 'alomgir12@hotmail.com', '01611548780', 'Dhaka, Bangladesh'),
('Ruhul Amin', 'xoss@outlook.com', '01987546124', 'Rangpur, Bangladesh');

SELECT customer_id, name FROM customers;

-- now lets insert values into orders

INSERT INTO orders(customer_id, order_date, total_amount, order_status) VALUES
(1, '2026-01-03 09:00:00', 120000.00, 'completed'),
(2, '2026-01-03 09:30:00', 2000.00, 'completed'),
(3, '2026-01-03 10:00:00', 7000.00, 'completed'),
(4, '2026-01-03 10:15:00', 4000.00, 'completed'),
(5, '2026-01-03 10:30:00', 3000.00, 'completed'),
(1, '2026-01-03 11:00:00', 5000.00, 'completed'),
(2, '2026-01-03 11:30:00', 75000.00, 'completed'),
(3, '2026-01-03 12:00:00', 35000.00, 'completed'),
(4, '2026-01-03 12:30:00', 25000.00, 'completed'),
(5, '2026-01-03 13:00:00', 15000.00, 'completed');

SELECT c.name, o.order_id, o.order_date, o.total_amount, o.order_status 
from customers c 
JOIN orders o
ON c.customer_id = o.customer_id
WHERE c.name = 'Karim Uddin';


-- 12. Show the payment details (method, amount, status) for order_id = 1

-- first insert values into payment

INSERT INTO payments (order_id, payment_method, amount, payment_date, payment_status)
VALUES
    (11, 'card', 75000.00, '2026-01-02 15:00:00', 'paid'),
    (12, 'bkash', 35000.00, '2026-01-02 16:30:00', 'paid'),
    (13, 'paypal', 1500.00, '2026-01-03 10:45:00', 'paid'),
    (20, 'cod', 1500.00, '2026-01-03 11:15:00', 'paid'),
    (19, 'nagad', 500.00, '2026-01-03 12:00:00', 'paid'),
    (1, 'nagad', 120000.00, '2026-01-03 12:00:00', 'paid');

INSERT INTO orders(order_id, customer_id, order_date, total_amount, order_status) VALUES
(1, 2, '2026-01-03 09:00:00', 120000.00, 'completed');

SELECT o.order_id, p.payment_method, p.amount, p.payment_status
FROM orders o JOIN payments p
ON o.order_id = p.order_id
WHERE o.order_id = 1;



-- 13. Find the top 5 best-selling products based on total quantity sold. 

-- insert values into products and order_items

SELECT order_id, total_amount from orders;
SELECT * FROM products;
SELECT * FROM vendors;

INSERT INTO products(name, description, price, stock_quantity, status, vendor_id)
VALUES
('Asus Laptop', 'High-performance laptop', 75000.00, 15, 'active', 1),
('Smartphone', 'Latest Android phone', 35000.00, 20, 'active', 2),
('Tablet', '10-inch tablet', 25000.00, 30, 'active', 2),
('Headphones', 'Wireless headphones', 5000.00, 50, 'active', 3),
('Smartwatch', 'Fitness smartwatch', 8000.00, 40, 'active', 1),
('Gaming Laptop', 'High-end gaming laptop', 120000.00, 10, 'active', 1),
('Wireless Mouse', 'Ergonomic wireless mouse', 2000.00, 100, 'active', 2),
('Mechanical Keyboard', 'RGB mechanical keyboard', 7000.00, 60, 'active', 2),
('Bluetooth Speaker', 'Portable Bluetooth speaker', 4000.00, 80, 'active', 3),
('Webcam', 'HD webcam for video calls', 3000.00, 50, 'active', 3);

INSERT INTO order_items(order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 75000.00, 75000.00),
(1, 2, 4, 35000.00, 140000.00),
(11, 3, 2, 25000.00, 50000.00),
(12, 2, 1, 35000.00, 35000.00),
(11, 5, 1, 8000.00, 8000.00),
(20, 3, 3, 25000.00, 75000.00),
(15, 4, 1, 5000.00, 5000.00),
(16, 6, 1, 120000.00, 120000.00),
(17, 7, 2, 2000.00, 4000.00);

SELECT 
    p.name AS product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;

