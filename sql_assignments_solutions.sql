/* --------------------------------------------------
   Section: SQL Basics - Assignment Questions
   -------------------------------------------------- */

-- Q1: Create a table called employees with the following structure
-- emp_id (integer, should not be NULL and should be a primary key)
-- emp_name (text, should not be NULL)
-- age (integer, should have a check constraint to ensure the age is at least 18)
-- email (text, should be unique for each employee)
-- salary (decimal, with a default value of 30,000).

CREATE TABLE employees (
    emp_id INTEGER NOT NULL PRIMARY KEY,
    emp_name TEXT NOT NULL,
    age INTEGER CHECK (age >= 18),
    email TEXT UNIQUE,
    salary DECIMAL(12,2) DEFAULT 30000.00
);

-- Q2: Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.
-- Answer 
-- =====================================================
-- Purpose of Constraints in a Database
-- =====================================================

-- Constraints are rules applied to database columns or tables to ensure
-- the accuracy, validity, and consistency of the data.
-- They enforce data integrity by preventing incorrect, incomplete,
-- or conflicting data from being entered or stored in the database.

-- Constraints help maintain data integrity in the following ways:
-- 1. Prevent invalid data entry
-- 2. Maintain consistency between related tables
-- 3. Enforce uniqueness of data
-- 4. Define mandatory fields
-- 5. Control relationships between tables

-- =====================================================
-- Common Types of Constraints with Examples
-- =====================================================

-- Create a sample table: users
CREATE TABLE users (
    user_id INT PRIMARY KEY,                     -- PRIMARY KEY: Uniquely identifies each user (NOT NULL + UNIQUE)
    username VARCHAR(50) NOT NULL,               -- NOT NULL: Username must not be NULL
    email VARCHAR(100) UNIQUE,                   -- UNIQUE: Email must be unique
    age INT CHECK (age >= 18),                   -- CHECK: Age must be >= 18
    status VARCHAR(20) DEFAULT 'active'          -- DEFAULT: If not specified, defaults to 'active'
);

-- Create a related table: orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES users(user_id) -- FOREIGN KEY: Links orders to users
);

-- =====================================================
-- Examples to Demonstrate Each Constraint
-- =====================================================

-- 1. Insert valid data into users table
INSERT INTO users (user_id, username, email, age)
VALUES (1, 'alice', 'alice@example.com', 25);

-- 2. NOT NULL Constraint Example (This will fail: username is missing)
-- INSERT INTO users (user_id, email, age)
-- VALUES (2, 'bob@example.com', 30);

-- 3. UNIQUE Constraint Example (This will fail: email already used)
-- INSERT INTO users (user_id, username, email, age)
-- VALUES (3, 'bob', 'alice@example.com', 28);

-- 4. CHECK Constraint Example (This will fail: age is less than 18)
-- INSERT INTO users (user_id, username, email, age)
-- VALUES (4, 'charlie', 'charlie@example.com', 16);

-- 5. DEFAULT Constraint Example (status will be 'active' if not specified)
INSERT INTO users (user_id, username, email, age)
VALUES (5, 'david', 'david@example.com', 22);

-- 6. FOREIGN KEY Constraint Example (Valid: customer_id exists in users)
INSERT INTO orders (order_id, customer_id, order_date)
VALUES (1001, 1, '2025-09-24');

-- 7. FOREIGN KEY Constraint Violation Example (This will fail: no such customer_id)
-- INSERT INTO orders (order_id, customer_id, order_date)
-- VALUES (1002, 999, '2025-09-24');

-- =====================================================
-- View inserted data
-- =====================================================
SELECT * FROM users;
SELECT * FROM orders;

-- END OF ANSWER

-- Q3: Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer.
-- Answer 
-- =====================================================
-- Why Apply the NOT NULL Constraint to a Column?
-- =====================================================

-- The NOT NULL constraint is used to ensure that a column cannot have NULL (i.e., empty or unknown) values.
-- This is useful when the column must always have a value for every row.
-- Example: A 'username' column in a 'users' table should never be empty.

-- =====================================================
-- Can a Primary Key Contain NULL Values?
-- =====================================================

