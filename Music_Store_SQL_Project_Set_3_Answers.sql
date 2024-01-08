/* Question Set 3 - Advance */

/* Q1: Find how much amount of money is spent by each customer on the best selling artist? Write a query to return
customer name, artist name and total amount spent? */
WITH best_selling_artist AS (
	SELECT 
		art.artist_id AS artist_id, 
		art.name AS artist_name, 
		SUM(il.unit_price * il.quantity) AS total_sales
	FROM 
		invoice_line il
	Inner JOIN 
		track AS t ON t.track_id = il.track_id
	Inner JOIN 
		album AS alb ON alb.album_id = t.album_id
	Inner JOIN 
		artist AS art ON art.artist_id = alb.artist_id
	GROUP BY 
		artist_id, artist_name
	ORDER BY 
		total_sales DESC
	LIMIT 1
)
SELECT 
	c.customer_id AS Customer_id,
	c.first_name As First_name, 
    c.last_name AS Last_name, 
    bsa.artist_name AS Artist_name, 
    Round(SUM(il.unit_price * il.quantity), 2) AS amount_spent
FROM 
	customer c
Inner JOIN invoice AS i ON c.customer_id = i.customer_id
Inner JOIN invoice_line AS il ON il.invoice_id = i.invoice_id
Inner JOIN track AS t ON t.track_id = il.track_id
Inner JOIN album AS alb ON alb.album_id = t.album_id
Inner JOIN best_selling_artist AS bsa ON bsa.artist_id = alb.artist_id
GROUP BY 
	Customer_id, First_name, Last_name, Artist_name
ORDER BY 
	amount_spent DESC;
    

/* Q2: We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres? */
WITH genre_purchases AS (
    SELECT 
        i.billing_country,
        g.name AS genre_name,
        COUNT(i.invoice_id) AS purchases
    FROM
        invoice AS i
    INNER JOIN
        invoice_line AS il ON i.invoice_id = il.invoice_id
    INNER JOIN
        track AS t ON il.track_id = t.track_id
    INNER JOIN
        genre AS g ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country, g.name
),
ranked_genres AS (
    SELECT
        billing_country,
        genre_name,
        RANK() OVER (PARTITION BY billing_country ORDER BY purchases DESC) AS genre_rank
    FROM
        genre_purchases
)
SELECT
    billing_country,
    genre_name AS top_genre
FROM
    ranked_genres
WHERE
    genre_rank = 1;
    

/* Q3: Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount */
With customer_ranked AS (Select
	c.customer_id As id,
    c.first_name AS first_name,
    c.last_name AS last_name,
    c.country AS country,
    Round(SUM(il.unit_price * il.quantity), 2) AS amount_spent,
    RANK() OVER (PARTITION BY c.country ORDER BY SUM(il.unit_price * il.quantity) DESC) AS top_customer
From
	customer AS c
Inner JOIN 
	invoice AS i ON c.customer_id = i.customer_id
Inner JOIN 
	invoice_line AS il ON il.invoice_id = i.invoice_id
Group By
	c.customer_id, c.first_name, c.last_name, c.country
    )
Select
	id,
    first_name,
    last_name,
    country,
    amount_spent
From
	customer_ranked
Where
	top_customer <= 1
Order By
	amount_spent desc;
