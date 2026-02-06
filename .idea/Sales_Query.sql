CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),
                quantity	INT,
                price_per_unit FLOAT,
                cogs	FLOAT,
                total_sale FLOAT
            );


SELECT * FROM retail_sales;

SELECT
    Count (*)
FROM retail_sales;

SELECT * FROM retail_sales
WHERE transaction_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

-- Checking if there is any date that needs to be cleaned

SELECT * FROM retail_sales
WHERE
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- Deleting any nulls in the data set

DELETE FROM retail_sales
WHERE transaction_id is null
OR sale_date is null
OR sale_time is null
OR gender is null
OR quantity is null
OR cogs is null
OR total_sale is null;

SELECT count(DISTINCT customer_id) AS customer_count
FROM retail_sales;

-- Looking into some business question

-- Checking to see sales on Nov 05
SELECT * FROM retail_sales
where sale_date = '2022-11-05';

-- Looking into clothing sales in Nov 2022  with greater than or equal to 4
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND to_char(sale_date,'YYYY-MM') =  '2022-11';

-- Looking at the sales and total orders of each category
SELECT
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1;

-- Looking at average age of customers who bought beauty products
SELECT category, avg( age)
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 1;

-- All total sales that are greater than 100
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Looking at total sales for categories for genders
SELECT category, gender, COUNT(*) as total_trans
FROM retail_sales
GROUP by category, gender
ORDER BY 1;

-- Checking what month has the highest avg
SELECT year,month,avg_sale
FROM (
SELECT
    EXTRACT(year FROM sale_date) as year,
    EXTRACT(month FROM sale_date ) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER (PARTITION BY  EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
  ) as t1
WHERE rank = 1;
-- Looking at top 5 customers
SELECT customer_id, sum(total_sale) as total
FROM retail_sales
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;

-- Find how many unique customers purchased items in each category
SELECT category, count(distinct customer_id) as uni_customer
FROM retail_sales
group by category;

-- Looking into how many orders were made during each shift
WITH hourly_sale as
    (SELECT *,
         CASE
            WHEN extract(HOUR FROM sale_time) < 12 then 'Morning'
            WHEN extract(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as shift
            FROM retail_sales)
    SELECT shift,count(*) as total_orders
    FROM hourly_sale
    GROUP BY shift;
