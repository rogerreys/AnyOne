-- TODO: This query will return a table with the revenue by month and year. It
-- will have different columns: month_no, with the month numbers going from 01
-- to 12; month, with the 3 first letters of each month (e.g. Jan, Feb);
-- Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist);
-- Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and
-- Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

WITH revenue_mon_year as (
	SELECT olist_order_payments.order_id, MIN(olist_order_payments.payment_value) as payment_value
	from olist_order_payments 
	group by olist_order_payments.order_id 
) 
SELECT STRFTIME("%m", olist_orders.order_delivered_customer_date)  as month_no,
case STRFTIME("%m", olist_orders.order_delivered_customer_date) 
when "01" then "JAN"
when "02" then "FEB"
when "03" then "MAR"
when "04" then "APR"
when "05" then "MAY"
when "06" then "JUN"
when "07" then "JUL"
when "08" then "AUG"
when "09" then "SEP"
when "10" then "OCT"
when "11" then "NOV"
when "12" then "DEC"
END AS month,
SUM(CASE strftime('%Y', order_delivered_customer_date) WHEN '2016' THEN (rm.payment_value) ELSE 0.0  END) AS 'Year2016',
SUM(CASE strftime('%Y', order_delivered_customer_date) WHEN '2017' THEN (rm.payment_value) ELSE 0.0  END) AS 'Year2017',
SUM(CASE strftime('%Y', order_delivered_customer_date) WHEN '2018' THEN (rm.payment_value) ELSE 0.0  END) AS 'Year2018'
from revenue_mon_year as rm, olist_orders   
WHERE olist_orders.order_id = rm.order_id
AND olist_orders.order_delivered_customer_date is not null and olist_orders.order_purchase_timestamp is NOT NULL 
and olist_orders.order_status = 'delivered'
GROUP by month_no, month

-- WITH revenue_mon_year as (
-- 	SELECT olist_order_payments.order_id, MIN(olist_order_payments.payment_value) as pv
-- 	from olist_order_payments 
-- 	group by olist_order_payments.order_id 
-- )
-- SELECT month_no, month_str, 
-- COALESCE(SUM(CASE WHEN year_no = '2016' THEN revenue ELSE 0 END), 0.00) AS Year2016,
-- COALESCE(SUM(CASE WHEN year_no = '2017' THEN revenue ELSE 0 END), 0.00) AS Year2017,
-- COALESCE(SUM(CASE WHEN year_no = '2018' THEN revenue ELSE 0 END), 0.00) AS Year2018
-- FROM (
-- 	SELECT strftime('%Y', order_delivered_customer_date) as year_no,
-- 	JULIANDAY(strftime('%m', order_delivered_customer_date)) AS month_no, 
-- 	substr ("--JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC", strftime ("%m", order_delivered_customer_date) * 3, 3) AS month_str,
-- 	SUM(rm.pv) as revenue
-- 	FROM olist_orders AS oo  
-- 	JOIN revenue_mon_year AS rm ON rm.order_id = oo.order_id 
-- 	WHERE  oo.order_id = rm.order_id AND oo.order_status = "delivered" AND order_delivered_customer_date IS NOT NULL
-- 	GROUP BY month_no, year_no
-- ) AS revenue_by_month
-- GROUP BY month_no
-- ORDER BY month_no;