CREATE DATABASE IF NOT EXISTS Salesdatawalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);











-- --------------------------------------------------------------------------------------------------------------------------------------- --
-- ----------------------------------------------	FEATURE ENGINEERING ---------------------------------------------------------------------


-- time_of_day

SELECT 
	time,
    (CASE 
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
            END) AS day_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (CASE 
			WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
            END);
            
            
-- day_name

SELECT date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20);

UPDATE sales 
SET day_name = dayname(date);

-- month_name

SELECT date,
monthname(date)
from sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(20);

UPDATE sales 
SET month_name = monthname(date);


-- ----------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------GENERIC----------------------------------------------------------------------------------------------------

-- how many unique cities does the data have?

SELECT DISTINCT(CITY)
FROM sales;

-- in which city each branch?

SELECT DISTINCT(branch), CITY
FROM sales;


-- -------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------- Product --------------------------------------------------------------------------
-- How many unique product lines does the data have?   

SELECT COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?

SELECT payment,
	COUNT(payment)
FROM sales
GROUP BY payment
ORDER BY COUNT(payment) DESC;

-- What is the most selling product line?

SELECT product_line, COUNT(product_line) AS 'count'
FROM sales
GROUP BY  product_line
ORDER BY count DESC
LIMIT 1;

-- What is the total revenue by month?

SELECT 
	month_name AS month,
    ROUND(SUM(total),0) AS total
FROM sales
GROUP BY month
ORDER BY total DESC;

-- Which month had a largest COGS?

SELECT month_name, SUM(cogs) AS largest_cogs
FROM sales
GROUP BY month_name
ORDER BY largest_cogs DESC;


-- What product line had the largest revenue?

SELECT 
	product_line, ROUND(SUM(Total),0) AS Total_revenue
FROM sales
GROUP BY product_line
ORDER BY Total_revenue DESC;

-- What is the city with the highest revenue?

SELECT 
	city, ROUND(SUM(total),1) AS Revenue
FROM sales
GROUP BY city
ORDER BY Revenue DESC;

-- What product line had the largest VAT?

SELECT
	product_line, SUM(tax_pct) AS VAT
FROM sales
GROUP BY product_line
ORDER BY VAT DESC;

--  Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales.--

SELECT 
	AVG(total) AS average_sales
FROM sales;

SELECT DISTINCT product_line,
	CASE
		WHEN `total` > (SELECT 
	AVG(total) AS average_sales
FROM sales) THEN "Good"
ELSE "Bad"
END AS Status
FROM sales;

-- Which branch sold more products than average product sold?

SELECT
	branch, SUM(quantity) AS total
FROM sales
GROUP BY branch
HAVING total > (SELECT AVG(quantity) FROM sales)
ORDER BY total DESC;

-- What is the most common product line by gender?

SELECT 
	gender, product_line, count(gender) AS Total_count
FROM sales
GROUP BY gender, product_line
ORDER BY Total_count DESC;

-- What is the average rating of each product line?

SELECT 
	product_line, ROUND(avg(rating),2) AS average_rating
FROM sales
GROUP BY product_line
ORDER BY average_rating DESC;


-- -------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------SALES --------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday?

SELECT
	time_of_day, COUNT(*) AS Total_sales
FROM sales
WHERE day_name = "wednesday"
GROUP BY time_of_day
ORDER BY Total_sales DESC;

--  Which of the customer types brings the more revenue?

SELECT 
	customer_type, SUM(total) AS Revenue
FROM sales
GROUP BY customer_type
ORDER BY Revenue DESC;

-- Which city has the largest tax percent/VAT?

SELECT
	city, AVG(tax_pct) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in tax?

SELECT
	customer_type, AVG(tax_pct) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- -----------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------CUSTOMER ----------------------------------------------------------------------------------

-- How many unique customer type does the data have?

SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment method does the data have?

SELECT 
	DISTINCT payment
FROM sales;

-- What is the most common customer type?

SELECT 
	customer_type, COUNT(customer_type) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?

SELECT 
	customer_type, COUNT(invoice_id) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- What is the gender of most of the customers?

SELECT
	gender, COUNT(*) AS count
FROM sales
GROUP BY gender
ORDER BY count DESC;

-- What is the gender distribution of each branch?

SELECT
	gender, COUNT(*) AS cnt
FROM sales
WHERE branch = "a"
GROUP BY gender
ORDER BY cnt DESC;

SELECT
	gender, COUNT(*) AS cnt
FROM sales
WHERE branch = "b"
GROUP BY gender
ORDER BY cnt DESC;

SELECT
	gender, COUNT(*) AS cnt
FROM sales
WHERE branch = "c"
GROUP BY gender
ORDER BY cnt DESC;

-- Which time of the day customers give most ratings?

SELECT time_of_day, avg(rating) AS rating 
FROM sales
GROUP BY time_of_day
ORDER BY rating desc;

-- Which time of the day do customers give most rating per branch?

SELECT
	time_of_day, AVG(rating) AS rating
FROM sales
WHERE branch = "a"
GROUP BY time_of_day
ORDER BY rating DESC;
    
-- Which day of the week has the best average ratings?

SELECT
	day_name, AVG(rating) AS ratings
FROM sales
GROUP BY day_name
ORDER BY ratings DESC;

-- Which day of the week has the best average rating per branch?

SELECT
	day_name, AVG(rating) AS ratings
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY ratings DESC;

SELECT
	month_name, SUM(total) AS total
FROM sales
GROUP BY month_name
ORDER BY total DESC;

SELECT
	gender, avg(total) as total
from sales
group by gender
order by total desc;















            





