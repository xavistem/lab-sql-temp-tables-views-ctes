USE sakila;

CREATE VIEW rental_summary AS
SELECT
	c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    COUNT(r.rental_id) AS rental_count
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email;

CREATE TEMPORARY TABLE payment_sumary AS
SELECT
	rs.customer_id,
    rs.full_name,
    rs.email,
    rs.rental_count,
    SUM(p.amount) AS total_paid
FROM rental_summary rs
JOIN payment p ON rs.customer_id = p.customer_id
GROUP BY rs.customer_id, rs.full_name, rs.email, rs.rental_count;

WITH customer_cte AS (
    SELECT 
        rs.full_name,
        rs.email,
        rs.rental_count,
        ps.total_paid
    FROM rental_summary rs
    JOIN payment_sumary ps
        ON rs.customer_id = ps.customer_id
)
SELECT 
    full_name,
    email,
    rental_count,
    total_paid,
    ROUND(total_paid / rental_count, 2) AS average_payment_per_rental
FROM customer_cte;