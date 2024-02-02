-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).
SELECT strftime('%Y', order_delivered_customer_date) as year_no,
strftime('%m', order_delivered_customer_date) as month_no, 
substr ("--JanFebMarAprMayJunJulAugSepOctNovDec", strftime ("%m", order_delivered_customer_date) * 3, 3) AS month_str,
SUM(payment_value)
FROM olist_order_payments op 
JOIN olist_orders oo ON oo.order_id = op.order_id 
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY month_no, year_no
ORDER BY month_no ASC