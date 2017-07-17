SELECT 
    sup.name 'Seller Name',
    sup.id_supplier 'Seller ID',
    soi.paid_price 'Paid Price',
    so.payment_method 'Payment Method',
    so.created_at 'Order Created Date',
    soish.created_at 'Delivered Update Date'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        JOIN
    oms_live.ims_sales_order_item_status_history soish1 ON soi.id_sales_order_item = soish1.fk_sales_order_item
        AND soish1.fk_sales_order_item_status = 67
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
WHERE
    so.created_at >= '2016-09-01'
        AND so.created_at < '2016-09-21'
        AND soi.bob_id_supplier IN ('6698' , '19014',
        '23516',
        '15098',
        '9088',
        '9655',
        '29585',
        '10138',
        '30832',
        '10842',
        '14603',
        '28688',
        '9653',
        '14541',
        '9349',
        '14663',
        '14662',
        '19730');
        
SELECT 
    SUM(soi.paid_price) 'Paid Price'
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        JOIN
    oms_live.ims_sales_order_item_status_history soish1 ON soi.id_sales_order_item = soish1.fk_sales_order_item
        AND soish1.fk_sales_order_item_status = 67
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
        LEFT JOIN
    screport.seller sel ON sup.id_supplier = sel.src_id
WHERE
    so.created_at >= '2016-09-01'
        AND so.created_at < '2016-09-21'
        AND sel.tax_class = 'international'