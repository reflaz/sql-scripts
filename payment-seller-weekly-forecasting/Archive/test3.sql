SET @extractstart = DATE_SUB('2016-06-08', INTERVAL 1 YEAR);


SELECT 
    date, SUM(unit_price) sales
FROM
    (SELECT 
        DATE(soish.created_at) 'date', soi.unit_price
    FROM
        oms_live.ims_sales_order_item_status_history soish
    LEFT JOIN oms_live.ims_sales_order_item soi ON soish.fk_sales_order_item = soi.id_sales_order_item
    WHERE
        soish.created_at >= @extractstart) result
GROUP BY date;