SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            soi.id_sales_order_item 'sap_item_id',
            soi.sku,
            soi.is_marketplace,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soib.discount_amount 'bundling_discount',
            sovt.name 'voucher_type',
            so.created_at 'order_date',
            soish.created_at 'finance_verified_date',
            IFNULL((SELECT 
                    created_at
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 27), psh.created_at) 'delivered_date'
    FROM
        oms_live.ims_sales_order_item_bundle soib
    LEFT JOIN oms_live.ims_sales_order_item soi ON soib.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 67
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = id_package
    LEFT JOIN oms_live.oms_package_status_history psh ON pck.id_package = psh.fk_package
        AND psh.fk_package_status = 6) result