--                               SQL PROJECT- MUSIC STORE DATA ANALYSIS 

---                                        --- Question SET-1   Easy ---

-- 1. Who is the senior most employee based on job title? 
SELECT * from Employee
ORDER BY levels DESC
LIMIT 1;


--2. Which countries have the most Invoices? 

SELECT COUNT(*)AS C, billing_country from Invoice
GROUP BY billing_country
ORDER BY C DESC
LIMIT 1;

--3. What are top 3 values of total invoice?
SELECT  total from Invoice
ORDER BY total DESC
LIMIT 3;

--4. Which city has the best customers? We would like to throw a promotional Music 
--   Festival in the city we made the most money. Write a query that returns one city that 
--   has the highest sum of invoice totals. Return both the city name & sum of all invoice totals. 

SELECT  billing_city AS City , SUM( total) AS Toal_invoice from Invoice
GROUP BY City
ORDER BY Toal_invoice  DESC
LIMIT 1; 

--5. Who is the best customer? The customer who has spent the most money will be 
--   declared the best customer. Write a query that returns the person who has spent the most money.

 SELECT CUSTOMER.customer_id, CONCAT(first_name,last_name) AS BEST_CUSTOMER , SUM(invoice.total) AS Total_Spent from CUSTOMER
 JOIN INVOICE 
 ON  CUSTOMER.customer_id = INVOICE.customer_id
 GROUP BY CUSTOMER.customer_id
 ORDER BY Total_Spent DESC
  LIMIT 1;

                                  --- Question Set 2 – Moderat
--1. Write query to return the email, first name, last name, & Genre of all Rock Music 
--   listeners. Return your list ordered alphabetically by email starting with A

SELECT DISTINCT customer.email, customer.first_name, customer.last_name, Genre.name AS Genre_Name from CUSTOMER
JOIN INVOICE 
    ON customer.customer_id = INVOICE.customer_id
JOIN INVOICE_LINE
    ON INVOICE.invoice_id = INVOICE_LINE.invoice_id
JOIN  TRACK
    ON INVOICE_LINE.track_id =  TRACK.track_id
JOIN GENRE
    ON TRACK.genre_id = GENRE.genre_id
WHERE GENRE.name ='Rock'
ORDER BY customer.email ASC ;


---2. Let's invite the artists who have written the most rock music in our dataset. Write a 
--    query that returns the Artist name and total track count of the top 10 rock bands 

SELECT  Artist.artist_id ,artist.name ,COUNT( Artist.artist_id) AS Number_of_Songs FROM Track
JOIN Album 
    ON Track.album_id = Album.album_id
JOIN Artist
    ON Album.artist_id = Artist.artist_id
JOIN Genre
    ON Track.genre_id = Genre.genre_id

WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY Number_of_Songs DESC;
LIMIT 10;


-- 3. Return all the track names that have a song length longer than the average song length. 
--    Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name,milliseconds from track
Where milliseconds > (SELECT AVG(milliseconds) from track)
ORDER BY milliseconds DESC;


-Praveen Kumar Mourya











 
 





