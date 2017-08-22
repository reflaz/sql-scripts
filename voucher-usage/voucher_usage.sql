SELECT 
    so.order_nr,
    soi.unit_price,
    soi.paid_price,
    soi.shipping_surcharge,
    soi.shipping_amount,
    soi.coupon_money_value,
    so.coupon_code,
    socr.cart_rule_name,
    socr.cart_rule_discount
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_cart_rule socr ON so.id_sales_order = socr.fk_sales_order
WHERE
    so.coupon_code IN ('KBOXING10');