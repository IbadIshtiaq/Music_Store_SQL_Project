/* Question Set 2 - Moderate */

/* Q1: Write a query to return the email, first name, last name, and genre of all Rock Music Genre 
listeners. Return your list ordered alphabetically by email starting with A? */
SELECT
    Distinct(c.email),
    c.first_name,
    c.last_name,
    g.name AS genre
FROM
    customer c
INNER JOIN
    invoice AS i ON c.customer_id = i.customer_id
INNER JOIN
    invoice_line AS il ON i.invoice_id = il.invoice_id
INNER JOIN
    track AS t ON il.track_id = t.track_id
INNER JOIN
    genre AS g ON t.genre_id = g.genre_id
WHERE
    g.name = 'Rock'
ORDER BY
    c.email ASC;
    
/* Q2: Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT
    art.artist_id AS artist_id,
    art.name AS artist_name,
    Count(t.track_id) AS track_count
FROM
    track t
INNER JOIN
    album AS alb ON t.album_id = alb.album_id
INNER JOIN
    artist AS art ON alb.artist_id = art.artist_id
INNER JOIN
    genre AS g ON t.genre_id = g.genre_id
WHERE
    g.name = 'Rock'
Group By
	artist_id, artist_name
Order By
	track_count desc
Limit
	10;
    
/* Q3: Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first */
Select 
	track_id,
    name,
    milliseconds
From
	track
Where
	milliseconds > (
    Select 
		AVG(milliseconds) AS avg_song_length
	From
		track
        )
Order By
	milliseconds Desc
