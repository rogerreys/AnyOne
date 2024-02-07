-- TODO: This query will return a table with the top 10 least revenue categories 
-- in English, the number of orders and their total revenue. The first column 
-- will be Category, that will contain the top 10 least revenue categories; the 
-- second one will be Num_order, with the total amount of orders of each 
-- category; and the last one will be Revenue, with the total revenue of each 
-- catgory.
-- HINT: All orders should have a delivered status and the Category and actual 
-- delivery date should be not null.
SELECT pct.product_category_name_english AS Category,
COUNT(DISTINCT oo.order_id) AS Num_order,
round(SUM(oop.payment_value),2) AS Revenue
FROM olist_orders oo, olist_order_items ooi, olist_products op,
olist_order_payments oop, product_category_name_translation pct
WHERE oo.order_id = ooi.order_id
AND ooi.product_id = op.product_id
AND op.product_category_name = pct.product_category_name
AND oo.order_id = oop.order_id
AND op.product_category_name IS NOT NULL AND oo.order_delivered_customer_date is not null
GROUP BY Category
ORDER BY Revenue
LIMIT 10;