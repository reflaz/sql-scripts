SELECT 
    so.order_nr
FROM
    oms_live.ims_sales_order so
        JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        AND soi.fk_sales_order_item_status = 27
WHERE
    so.created_at >= '2016-04-08'
        AND so.payment_method = 'mandiri_virtual_payment';