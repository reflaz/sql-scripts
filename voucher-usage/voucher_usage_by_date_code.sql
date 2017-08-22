SET @extractstart = '2017-01-01';
SET @extractend = '2017-08-01';

SELECT 
    soi.bob_id_supplier,
    sup.name 'supplier_name',
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at,
    soish.created_at 'delivered_date',
    sois.name 'last_status',
    soi.coupon_money_value,
    so.coupon_code
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
WHERE
    so.created_at >= @extractstart
        AND so.created_at < @extractend
        AND so.coupon_code IN ();