-- No, a PRIMARY KEY cannot contain NULL values.
-- A PRIMARY KEY must uniquely identify each record in a table.
-- Since NULL represents an unknown value, it cannot guarantee uniqueness.
-- Therefore, every column defined as part of the PRIMARY KEY must be NOT NULL automatically.

-- =====================================================
-- Example: Demonstrating NOT NULL and PRIMARY KEY Constraints
-- =====================================================

-- Create a users table with NOT NULL and PRIMARY KEY constraints
CREATE TABLE users (
    user_id INT PRIMARY KEY,            -- PRIMARY KEY: Implicitly NOT NULL
    username VARCHAR(50) NOT NULL,      -- NOT NULL: Must always have a value
    email VARCHAR(100)                  -- Nullable (can be NULL)
);

-- =====================================================
-- Example Inserts
-- =====================================================

-- Valid insert: All required fields are provided
INSERT INTO users (user_id, username, email)
VALUES (1, 'alice', 'alice@example.com');

-- Violates NOT NULL constraint: username is missing
-- This will fail
-- INSERT INTO users (user_id, email)
-- VALUES (2, 'bob@example.com');

-- Violates PRIMARY KEY constraint: user_id is NULL
-- This will fail
-- INSERT INTO users (user_id, username, email)
-- VALUES (NULL, 'charlie', 'charlie@example.com');

-- Violates PRIMARY KEY constraint: duplicate user_id
-- This will fail if user_id 1 already exists
-- INSERT INTO users (user_id, username, email)
-- VALUES (1, 'david', 'david@example.com');

-- =====================================================
-- View inserted data
-- =====================================================
SELECT * FROM users;

-- END OF ANSWER


-- Q4: Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.
-- Add constraint:
-- =====================================================
-- Steps and SQL Commands to Add Constraints
-- =====================================================

-- To add a constraint on an existing table, you use the ALTER TABLE statement
-- with ADD CONSTRAINT syntax.

-- General syntax to add a constraint:
-- ALTER TABLE table_name
-- ADD CONSTRAINT constraint_name constraint_type (column_name);

-- Example: Add a NOT NULL constraint on a column
-- (Note: Some databases do not support adding NOT NULL via ADD CONSTRAINT,
-- you may need to alter the column itself, e.g., ALTER COLUMN ... SET NOT NULL)

-- Example: Add a UNIQUE constraint
-- ALTER TABLE users
-- ADD CONSTRAINT unique_email UNIQUE (email);

-- Example: Add a CHECK constraint
-- ALTER TABLE users
-- ADD CONSTRAINT check_age CHECK (age >= 18);

-- =====================================================
-- Steps and SQL Commands to Remove Constraints
-- =====================================================

-- To remove a constraint, you use ALTER TABLE with DROP CONSTRAINT.

-- General syntax to drop a constraint:
-- ALTER TABLE table_name
-- DROP CONSTRAINT constraint_name;

-- Note: Constraint names are usually specified when you create the constraint.
-- If the constraint was created without a name, the database auto-generates one,
-- which you need to look up before dropping.

-- Example: Drop the UNIQUE constraint named unique_email
-- ALTER TABLE users
-- DROP CONSTRAINT unique_email;

-- =====================================================
-- Full Example: Adding and Removing Constraints
-- =====================================================

-- Step 1: Create a sample table without constraints
CREATE TABLE employees (
    emp_id INT,
    emp_name VARCHAR(50),
    email VARCHAR(100),
    age INT
);

-- Step 2: Add a PRIMARY KEY constraint to emp_id
ALTER TABLE employees
ADD CONSTRAINT pk_emp_id PRIMARY KEY (emp_id);

-- Step 3: Add a UNIQUE constraint to email
ALTER TABLE employees
ADD CONSTRAINT unique_email UNIQUE (email);

-- Step 4: Add a CHECK constraint to age (age must be >= 18)
ALTER TABLE employees
ADD CONSTRAINT check_age CHECK (age >= 18);

-- Step 5: Remove the UNIQUE constraint on email
ALTER TABLE employees
DROP CONSTRAINT unique_email;

-- Step 6: Remove the CHECK constraint on age
ALTER TABLE employees
DROP CONSTRAINT check_age;

-- END OF ANSWER

-- Q5: Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message.
-- Answer 
-- =====================================================
-- Consequences of Violating Constraints
-- =====================================================

