SELECT 
    *
FROM
    employee
ORDER BY levels DESC
LIMIT 1;

SELECT 
    billing_country, COUNT(invoice_id)
FROM
    invoice
GROUP BY billing_country
ORDER BY 2 DESC
LIMIT 1;

SELECT 
    total
FROM
    invoice
ORDER BY 1 DESC
LIMIT 3;

SELECT 
    billing_city, SUM(total) invoice_total
FROM
    invoice
GROUP BY billing_city
ORDER BY 2 DESC;

SELECT 
    *
FROM
    invoice;
SELECT 
    *
FROM
    customer;
	
SELECT 
    customer.*, customer.customer_id, SUM(invoice.total)
FROM
    invoice
        JOIN
    customer ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY SUM(invoice.total) DESC;


SELECT 
    *
FROM
    genre;


SELECT DISTINCT
    customer.email,
    customer.first_name,
    customer.last_name,
    genre.name
FROM
    customer
        JOIN
    invoice ON customer.customer_id = invoice.customer_id
        JOIN
    invoice_line ON invoice_line.invoice_id = invoice.invoice_id
        JOIN
    track ON track.track_id = invoice_line.track_id
        JOIN
    genre ON genre.genre_id = track.genre_id
WHERE
    genre.name = 'Rock'
ORDER BY customer.email;


SELECT 
    artist.artist_id, artist.name, COUNT(track.track_id)
FROM
    artist
        JOIN
    album ON artist.artist_id = album.artist_id
        JOIN
    track ON track.album_id = album.album_id
        JOIN
    genre ON genre.genre_id = track.genre_id
WHERE
    genre.name = 'Rock'
GROUP BY artist.artist_id
ORDER BY 3 DESC
LIMIT 10;



SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds)
        FROM
            track)
ORDER BY 2 DESC;


SELECT 
    cust.first_name cust_name,
    artist.name artist_name,
    SUM(invoice_line.unit_price * invoice_line.quantity)
FROM
    customer cust
        JOIN
    invoice ON cust.customer_id = invoice.customer_id
        JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        JOIN
    track ON track.track_id = invoice_line.track_id
        JOIN
    album ON album.album_id = track.album_id
        JOIN
    artist ON artist.artist_id = album.artist_id
GROUP BY cust.customer_id , artist.name
ORDER BY 3 DESC
	;


WITH GenrePopularity AS (
    SELECT 
        customer.country, 
        genre.name AS genre_name, 
        COUNT(*) AS total_purchases
    FROM customer
    JOIN invoice ON customer.customer_id = invoice.customer_id
    JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
    JOIN track ON track.track_id = invoice_line.track_id
    JOIN genre ON genre.genre_id = track.genre_id
    GROUP BY customer.country, genre.name
),
RankedGenres AS (
    SELECT 
        country, 
        genre_name, 
        total_purchases,
        RANK() OVER (PARTITION BY country ORDER BY total_purchases DESC) AS genre_rank
    FROM GenrePopularity
)
SELECT 
    country, 
    genre_name, 
    total_purchases
FROM RankedGenres
WHERE genre_rank = 1
ORDER BY country;



WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo = 1;














