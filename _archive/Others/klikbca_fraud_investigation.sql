SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.payment_method,
    kbr.userid 'klikbca_userid',
    soi.unit_price,
    soi.paid_price,
    soi.shipping_amount,
    soi.shipping_surcharge,
    soi.coupon_money_value,
    so.coupon_code,
    soi.cart_rule_display_names
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    bob_live.payment_klikbca_response kbr ON so.order_nr = kbr.transno
WHERE
    so.order_nr IN ('');