-- When you try to INSERT, UPDATE, or DELETE data that violates defined constraints,
-- the database will reject the operation and throw an error.
-- This prevents invalid or inconsistent data from being stored.

-- Common consequences include:
-- 1. INSERT fails if required NOT NULL columns are missing.
-- 2. INSERT or UPDATE fails if UNIQUE or PRIMARY KEY constraint is violated (duplicate values).
-- 3. INSERT or UPDATE fails if CHECK constraints are violated.
-- 4. DELETE fails if FOREIGN KEY constraints prevent deleting referenced rows.

-- These errors help maintain data integrity by enforcing business rules.

-- =====================================================
-- Example Table for Demonstration
-- =====================================================

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) CHECK (price > 0),
    category_id INT
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

ALTER TABLE products
ADD CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES categories(category_id);

-- =====================================================
-- Example Violations and Error Messages
-- =====================================================

-- 1. Violating NOT NULL constraint (missing product_name)
-- INSERT INTO products (product_id, price, category_id)
-- VALUES (1, 10.50, 1);

-- Possible error message:
-- ERROR:  null value in column "product_name" violates not-null constraint

-- 2. Violating CHECK constraint (price <= 0)
-- INSERT INTO products (product_id, product_name, price, category_id)
-- VALUES (2, 'Gadget', -5.00, 1);

-- Possible error message:
-- ERROR:  new row for relation "products" violates check constraint "products_price_check"

-- 3. Violating UNIQUE or PRIMARY KEY constraint (duplicate product_id)
-- INSERT INTO products (product_id, product_name, price, category_id)
-- VALUES (1, 'Widget', 15.00, 1);

-- Possible error message:
-- ERROR:  duplicate key value violates unique constraint "products_pkey"

-- 4. Violating FOREIGN KEY constraint (category_id does not exist)
-- INSERT INTO products (product_id, product_name, price, category_id)
-- VALUES (3, 'Thingamajig', 20.00, 999);

-- Possible error message:
-- ERROR:  insert or update on table "products" violates foreign key constraint "fk_category"
-- DETAIL:  Key (category_id)=(999) is not present in table "categories".

-- 5. Violating FOREIGN KEY constraint when trying to DELETE referenced row
-- DELETE FROM categories WHERE category_id = 1;

-- Possible error message:
-- ERROR:  update or delete on table "categories" violates foreign key constraint "fk_category" on table "products"
-- DETAIL:  Key (category_id)=(1) is still referenced from table "products".

-- END OF ANSWER

-- Q6: You created a products table without constraints. Now, you realise that?
-- The product_id should be a primary keyQ
-- The price should have a default value of 50.00

CREATE TABLE products (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10,2)
);

-- Answer

ALTER TABLE products ADD CONSTRAINT pk_products PRIMARY KEY (product_id);
ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;

-- Q7: You have two tables: Write a query to fetch the student_name and class_name for each student using an INNER JOIN.
SELECT s.student_name, c.class_name
FROM students s
INNER JOIN classes c ON s.class_id = c.class_id;

-- Q8: Consider three tables: Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order.
-- Hint: (use INNER JOIN and LEFT JOIN)
SELECT o.order_id, cu.customer_name, p.product_name
FROM products p
LEFT JOIN orders o ON p.product_id = o.product_id
LEFT JOIN customers cu ON o.customer_id = cu.customer_id;

-- Q9: Given tables, write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.
SELECT p.product_id, p.product_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

-- Q10: You are given three tables: Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.
-- Note - The above-mentioned questions don't require any dataset.
SELECT o.order_id, c.customer_name, oi.quantity
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id;

/* --------------------------------------------------
   Section: SQL Commands (Maven Movies)
   -------------------------------------------------- */

