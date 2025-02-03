                                   --- Question Set 3 – Advance --- 

-- 1. Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
WITH best_selling_artist AS (
     SELECT Artist.artist_id AS artist_id, Artist.name AS artist_name,
	SUM(Invoice_line.unit_price*Invoice_line.quantity)AS total_sale 
	 FROM Invoice_line
	 JOIN Track ON Track.track_id = Invoice_line.track_id
	 JOIN Album ON Album.album_id = Track.album_id 
	 JOIN Artist ON Artist.artist_id = Album.artist_id 
	 GROUP BY 1               --(here 1 : artist_id,2: artist_name,3: total_sales
	 ORDER BY 3 DESC
	 LIMIT 1
) 
SELECT  c.customer_id, c.first_name, c.last_name, bsa.artist_name,SUM(il.unit_price*il.quantity) AS amount_spent
FROM Invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id =i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist BSA on BSA.artist_id = alb.artist_id
GROUP BY 1,4       --(where 1:customer_id, 2:first_name, 3:last_name, 4:artist_name, 5:amount_spent)
ORDER BY 5 DESC;

/* 2. We want to find out the most popular music Genre for each country. We determine the 
   most popular genre as the genre with the highest amount of purchases. Write a query 
   that returns each country along with the top Genre. For countries where the maximum 
   number of purchases is shared return all Genres */

WITH popular_genre AS
(
  SELECT  COUNT(invoice_line.quantity)AS purchases, customer.country, genre.name , genre.genre_id, 
  ROW_NUMBER()OVER( PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
  FROM invoice_line
  JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
  JOIN customer ON customer.customer_id = invoice.customer_id
  JOIN track ON track.track_id = invoice_line.track_id
  JOIN genre ON genre.genre_id = track.genre_id
  GROUP BY 2,3,4
  ORDER BY 2 ASC, 1 DESC
  )
SELECT * from popular_genre WHERE RowNO <=1 
 
--3. Write a query that determines the customer that has spent the most on music for each country.
--   Write a query that returns the country along with the top customer and how 
--   much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.

 WITH RECURSIVE
     customer_with_country AS 
	 (
      SELECT c.customer_id,first_name,last_name ,billing_country, SUM(total) AS Total_Spending
	  FROM Invoice 
	  JOIN customer c ON  c.customer_id = Invoice.customer_id
	  GROUP BY 1,2,3,4
	  ORDER BY 2,3 DESC
	 ),

	 country_max_spending AS 
	 (
	  SELECT billing_country ,MAX(Total_Spending) AS max_spending
	  FROM customer_with_country
	  GROUP BY  billing_country

	 )

SELECT cc.customer_id, cc.first_name, cc.last_name, cc.billing_country, cc.Total_Spending
FROM customer_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.Total_Spending = ms.max_spending
ORDER BY 4;


--2nd:Method( with CTE )

WITH customer_with_country AS 
	 (
      SELECT c.customer_id,first_name,last_name ,billing_country, SUM(total) AS Total_Spending,
	  ROW_NUMBER()OVER( PARTITION BY billing_country ORDER BY SUM(total)DESC) AS RowNo	 
	  FROM Invoice 
	   JOIN customer c ON  c.customer_id = Invoice.customer_id
	  GROUP BY 1,2,3,4
	  ORDER BY 4 ASC,5 DESC 
	  )

SELECT * FROM customer_with_country 
WHERE RowNo <= 1






--  @Praveen_Kumar_Mourya

	 


	 