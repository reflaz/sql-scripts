SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';

SELECT 
    coupon_code,
    coupon_type,
    cart_rule_display_names,
    SUM(paid_price) 'total_paid_price',
    SUM(coupon_money_value) 'total_coupon_money_value',
    SUM(cart_rule_discount) 'total_cart_rule_discount',
    SUM(qty) 'total_qty'
FROM
    (SELECT 
        so.coupon_code,
            sovt.name 'coupon_type',
            soi.bob_id_sales_order_item,
            soi.cart_rule_display_names,
            soi.paid_price,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            1 'qty',
            soish.created_at
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    GROUP BY soi.bob_id_sales_order_item
    HAVING soish.created_at >= @extractstart
        AND soish.created_at < @extractend
        AND (coupon_code IS NOT NULL
        OR cart_rule_display_names IS NOT NULL)
        AND (coupon_type IS NULL
        OR coupon_type = 'coupon')) result
GROUP BY coupon_code , cart_rule_display_names