-- Q1: Identify the primary keys and foreign keys in maven movies db. Discuss the differences.
-- =====================================================
-- Primary Keys in Maven Movies DB:
-- Each table has a primary key that uniquely identifies a record.
-- Examples:
--   - actor.actor_id (PK)
--   - film.film_id (PK)
--   - customer.customer_id (PK)
--   - rental.rental_id (PK)
--   - payment.payment_id (PK)
--   - store.store_id (PK)
--   - staff.staff_id (PK)
--   - category.category_id (PK)
--   - inventory.inventory_id (PK)
--   - city.city_id (PK)
--   - country.country_id (PK)
--   - address.address_id (PK)
--
-- Foreign Keys in Maven Movies DB:
-- Foreign keys enforce referential integrity by linking child tables to parent tables.
-- Examples:
--   - film.language_id → language.language_id (FK)
--   - film.original_language_id → language.language_id (FK)
--   - film_actor.film_id → film.film_id (FK)
--   - film_actor.actor_id → actor.actor_id (FK)
--   - film_category.film_id → film.film_id (FK)
--   - film_category.category_id → category.category_id (FK)
--   - inventory.film_id → film.film_id (FK)
--   - inventory.store_id → store.store_id (FK)
--   - rental.inventory_id → inventory.inventory_id (FK)
--   - rental.customer_id → customer.customer_id (FK)
--   - rental.staff_id → staff.staff_id (FK)
--   - payment.rental_id → rental.rental_id (FK)
--   - payment.customer_id → customer.customer_id (FK)
--   - payment.staff_id → staff.staff_id (FK)
--   - customer.store_id → store.store_id (FK)
--   - customer.address_id → address.address_id (FK)
--   - address.city_id → city.city_id (FK)
--   - city.country_id → country.country_id (FK)
--   - staff.store_id → store.store_id (FK)
--   - staff.address_id → address.address_id (FK)
--   - store.address_id → address.address_id (FK)
--
-- Difference between Primary Key and Foreign Key:
-- - PRIMARY KEY uniquely identifies each record in a table. It cannot contain NULL values and must be unique.
-- - FOREIGN KEY is a field in one table that refers to the PRIMARY KEY in another table, ensuring referential integrity.
--   It allows duplicate values and NULLs (depending on definition).
--   It enforces relationships between tables.
-- =====================================================

-- Q2: List all details of actors.
SELECT * FROM actor;

-- Q3: List all customer information from DB.
SELECT * FROM customer;

-- Q4: List different countries.
SELECT DISTINCT country FROM country;

-- Q5: Display all active customers.
SELECT * FROM customer WHERE active = 1;

-- Q6: List of all rental IDs for customer with ID 1.
SELECT rental_id FROM rental WHERE customer_id = 1;

-- Q7: Display all the films whose rental duration is greater than 5.
SELECT * FROM film WHERE rental_duration > 5;

-- Q8: List the total number of films whose replacement cost is greater than $15 and less than $20.
SELECT COUNT(*) FROM film WHERE replacement_cost > 15 AND replacement_cost < 20;

-- Q9: Display the count of unique first names of actors.
SELECT COUNT(DISTINCT first_name) FROM actor;

-- Q10: Display the first 10 records from the customer table.
SELECT * FROM customer ORDER BY customer_id LIMIT 10;

-- Q11: Display the first 3 records from the customer table whose first name starts with ‘b’.
SELECT * FROM customer WHERE LOWER(first_name) LIKE 'b%' LIMIT 3;

-- Q12: Display the names of the first 5 movies which are rated as ‘G’.
SELECT title FROM film WHERE rating='G' LIMIT 5;

-- Q13: Find all customers whose first name starts with "a".
SELECT * FROM customer WHERE LOWER(first_name) LIKE 'a%';

-- Q14: Find all customers whose first name ends with "a".
SELECT * FROM customer WHERE LOWER(first_name) LIKE '%a';

-- Q15: Display the list of first 4 cities which start and end with ‘a’.
SELECT city FROM city WHERE LOWER(city) LIKE 'a%a' LIMIT 4;

-- Q16: Find all customers whose first name have "NI" in any position.
SELECT * FROM customer WHERE UPPER(first_name) LIKE '%NI%';

-- Q17: Find all customers whose first name have "r" in the second position.
SELECT * FROM customer WHERE LOWER(first_name) LIKE '_r%';

-- Q18: Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT * FROM customer WHERE LOWER(first_name) LIKE 'a%' AND LENGTH(first_name) >= 5;

-- Q19: Find all customers whose first name starts with "a" and ends with "o".
SELECT * FROM customer WHERE LOWER(first_name) LIKE 'a%o';

-- Q20: Get the films with pg and pg-13 rating using IN operator.
SELECT * FROM film WHERE rating IN ('PG','PG-13');

