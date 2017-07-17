SET @extractstart = DATE_SUB(NOW(), INTERVAL 1 YEAR);

SELECT 
    year_week,
    SUM(unit_price) 'total_sales',
    COUNT(id_sales_order_item) 'total_items_sold'
FROM
    (SELECT 
        soi.id_sales_order_item,
            soi.unit_price,
            IF(DAYNAME(soish.created_at) = 'SUNDAY', YEARWEEK(soish.created_at) - 1, YEARWEEK(soish.created_at)) 'year_week'
    FROM
        oms_live.ims_sales_order_item soi
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    WHERE
        soi.created_at >= @extractstart) result
GROUP BY year_week;