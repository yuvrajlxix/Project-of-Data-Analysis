--1.Total Sales transactions

select count(*) as Total_Sales_Transactions
from sales;

--total sales transactions are 24344

--2.total quantity sold

select sum(quantity) as total_quantity
from sales;

--total quantity is 76908

--3.total unique orders

select count (distinct ordernumber) as unique_orders
from sales;

--unique orders are 10129

--4.total unique customers

select count (distinct customerkey) as unique_customers
from sales;

--unique customers are 7179

--5.how many diffrent currencies

select count (distinct currency_code) as total_currencies
from sales;

--there is a total 5 unique currencies


--------------------------------------------

----PRODUCT ANALYSIS----

--6.which product sold the highest 

SELECT
    p.productkey,
    p.productname,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN products p
    ON s.productkey = p.productkey
GROUP BY
    p.productkey,
    p.productname
ORDER BY SUM(s.quantity) DESC
LIMIT 1;

--7.2nd highest qunatity sold

SELECT 
	p.productkey,
	p.productname,
	SUM(s.quantity) AS total_quantity_sold
from sales s 
join products p
	ON s.productkey = p.productkey
GROUP BY
	p.productkey,
	p.productname
ORDER BY SUM(s.quantity) DESC
LIMIT 1 OFFSET 1;

--8.product with the lowest quantity sold

SELECT 
	p.productkey,
	p.productname,
	SUM(s.quantity) AS total_quantity_sold
from sales s
join products p
	ON s.productkey = p.productkey
GROUP BY 
	p.productkey,
	p.productname
ORDER BY SUM(s.quantity) ASC
LIMIT 1;


--9.2nd lowest quantity sold


SELECT 
	p.productkey,
	p.productname,
	SUM(s.quantity) AS total_quantity_sold
from sales s
join products p
	ON s.productkey = p.productkey
GROUP BY 
	p.productkey,
	p.productname
ORDER BY SUM(s.quantity) ASC
LIMIT 1 OFFSET 1;


--10.Top 5 products by quantity sold


SELECT 
	p.productkey,
	p.productname,
	SUM(s.quantity) AS total_quantity_sold
from sales s
join products p
	ON s.productkey = p.productkey
GROUP BY 
	p.productkey,
	p.productname
ORDER BY SUM(s.quantity) DESC
LIMIT 5;


--11.bottom 5 products by quantity sold


SELECT 
	p.productkey,
	p.productname,
	SUM(s.quantity) AS total_quantity_sold
from sales s
join products p
	ON s.productkey = p.productkey
GROUP BY 
	p.productkey,
	p.productname
ORDER BY SUM(s.quantity) ASC
LIMIT 5;


--12.products with high quantity sold but low unit price

WITH product_sales AS (
    SELECT 
        p.productkey,
        p.productname,
        p.unit_price_usd,
        SUM(s.quantity) AS total_quantity_sold
    FROM sales s
    JOIN products p
        ON s.productkey = p.productkey
    GROUP BY 
        p.productkey,
        p.productname,
        p.unit_price_usd
)
SELECT *
FROM product_sales
WHERE total_quantity_sold > (
    SELECT AVG(total_quantity_sold)
    FROM product_sales
)
AND unit_price_usd < (
    SELECT AVG(unit_price_usd)
    FROM products
)
ORDER BY total_quantity_sold DESC;


--13.Highest qunatity sold by category

SELECT
    p.category,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN products p
    ON s.productkey = p.productkey
GROUP BY p.category
ORDER BY SUM(s.quantity) DESC
LIMIT 1;


--14.lowest quantity sold by category

SELECT
    p.category,
    SUM(s.quantity) AS total_quantity_sold
FROM products p
JOIN sales s
    ON p.productkey = s.productkey
GROUP BY p.category
ORDER BY SUM(s.quantity) ASC
LIMIT 1;


--15.top 5 subcategories by sold

SELECT
    p.subcategory,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN products p
    ON s.productkey = p.productkey
GROUP BY p.subcategory
ORDER BY SUM(s.quantity) DESC
LIMIT 5 ;


--16 category/subcategory cintribution to total quantity

SELECT
    p.category,
    SUM(s.quantity) AS category_quantity,
    ROUND(
        SUM(s.quantity) * 100.0
        / SUM(SUM(s.quantity)) OVER(),
        2
    ) AS contribution_percentage
FROM sales s
JOIN products p
    ON s.productkey = p.productkey
GROUP BY p.category
ORDER BY contribution_percentage DESC;


--17 store with the highest qunatity sold

SELECT
    s.storekey,
    s.country,
    s.state,
    SUM(l.quantity) AS total_quantity_sold
FROM stores s
JOIN sales l
    ON s.storekey = l.storekey
GROUP BY
    s.storekey,
    s.country,
    s.state
ORDER BY SUM(l.quantity) DESC
LIMIT 1;


--18 top5 stores with qunattiy sold

SELECT
    s.storekey,
    s.country,
    s.state,
    SUM(l.quantity) AS total_quantity_sold
FROM stores s
JOIN sales l
    ON s.storekey = l.storekey
GROUP BY
    s.storekey,
    s.country,
    s.state
ORDER BY SUM(l.quantity) DESC
LIMIT 5;


--19 lowest quantity sold store

SELECT
    s.storekey,
    s.country,
    s.state,
    SUM(l.quantity) AS total_quantity_sold
FROM stores s
JOIN sales l
    ON s.storekey = l.storekey
GROUP BY
    s.storekey,
    s.country,
    s.state
ORDER BY SUM(l.quantity) ASC
LIMIT 1;


--20 Store with highest sales volume per square meter

SELECT
    s.storekey,
    s.country,
    s.state,
    s.square_meters,
    SUM(l.quantity) AS total_quantity_sold,
    SUM(l.quantity) / NULLIF(s.square_meters, 0) AS quantity_per_sq_meter