-- Q21: Get the films with length between 50 to 100 using between operator.
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- Q22: Get the top 50 actors using limit operator.
SELECT * FROM actor ORDER BY actor_id LIMIT 50;

-- Q23: Get the distinct film ids from inventory table.
SELECT DISTINCT film_id FROM inventory;

/* --------------------------------------------------
   Section: Functions and Aggregates
   -------------------------------------------------- */

-- Q1: Retrieve the total number of rentals made in the Sakila database.
SELECT COUNT(*) AS total_rentals FROM rental;

-- Q2: Find the average rental duration (in days) of movies rented from the Sakila database.
SELECT AVG(rental_duration) AS avg_rental_duration FROM film;

-- Q3: Display the first name and last name of customers in uppercase.
SELECT UPPER(first_name), UPPER(last_name) FROM customer;

-- Q4: Extract the month from the rental date and display it alongside the rental ID.
SELECT rental_id, EXTRACT(MONTH FROM rental_date) AS rental_month FROM rental;

-- Q5: Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;

-- Q6: Find the total revenue generated by each store.
SELECT store_id, SUM(amount) FROM payment GROUP BY store_id;

-- Q7: Determine the total number of rentals for each category of movies.
SELECT c.name, COUNT(r.rental_id)
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;

-- Q8: Find the average rental rate of movies in each language.
SELECT l.name, AVG(f.rental_rate)
FROM film f JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

/* --------------------------------------------------
   Section: Joins
   -------------------------------------------------- */

-- Q9: Display the title of the movie, customer’s first name, and last name who rented it.
SELECT f.title, c.first_name, c.last_name
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id;

-- Q10: Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- Q11: Retrieve the customer names along with the total amount they've spent on rentals.
SELECT c.first_name, c.last_name, SUM(p.amount)
FROM customer c JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.first_name, c.last_name;

-- Q12: List the titles of movies rented by each customer in a particular city (e.g., 'London').
SELECT c.first_name, c.last_name, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city='London'
GROUP BY c.first_name, c.last_name, f.title;

/* --------------------------------------------------
   Section: Advanced Joins and Group By
   -------------------------------------------------- */

-- Q13: Display the top 5 rented movies along with the number of times they've been rented.
SELECT f.title, COUNT(r.rental_id) AS times_rented
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title ORDER BY times_rented DESC LIMIT 5;

-- Q14: Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
SELECT c.customer_id, c.first_name, c.last_name
FROM (
    SELECT r.customer_id, COUNT(DISTINCT i.store_id) AS stores
    FROM rental r JOIN inventory i ON r.inventory_id=i.inventory_id
    GROUP BY r.customer_id
) t JOIN customer c ON t.customer_id=c.customer_id
WHERE stores>=2;

/* --------------------------------------------------
   Section: Window Functions
   -------------------------------------------------- */

-- Q1: Rank the customers based on the total amount they've spent on rentals.
WITH spend AS (
    SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total
    FROM customer c LEFT JOIN payment p ON c.customer_id=p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT *, RANK() OVER (ORDER BY total DESC) FROM spend;

-- Q2: Calculate the cumulative revenue generated by each film over time.
SELECT f.title, p.payment_date, SUM(p.amount)
       OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative
FROM film f
JOIN inventory i ON f.film_id=i.film_id
JOIN rental r ON i.inventory_id=r.inventory_id
JOIN payment p ON r.rental_id=p.rental_id;

-- Q3: Determine the average rental duration for each film, considering films with similar lengths.
SELECT film_id, title, AVG(rental_duration) OVER(PARTITION BY film_id) FROM film;

-- Q4: Identify the top 3 films in each category based on their rental counts.
WITH ranked AS (
    SELECT c.name, f.title, COUNT(r.rental_id) AS rentals,
           RANK() OVER(PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS rk
    FROM category c
    JOIN film_category fc ON c.category_id=fc.category_id
    JOIN film f ON fc.film_id=f.film_id
    JOIN inventory i ON f.film_id=i.film_id
    JOIN rental r ON i.inventory_id=r.inventory_id
    GROUP BY c.name, c.category_id, f.title
)
SELECT name, title, rentals FROM ranked WHERE rk<=3;

-- Q5: Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.

WITH customer_counts AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
), avg_counts AS (
    SELECT AVG(total_rentals) AS avg_rentals FROM customer_counts
)
SELECT cc.customer_id, cc.total_rentals, (cc.total_rentals - ac.avg_rentals) AS diff_from_avg
FROM customer_counts cc CROSS JOIN avg_counts ac
ORDER BY cc.customer_id;

-- Q6: Find the monthly revenue trend for the entire rental store over time.
SELECT DATE_TRUNC('month',payment_date), SUM(amount)
FROM payment GROUP BY 1 ORDER BY 1;

-- Q7: Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH cust AS (
    SELECT customer_id, SUM(amount) AS total FROM payment GROUP BY customer_id
), cutoff AS (
    SELECT PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY total) AS cut FROM cust
)
SELECT c.customer_id, c.total FROM cust c, cutoff k WHERE c.total>=k.cut;

