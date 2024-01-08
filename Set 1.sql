/* Question Set 1 - Easy */

-- Q1: Based on the job level, who is the senior most employee and what is their job title?
Select
	employee_id,
    first_name,
    last_name,
    title
From
	employee
Order by
	levels desc
Limit 1;

-- Q2: What are the Top 10 countries with the most Invoices?
Select 
    billing_country,
    Count(invoice_id) As Num_of_invoices
From 
	invoice
Group by
	billing_country
order by
	Num_of_invoices desc
Limit 10;

-- Q3: What are Top 3 Invoice total values, 2 decimal places, and their invoice_id?
Select 
	invoice_id,
    Round(total, 2) As invoice_total
From
	invoice
Order By
	total desc
Limit 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals. */
SELECT 
	billing_city,
    Round(Sum(total), 2) AS invoice_total
FROM 
	invoice
GROUP BY 
	billing_city
ORDER BY 
	invoice_total desc
LIMIT 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money. */
Select
	c.customer_id,
    c.first_name,
    c.last_name,
    Round(Sum(i.total), 2) As amount_of_money_spent
From
	customer As c
Inner Join
	invoice As i ON c.customer_id = i.customer_id
Group By
	c.customer_id, c.first_name, c.last_name
Order By
	amount_of_money_spent desc
Limit 1;