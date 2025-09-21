use homework15

--1-task
SELECT *
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

--2-task
SELECT *
FROM products
WHERE price > (SELECT AVG(price) FROM products);

--3-task
SELECT *
FROM employees
WHERE department_id = (
    SELECT id
    FROM departments
    WHERE department_name = 'Sales'
);

--4-task
SELECT *
FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

--5-task
SELECT *
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
);

--6-task
SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
);

--7-task
SELECT *
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e2.department_id = e1.department_id
);

--8-task

SELECT *
FROM grades g1
WHERE grade = (
    SELECT MAX(grade)
    FROM grades g2
    WHERE g2.course_id = g1.course_id
);

--9-task
SELECT *
FROM products p1
WHERE 3 = (
    SELECT COUNT(DISTINCT p2.price)
    FROM products p2
    WHERE p2.category_id = p1.category_id
      AND p2.price >= p1.price
);

--10-task
SELECT *
FROM employees e
WHERE salary > (SELECT AVG(salary) FROM employees)
  AND salary < (
      SELECT MAX(salary)
      FROM employees
      WHERE department_id = e.department_id
  );

  ---cte
  --9-task
  WITH RankedProducts AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) AS rn
    FROM products
)
SELECT *
FROM RankedProducts
WHERE rn = 3;

--10-task

WITH DeptMax AS (
    SELECT department_id, MAX(salary) AS max_salary
    FROM employees
    GROUP BY department_id
),
CompanyAvg AS (
    SELECT AVG(salary) AS avg_salary
    FROM employees
)
SELECT e.*
FROM employees e
CROSS JOIN CompanyAvg ca
JOIN DeptMax dm ON e.department_id = dm.department_id
WHERE e.salary > ca.avg_salary
  AND e.salary < dm.max_salary;
