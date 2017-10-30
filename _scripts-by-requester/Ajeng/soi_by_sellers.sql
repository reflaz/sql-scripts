SELECT 
    soi.bob_id_sales_order_item,
    so.created_at,
    so.order_nr,
    sel.short_code,
    sel.name
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    screport.seller sel ON soi.bob_id_supplier = sel.src_id
WHERE
    soi.created_at >= '2016-02-01'
        AND soi.created_at < '2016-08-01'
        AND soi.bob_id_supplier IN (11958 , 18268, 20015, 38992, 40449, 40559, 41988)