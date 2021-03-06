-- order created nov 2013
-- soi MP
-- delivered in 2014
-- voucher type = coupon
-- cart rule value

SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item 'sales_order_item',
    so.created_at 'order_date',
    sup.type,
    MIN(soish.created_at) 'delivered_date',
    bso.customer_first_name,
    soa.address1,
    soa.city,
    so.coupon_code,
    socr.cart_rule_name,
    soi.coupon_money_value,
    soi.cart_rule_discount
FROM
    oms_live.ims_sales_order so
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
        LEFT JOIN
    oms_live.ims_sales_order_cart_rule socr ON so.id_sales_order = socr.fk_sales_order
        LEFT JOIN
    bob_live.sales_order bso ON so.order_nr = bso.order_nr
        LEFT JOIN
    bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
WHERE
    so.created_at >= '2014-09-01'
        AND so.created_at < '2015-01-01'
        AND soi.fk_sales_order_item_status = 27
        AND sup.type = 'merchant'
GROUP BY soi.id_sales_order_item
HAVING (coupon_money_value > 0
    OR cart_rule_discount > 0)
    AND delivered_date >= '2014-01-01'
    AND delivered_date < '2015-01-01'