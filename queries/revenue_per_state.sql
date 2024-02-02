-- TODO: This query will return a table with two columns; customer_state, and 
-- Revenue. The first one will have the letters that identify the top 10 states 
-- with most revenue and the second one the total revenue of each.
-- HINT: All orders should have a delivered status and the actual delivery date 
-- should be not null. 
select customer_state, SUM(op.payment_value) as Revenue 
from olist_orders as oo
JOIN olist_customers as oc on oo.customer_id = oc.customer_id
JOIN olist_order_payments as op on oo.order_id = op.order_id 
where oo.order_status = "delivered"
AND oo.order_delivered_customer_date IS NOT NULL
GROUP by customer_state
ORDER BY Revenue DESC 
LIMIT 10;