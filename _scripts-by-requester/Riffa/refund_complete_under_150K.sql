SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_surcharge,
    sois.name 'item_status'
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order = sois.id_sales_order_item_status
WHERE
    soi.created_at >= ''
        AND soi.created_at < ''
        AND soi.fk_sales_order_item_status IN (56)