SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.created_at,
    soish.created_at 'delivered_date',
    soi.cart_rule_display_names,
    soi.cart_rule_discount
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
WHERE
    cart_rule_display_names LIKE '%voucherfreeship%'