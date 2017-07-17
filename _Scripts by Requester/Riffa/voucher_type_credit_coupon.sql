SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    sois.name 'last_status',
    srs.type 'sales_rule_type'
FROM
    oms_live.ims_sales_order so
        JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        AND soi.fk_sales_order_item_status = 56
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
        LEFT JOIN
    bob_live.sales_order bso ON so.order_nr = bso.order_nr
        LEFT JOIN
    bob_live.sales_rule sr ON bso.coupon_code = sr.code
        LEFT JOIN
    bob_live.sales_rule_set srs ON sr.fk_sales_rule_set = srs.id_sales_rule_set
WHERE
    so.created_at >= '2016-04-01'
        AND so.coupon_code IS NOT NULL
        AND srs.type = 'coupon'