-- Q8: Calculate the running total of rentals per category, ordered by rental count.
WITH cat_rentals AS (
    SELECT c.name, COUNT(r.rental_id) AS rentals
    FROM category c
    JOIN film_category fc ON c.category_id=fc.category_id
    JOIN film f ON fc.film_id=f.film_id
    JOIN inventory i ON f.film_id=i.film_id
    JOIN rental r ON i.inventory_id=r.inventory_id
    GROUP BY c.name
)
SELECT name, rentals, SUM(rentals) OVER(ORDER BY rentals DESC) AS running_total
FROM cat_rentals;

-- Q9: Find the films that have been rented less than the average rental count for their respective categories.
WITH film_cnt AS (
    SELECT c.category_id,f.film_id,f.title,COUNT(r.rental_id) AS rentals
    FROM category c JOIN film_category fc ON c.category_id=fc.category_id
    JOIN film f ON fc.film_id=f.film_id
    LEFT JOIN inventory i ON f.film_id=i.film_id
    LEFT JOIN rental r ON i.inventory_id=r.inventory_id
    GROUP BY c.category_id,f.film_id,f.title
), avg_cnt AS (
    SELECT category_id,AVG(rentals) AS avg_rentals FROM film_cnt GROUP BY category_id
)
SELECT f.film_id,f.title,f.rentals FROM film_cnt f JOIN avg_cnt a
ON f.category_id=a.category_id WHERE f.rentals<a.avg_rentals;

-- Q10: Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT DATE_TRUNC('month',payment_date), SUM(amount) AS revenue
FROM payment GROUP BY 1 ORDER BY revenue DESC LIMIT 5;

/* --------------------------------------------------
   Section: Normalization & CTE
   -------------------------------------------------- */

-- Q1: Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.
-- ==========================================================================================================
-- In the Sakila (Maven Movies) database, the `film` table has a column called `special_features`
-- which stores multiple values (e.g., 'Trailers,Commentaries,Deleted Scenes,Behind the Scenes')
-- as a comma-separated list. This violates First Normal Form (1NF) because the column contains
-- a repeating group / multi-valued attribute instead of atomic values.
--
-- To normalize this to 1NF, we should create a separate table to store each special feature
-- as a distinct row. For example:
--
-- Step 1: Create a new table to store film features individually.
CREATE TABLE film_special_features (
    film_id INT NOT NULL,
    feature VARCHAR(50) NOT NULL,
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Step 2: Instead of storing a comma-separated list in film.special_features,
-- insert one row per feature in the new table.
-- Example:
-- film_id | feature
--    1    | 'Trailers'
--    1    | 'Commentaries'
--    1    | 'Deleted Scenes'
--
-- Step 3: Drop or ignore the old multi-valued column `special_features` in the film table.
--
-- This ensures atomic values and compliance with 1NF.
-- =====================================================

-- -- Sakila Database Normalization and CTE Examples with Full Questions including Date Calculations, Self-Join, and Recursive CTE

-- Q2: Second Normal Form (2NF) Normalization in Sakila Database
-- a. Choose a table in Sakila and describe how you would determine whether it is in 2NF.
-- b. If it violates 2NF, explain the steps to normalize it.

/*
Answer:
Step 1: Choose a table: film_actor
Columns: actor_id, film_id, last_update
Primary Key: (actor_id, film_id)

Step 2: Check 1NF: Atomic values and unique rows -> 1NF satisfied
Step 3: Check 2NF: last_update depends on full composite key -> 2NF satisfied
Step 4: Hypothetical violation example: film_actor_details
Step 5: Normalize by creating separate tables: actor, film, film_actor
*/

CREATE TABLE film_actor (
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    last_update TIMESTAMP NOT NULL,
    PRIMARY KEY (actor_id, film_id)
);

CREATE TABLE film_actor_details (
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    actor_name VARCHAR(45),
    film_title VARCHAR(255),
    last_update TIMESTAMP,
    PRIMARY KEY (actor_id, film_id)
);

CREATE TABLE actor (
    actor_id SMALLINT PRIMARY KEY,
    actor_name VARCHAR(45),
    last_update TIMESTAMP
);

CREATE TABLE film (
    film_id SMALLINT PRIMARY KEY,
    film_title VARCHAR(255),
    last_update TIMESTAMP
);

CREATE TABLE film_actor (
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    last_update TIMESTAMP,
    PRIMARY KEY (actor_id, film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id),
    FOREIGN KEY (film_id) REFERENCES film(film_id)
);

-- Q3: Third Normal Form (3NF)
-- Identify a table in Sakila that violates 3NF. Describe the transitive dependencies and outline the steps to normalize it to 3NF.

CREATE TABLE customer_details (
    customer_id SMALLINT PRIMARY KEY,
    store_id SMALLINT,
    store_address VARCHAR(255), -- depends on store_id (transitive dependency)
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50)
);

