SELECT 
    pd.tracking_number 'tracking_number',
    so.order_nr 'order_nr',
    sup.name 'seller_name',
    SUM(soi.unit_price) 'unit_price',
    sois.name 'item_status',
    soish.created_at 'delivered_update_date'
FROM
    oms_live.oms_package_dispatching pd
        LEFT JOIN
    oms_live.oms_package pck ON pd.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
        LEFT JOIN
    oms_live.ims_supplier sup ON soi.bob_id_supplier = sup.bob_id_supplier
WHERE
    pd.tracking_number IN ('')
GROUP BY soi.bob_id_sales_order_item