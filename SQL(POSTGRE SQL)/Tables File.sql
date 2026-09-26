select * from sales;

CREATE TABLE sales (
    ordernumber VARCHAR(50),
    line_item INTEGER,
    order_date DATE,
    delivery_date DATE,
    customerkey INTEGER,
    storekey INTEGER,
    productkey INTEGER,
    quantity INTEGER,
    currency_code VARCHAR(10)
);

CREATE TABLE stores (
    storekey INTEGER PRIMARY KEY,
    country VARCHAR(100),
    state VARCHAR(100),
    square_meters NUMERIC(12,2),
    open_date DATE
);

select * from stores;


CREATE TABLE exchange_rates (
    date DATE,
    currency VARCHAR(10),
    exchange NUMERIC(12,6)
);

select * from exchange_rates;

