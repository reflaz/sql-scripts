SELECT 
    so.order_nr,
    so.created_at,
    MIN(soish.created_at) 'order_verification_in_progress'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 69
WHERE
    order_nr IN ('')
GROUP BY so.order_nr