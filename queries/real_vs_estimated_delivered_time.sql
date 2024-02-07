-- TODO: This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. It will have different 
-- columns: month_no, with the month numbers going from 01 to 12; month, with 
-- the 3 first letters of each month (e.g. Jan, Feb); Year2016_real_time, with 
-- the average delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_real_time, with the average delivery time per month of 2017 (NaN if 
-- it doesn't exist); Year2018_real_time, with the average delivery time per 
-- month of 2018 (NaN if it doesn't exist); Year2016_estimated_time, with the 
-- average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
-- Year2017_estimated_time, with the average estimated delivery time per month 
-- of 2017 (NaN if it doesn't exist) and Year2018_estimated_time, with the 
-- average estimated delivery time per month of 2018 (NaN if it doesn't exist).
-- HINTS
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.
WITH order_my as (
	SELECT
	    strftime('%m', o.order_purchase_timestamp) AS month_no,
	    substr ("--JanFebMarAprMayJunJulAugSepOctNovDec", STRFTIME('%m', order_purchase_timestamp) * 3, 3) AS month,
	    strftime('%Y', o.order_purchase_timestamp) AS year,
	    JULIANDAY(order_delivered_customer_date) - JULIANDAY(order_purchase_timestamp) as real_delivery_time,
	    JULIANDAY(order_estimated_delivery_date) - JULIANDAY(order_purchase_timestamp) AS estimated_delivery_time
	FROM
	    olist_orders o
	WHERE o.order_status = 'delivered' AND o.order_delivered_customer_date IS NOT NULL
)
SELECT
    month_no, month,
    AVG(CASE WHEN year = '2016' THEN real_delivery_time END) AS Year2016_real_time,
    AVG(CASE WHEN year = '2017' THEN real_delivery_time END) AS Year2017_real_time,
    AVG(CASE WHEN year = '2018' THEN real_delivery_time END) AS Year2018_real_time,
    AVG(CASE WHEN year = '2016' THEN estimated_delivery_time END) AS Year2016_estimated_time,
    AVG(CASE WHEN year = '2017' THEN estimated_delivery_time END) AS Year2017_estimated_time,
    AVG(CASE WHEN year = '2018' THEN estimated_delivery_time END) AS Year2018_estimated_time
FROM order_my
GROUP BY month_no
ORDER BY month_no