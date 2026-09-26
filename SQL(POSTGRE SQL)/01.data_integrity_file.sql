--for the row counts

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'sales', COUNT(*)
FROM sales

UNION ALL

SELECT 'stores', COUNT(*)
FROM stores

UNION ALL

SELECT 'exchange_rates', COUNT(*)
FROM exchange_rates;


-- cheaking for Duplicate keys 


-- Customers: duplicate CustomerKey
SELECT 'customers' AS table_name,
       'customerkey' AS key_column,
       customerkey AS key_value,
       COUNT(*) AS duplicate_count
FROM customers
GROUP BY customerkey
HAVING COUNT(*) > 1

UNION ALL

-- Products: duplicate ProductKey
SELECT 'products',
       'productkey',
       productkey,
       COUNT(*)
FROM products
GROUP BY productkey
HAVING COUNT(*) > 1

UNION ALL

-- Stores: duplicate StoreKey
SELECT 'stores',
       'storekey',
       storekey,
       COUNT(*)
FROM stores
GROUP BY storekey
HAVING COUNT(*) > 1;


--checking for sales duplicates

SELECT
    ordernumber,
    line_item,
    COUNT(*) AS duplicate_count
FROM sales
GROUP BY ordernumber, line_item
HAVING COUNT(*) > 1;


--checking customers ket that are actually exists in customers

--counting the customers

SELECT COUNT(*) AS orphan_customer_rows
FROM sales s
LEFT JOIN customers c
    ON s.customerkey = c.customerkey
WHERE c.customerkey IS NULL;

--missing customers keys

SELECT DISTINCT s.customerkey
FROM sales s
LEFT JOIN customers c
    ON s.customerkey = c.customerkey
WHERE c.customerkey IS NULL
ORDER BY s.customerkey;

--counting the how many times the keys appered across the rows

SELECT
    s.customerkey,
    COUNT(*) AS sales_rows
FROM sales s
LEFT JOIN customers c
    ON s.customerkey = c.customerkey
WHERE c.customerkey IS NULL
GROUP BY s.customerkey
ORDER BY sales_rows DESC;

--orphan product keys

SELECT COUNT(*) AS orphan_product_rows
FROM sales s
LEFT JOIN products p
    ON s.productkey = p.productkey
WHERE p.productkey IS NULL;

--missing in the across the sales rows 

SELECT COUNT(DISTINCT s.productkey) AS missing_product_keys
FROM sales s
LEFT JOIN products p
    ON s.productkey = p.productkey
WHERE p.productkey IS NULL;

--orphan storekeys

SELECT COUNT(*) AS orphan_store_rows
FROM sales s
LEFT JOIN stores st
    ON s.storekey = st.storekey
WHERE st.storekey IS NULL;

--checking the rows that none of them are 0 or negative

SELECT COUNT(*) AS invalid_quantity_rows
FROM sales
WHERE quantity IS NULL
   OR quantity <= 0;

--checking missing order dates

SELECT COUNT(*) AS missing_order_dates
FROM sales
WHERE order_date IS NULL;

--checking the currency_code(5 diffrent currency)

SELECT DISTINCT currency_code
FROM sales
ORDER BY currency_code;

--checking currency in exchange_rates

SELECT DISTINCT s.currency_code
FROM sales s
LEFT JOIN exchange_rates e
    ON s.currency_code = e.currency
WHERE e.currency IS NULL;