CREATE TABLE store (
    store_id SMALLINT PRIMARY KEY,
    store_address VARCHAR(255)
);

CREATE TABLE customer (
    customer_id SMALLINT PRIMARY KEY,
    store_id SMALLINT,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(50),
    FOREIGN KEY (store_id) REFERENCES store(store_id)
);

-- Q4: Normalization Process
--Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.

CREATE TABLE customer_raw (
    customer_id SMALLINT,
    name VARCHAR(90),
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE customer_norm (
    customer_id SMALLINT PRIMARY KEY,
    name VARCHAR(90)
);

CREATE TABLE customer_address (
    address_id SMALLINT PRIMARY KEY,
    customer_id SMALLINT,
    address VARCHAR(255),
    city VARCHAR(50),
    country VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customer_norm(customer_id)
);

-- Q5: CTE Basics
-- Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in.
WITH actor_film_count AS (
    SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS film_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
SELECT * FROM actor_film_count;

-- Q6: CTE with Joins
-- Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.
WITH film_language AS (
    SELECT f.film_id, f.title AS film_title, l.name AS language_name, f.rental_rate
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_language;

-- Q7: CTE for Aggregation
-- Write a query using a CTE to find the total revenue generated by each customer from the customer and payment tables.
WITH customer_revenue AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT * FROM customer_revenue;

-- Q8: CTE with Window Functions
-- Utilize a CTE with a window function to rank films based on their rental duration from the film table.
WITH film_ranks AS (
    SELECT film_id, title, rental_duration,
           RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM film
)
SELECT * FROM film_ranks;

-- Q9: CTE and Filtering
-- Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.
WITH frequent_customers AS (
    SELECT customer_id, COUNT(rental_id) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(rental_id) > 2
)
SELECT c.customer_id, c.first_name, c.last_name, fc.rental_count
FROM frequent_customers fc
JOIN customer c ON fc.customer_id = c.customer_id;

-- Q10: CTE for Date Calculations
-- Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table.
WITH monthly_rentals AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS rental_month, COUNT(rental_id) AS total_rentals
    FROM rental
    GROUP BY DATE_FORMAT(rental_date, '%Y-%m')
)
SELECT * FROM monthly_rentals;

-- Q11: CTE and Self-Join
-- Create a CTE to generate a report showing pairs of actors who have appeared in the same film together using the film_actor table.
WITH actor_pairs AS (
    SELECT fa1.actor_id AS actor1_id, fa2.actor_id AS actor2_id, fa1.film_id
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT * FROM actor_pairs;

-- Q12: CTE for Recursive Search
-- Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column.
WITH RECURSIVE staff_hierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to
    FROM staff
    WHERE staff_id = 1 -- specify manager id
    UNION ALL
    SELECT s.staff_id, s.first_name, s.last_name, s.reports_to
    FROM staff s
    INNER JOIN staff_hierarchy sh ON s.reports_to = sh.staff_id
)
SELECT * FROM staff_hierarchy;