FROM stores s
JOIN sales l
    ON s.storekey = l.storekey
GROUP BY
    s.storekey,
    s.country,
    s.state,
    s.square_meters
ORDER BY quantity_per_sq_meter DESC
LIMIT 1;


--21 longest open stores

SELECT *
FROM stores
ORDER BY open_date ASC
LIMIT 5;


--22 customers with hihest quantity purchased


SELECT
    c.customerkey,
    c.name,
    SUM(s.quantity) AS total_quantity
FROM sales s
JOIN customers c
    ON s.customerkey = c.customerkey
GROUP BY
    c.customerkey,
    c.name
ORDER BY total_quantity DESC
LIMIT 1;


--23 2nd highest customer by quantity purchased

SELECT
    c.customerkey,
    c.name,
    SUM(s.quantity) AS total_quantity
FROM sales s
JOIN customers c
    ON s.customerkey = c.customerkey
GROUP BY
    c.customerkey,
    c.name
ORDER BY total_quantity DESC
LIMIT 1 OFFSET 1;


--24 top 5 customer by quantity purchased

SELECT
    c.customerkey,
    c.name,
    SUM(s.quantity) AS total_quantity
FROM sales s
JOIN customers c
    ON s.customerkey = c.customerkey
GROUP BY
    c.customerkey,
    c.name
ORDER BY total_quantity DESC
LIMIT 5;


--25 customers who purchased more than 10 quantity


SELECT
    c.name,
    SUM(s.quantity) AS total_quantity
FROM customers c
JOIN sales s
    ON c.customerkey = s.customerkey
GROUP BY c.name
HAVING SUM(s.quantity) > 25
ORDER BY total_quantity DESC;


--26 total quantity sold by month


SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY month
ORDER BY month;


--27 month with highest quantity sold


SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY month
ORDER BY total_quantity DESC
LIMIT 1;


--28 month with lowest quantity sold

SELECT
    DATE_TRUNC('month', order_date) AS month,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY month
ORDER BY total_quantity ASC
LIMIT 1;


--29 yearly sales trend


SELECT
    DATE_TRUNC('year', order_date) AS year,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY year
ORDER BY year;


--30 year with the highest quantity sold

SELECT
    DATE_TRUNC('year', order_date) AS year,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY year
ORDER BY total_quantity DESC
LIMIT 1;


--31 using rank() to rank the product which slod more quantity


SELECT
    p.productkey,
    p.productname,
    SUM(s.quantity) AS total_sold_quantity,
    RANK() OVER (ORDER BY SUM(s.quantity) DESC) AS product_rank
FROM products p
JOIN sales s
    ON p.productkey = s.productkey
GROUP BY
    p.productkey,
    p.productname;


--32 using dense rank() to rank the product which sold more quantity


SELECT
    p.productkey,
    p.productname,
    SUM(s.quantity) AS total_sold_quantity,
    DENSE_RANK() OVER(
        ORDER BY sum(s.quantity) DESC
    ) AS product_dense_rank
FROM products p
JOIN sales s
    ON p.productkey = s.productkey
GROUP BY
    p.productkey,
    p.productname;


--33 top 3 products in each category using by partition()

WITH product_ranks AS (
    SELECT
        p.category,
        p.productkey,
        p.productname,
        SUM(s.quantity) AS total_sold_quantity,
        RANK() OVER (
            PARTITION BY p.category
            ORDER BY SUM(s.quantity) DESC
        ) AS product_rank
    FROM products p
    JOIN sales s
        ON p.productkey = s.productkey
    GROUP BY
        p.category,
        p.productkey,
        p.productname
)
SELECT *
FROM product_ranks
WHERE product_rank <= 3
ORDER BY category, product_rank;


--34 running by month

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(quantity) AS monthly_quantity
    FROM sales
    GROUP BY month
)
SELECT
    month,
    monthly_quantity,
    SUM(monthly_quantity) OVER (
        ORDER BY month
    ) AS running_total
FROM monthly_sales
ORDER BY month;


--35 Find all products whose total quantity sold is greater than the average quantity sold across all products.

WITH greater AS (
    SELECT
        p.productkey,
        p.productname,
        SUM(s.quantity) AS total_sold
    FROM products p
    JOIN sales s
        ON p.productkey = s.productkey
    GROUP BY
        p.productkey,
        p.productname
)
SELECT *
FROM greater
WHERE total_sold > (
    SELECT AVG(total_sold)
    FROM greater
);


--36 total revenue

SELECT
    SUM(p.unit_price_usd * s.quantity) AS total_revenue
FROM products p
JOIN sales s
    ON p.productkey = s.productkey;


--37 total cost

SELECT
    SUM(p.unit_cost_usd * s.quantity) AS total_cost
FROM sales s
JOIN products p
    ON p.productkey = s.productkey;


--38 total profit

SELECT
    SUM((p.unit_price_usd - p.unit_cost_usd) * s.quantity) AS total_profit
FROM sales s
JOIN products p
    ON p.productkey = s.productkey;


--39 highest profit in product

SELECT
    p.productkey,
    p.productname,
    SUM((p.unit_price_usd - p.unit_cost_usd) * s.quantity) AS total_profit
FROM sales s
JOIN products p
    ON p.productkey = s.productkey
GROUP BY
    p.productkey,
    p.productname
ORDER BY total_profit DESC
LIMIT 1;


--40 highest profit by category

SELECT
    p.category,
    SUM((p.unit_price_usd - p.unit_cost_usd) * s.quantity) AS category_profit
FROM sales s
JOIN products p
    ON p.productkey = s.productkey
GROUP BY p.category
ORDER BY category_profit DESC
LIMIT 1;