CREATE  DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT Float(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2,1)
    
);


-- ---------------------------------------------------------------

-- Feature Engineering---------------------------------------

-- time_of_day
SELECT 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "02:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "02:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
	END
);

-- -----------------------------------------------------------------------
-- day_name
SELECT
	date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- -------------------------------------------------------------------------------
-- month_name
SELECT
	date,
    MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ------------------------------------------------------------------------------
-- Generic ----------------------------------------------------------------------

-- How many unique cities does the data have?
SELECT 
	DISTINCT city
FROM sales;

-- How many distinct branch?
SELECT 
	DISTINCT branch
FROM sales;

-- In which city is each branch?
SELECT
	DISTINCT city,
    branch
FROM sales;

-- ----------------------------------------------------------------------------------
-- PRODUCT ----
-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;

-- what is the most common payment method?
SELECT
	payment_method,
	COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- what is the most selling product line?
SELECT
	product_line,
	COUNT(product_line) AS prod_cnt
FROM sales
GROUP BY product_line
ORDER BY prod_cnt DESC;

-- what is the total revenue by month?
SELECT
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER By total_revenue DESC;

-- what month had the largest COGS
SELECT 
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER By cogs DESC;	

-- what product line had the largest revenue?
SELECT
	product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- what is the city with the largest revenue?
SELECT
	branch, city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- what product line had the largest VAT?
SELECT
	product_line,
    AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- what is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER By total_cnt DESC;

-- what is the average rating of each product line?
SELECT
	ROUND(AVG(rating),2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- ----------------------------------------------------------------------------------- --
-- ----------------------------------- SALES ----------------------------------------- --

-- Number of sales made in each time of the day per weekday --

SELECT
	*
FROM sales;

SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY Total_sales DESC;

-- ------------- which of the customer types brings more revenue ------------------ ---
SELECT
	customer_type,
    SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest percentage of tax/VAX --- --
SELECT
	city,
    AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- -------- Which customer type pays the most VAT --- --
SELECT
	customer_type,
    AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;

-- ---------------------------------------------------------------------------- ---- --
-- ------- -------------- CUSTOMER INFO --------------------------------- --
-- ---- How many unique customer types does the data have? -------------------------- --
SELECT
	DISTINCT customer_type,
    COUNT(*) AS customers
FROM sales
GROUP BY customer_type;

-- How many unique payment methods does the data have? --
SELECT
	DISTINCT payment_method
FROM sales;

-- what is the most common customer type -- 
SELECT
	DISTINCT customer_type,
    COUNT(*) AS customer_types
FROM sales
GROUP BY customer_type
ORDER BY customer_types DESC;

-- Which customer type buys the most? --
SELECT
	customer_type,
    COUNT(*) AS customer_count
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers? --- --
SELECT
	gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- what is the gender distribution of branch --
SELECT
	gender,
    COUNT(*) AS gender_count
FROM sales
WHERE branch = "A" -- do for banches B, C --
GROUP BY gender
ORDER BY gender_count DESC;

-- What time of the day do customers give most ratings --
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch? --
SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C" -- do for branches A, B too --
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day of the week has the best avg rating --
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average rating per branch --
SELECT
	day_name,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A" -- do for branches B, C too --
GROUP BY day_name
ORDER BY avg_rating DESC;


