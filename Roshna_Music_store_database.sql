Q1: Who is the the senior most empoyee base on job title?

select *  from employee
 SELECT First_Name, Last_Name,Title FROM Employee
 ORDER BY Levels DESC
 LIMIT 1

Q2: Which countries have the most Invoices?

select * from Invoice
SELECT Billing_country,COUNT(*) FROM Invoice
GROUP BY Billing_country
ORDER BY COUNT (Billing_country) DESC
LIMIT 3

Q3: What are top 3 values of total invoice?
SELECT Total FROM Invoice
ORDER BY Total DESC
LIMIT 3

Q4: Which city has the best customers?
We would like to throw a promotional Music Festival in the city we made the most money.
Write a query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice totals 

select * from Invoice
SELECT Billing_City, SUM(Total) as Invoice_Total 
FROM Invoice
GROUP BY Billing_City
ORDER BY Invoice_Total  DESC

Q5:Who is the best customer?
The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money

SELECT Customer.CUSTOMER_ID, Customer.FIRST_NAME, Customer.LAST_NAME, SUM(Invoice.Total) AS TOTAL_SPENT
FROM Customer
JOIN Invoice ON Customer.CUSTOMER_ID=Invoice.CUSTOMER_ID
GROUP BY Customer.CUSTOMER_ID
ORDER BY TOTAL_SPENT DESC
LIMIT 1

/* MORDERATE ANALYSIS */

Q1:Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A.

SELECT DISTINCT Email,First_Name,last_Name
From Customer
JOIN Invoice ON Customer.Customer_ID=Invoice.Customer_ID
JOIN Invoice_line ON Invoice.Invoice_ID=Invoice_line.Invoice_ID
WHERE Track_ID IN (
      SELECt Track_ID FROM Track
      JOIN Genre ON Track.Genre_ID=Genre.Genre_ID
      WHERE Genre.Name LIKE 'Rock')
	  ORDER BY Email ASC
	  
Q2:Lets invite the artists who have written the most rock music in our dataset.
Write a query that returns the Artist name and total track count of the top 10 rock bands.

SELECT Artist.Artist_ID,Artist.Name,COUNT(Artist.artist_ID) AS Numbers_of_songs
FROM Artist
JOIN Album ON Artist.Artist_Id=Album.Artist_ID
JOIN Track ON Album.Album_ID=Track.Album_ID
JOIN Genre ON Track.Genre_ID=Genre.Genre_ID
WHERE Genre.Name Like 'Rock'
GROUP BY Artist.Artist_ID
ORDER BY Numbers_of_songs DESC
LIMIT 10

Q3:Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track.
Order by the song length with the longest songs listed first.

SELECT Name,Milliseconds
FROM Track
WHERE Milliseconds > (
SELECT AVG(Milliseconds)
FROM Track)
ORDER BY Milliseconds DESC

/* ADVANCE ANALYSIS */

Q1:Find how much amount spent by each customer on artists?
Write a query to return customer name, artist name and total spent.

WITH BEST_SELLING_ARTIST AS (
	SELECT ARTIST.ARTIST_ID AS ARTIST_ID, ARTIST.NAME AS ARTIST_NAME,
	SUM(INVOICE_LINE.UNIT_PRICE*INVOICE_LINE.QUANTITY) AS TOTAL_SALES
	FROM INVOICE_LINE
	JOIN TRACK ON TRACK.TRACK_ID=INVOICE_LINE.INVOICE_ID
	JOIN ALBUM ON ALBUM.ALBUM_ID=TRACK.ALBUM_ID
	JOIN ARTIST ON ARTIST.ARTIST_ID=ALBUM.ARTIST_ID
	GROUP BY 1
	LIMIT 1
)
SELECT CUSTOMER.CUSTOMER_ID, CUSTOMER.FIRST_NAME, CUSTOMER.LAST_NAME, BEST_SELLING_ARTIST.ARTIST_NAME,
SUM(INVOICE_LINE.UNIT_PRICE*INVOICE_LINE.QUANTITY) AS AMOUNT_SPENT
FROM INVOICE
JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID=INVOICE.CUSTOMER_ID
JOIN INVOICE_LINE ON INVOICE_LINE.INVOICE_ID = INVOICE.INVOICE_ID
JOIN TRACK ON TRACK.TRACK_ID = INVOICE_LINE.TRACK_ID
JOIN ALBUM ON ALBUM.ALBUM_ID = TRACK.ALBUM_ID
JOIN BEST_SELLING_ARTIST ON BEST_SELLING_ARTIST.ARTIST_ID = ALBUM.ARTIST_ID
GROUP BY 1,2,3,4
ORDER BY 5 DESC

Q2:We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest amount of purchases. 
Write  a query that returns each country along with the top Genre.
For countris where the maximum number of purchases is shared return all Genres.

WITH POPULAR_GENRE AS (
	SELECT COUNT(INVOICE_LINE.QUANTITY) AS PURCHASES, CUSTOMER.COUNTRY ,GENRE.NAME,GENRE.GENRE_ID,
	ROW_NUMBER()OVER(PARTITION BY CUSTOMER.COUNTRY ORDER BY COUNT(INVOICE_LINE.QUANTITY) DESC) AS ROWNO
	FROM INVOICE_LINE
	JOIN INVOICE ON INVOICE.INVOICE_ID=INVOICE_LINE.INVOICE_ID
	JOIN CUSTOMER ON CUSTOMER.CUSTOMER_ID=INVOICE.INVOICE_ID
	JOIN TRACK ON TRACK.TRACK_ID=INVOICE_LINE.INVOICE_ID
	JOIN GENRE ON GENRE.GENRE_ID=TRACK.GENRE_ID
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
	)
	SELECT * FROM POPULAR_GENRE WHERE ROWNO <=1
	
	Q3: Write a query that determine the customer that has spent the most on music for each,
	Write a query that returns the country along with the top customer and how much they spent,
	For countries where the top amount is shared, provide all customers who spent this amount
	
	WITH Customer_with_country AS (
	   SELECT Customer.customer_Id,First_Name , Last_Name, Billing_country,SUM(Total) AS Total_spending,
	   ROW_NUMBER()OVER(PARTITION BY Billing_COUNTRY ORDER BY SUM(Total) DESC) AS ROWNO
	   FROM Invoice
	   JOIN Customer ON Customer.Customer_Id=Invoice.Customer_Id
	   GROUP BY 1,2,3,4
	   ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customer_with_country WHERE ROWNO<= 1
	   
	  