SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    soi.unit_price,
    tr.value 'item_price_credit',
    soi.sku,
    sois.name 'item_status',
    DATE_FORMAT(so.created_at, '%m-%d-%Y') 'order_date',
    DATE_FORMAT(soish.created_at, '%m-%d-%Y') 'delivered_update_date',
    DATE_FORMAT(tr.created_at, '%m-%d-%Y') 'transaction_date',
    DATE_FORMAT(ts.start_date, '%m-%d-%Y') 'start_date',
    DATE_FORMAT(ts.end_date, '%m-%d-%Y') 'end_date'
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
        LEFT JOIN
    screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
        LEFT JOIN
    screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type = 13
        LEFT JOIN
    screport.transaction_statement ts ON tr.fk_transaction_statement = ts.id_transaction_statement
WHERE
    soi.sku = 'NO654SPAJPC9ANID-497737'
        AND so.created_at >= '2015-10-01'
        AND so.created_at < '2015-11-01'