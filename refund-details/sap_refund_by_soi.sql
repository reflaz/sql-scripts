USE oms_live;

SELECT 
    soi.created_at AS soi_created_at,
    payment_method,
    soi.is_marketplace,
    'refund completed' AS history_status,
    soish.created_at,
    real_delivery_date,
    order_nr,
    soi.bob_id_sales_order_item,
    soi.id_sales_order_item,
    ROUND(IFNULL(soi.paid_price, 0), 0) AS paid_price,
    ROUND(IFNULL(soi.tax_amount, 0), 0) AS tax_amount,
    soi.tax_percent,
    ROUND(IFNULL(soi.shipping_amount, 0), 0) AS shipping_amount,
    ROUND(IFNULL(shipping_surcharge, 0), 0) AS shipping_surcharge,
    ROUND(IFNULL(soi.paid_price, 0), 0) + ROUND(IFNULL(soi.shipping_amount, 0), 0) + ROUND(IFNULL(shipping_surcharge, 0), 0) AS from_customer,
    CASE
        WHEN so.fk_voucher_type = 1 THEN ROUND(soi.coupon_money_value, 0)
        ELSE 0
    END AS store_credit,
    CASE
        WHEN so.fk_voucher_type = 3 THEN ROUND(soi.coupon_money_value, 0)
        ELSE 0
    END AS marketing_voucher,
    ROUND(IFNULL(cart_rule_discount, 0), 0) AS cart_rule_discount,
    ROUND(IFNULL(soi.paid_price, 0), 0) + ROUND(IFNULL(soi.shipping_amount, 0), 0) + ROUND(IFNULL(shipping_surcharge, 0), 0) + ROUND(IFNULL(soi.coupon_money_value, 0), 0) + ROUND(IFNULL(cart_rule_discount, 0), 0) AS total,
    ROUND(IFNULL(soi.refunded_other, 0), 0) AS refunded_other,
    ROUND(IFNULL(soi.refunded_shipping, 0), 0) AS refunded_shipping,
    ROUND(IFNULL(soi.refunded_wallet_credit, 0), 0) AS refunded_wallet_credit,
    sop.name AS refund_method,
    bob_id_customer,
    soi.sku,
    CASE
        WHEN
            icat.bob_regional_key = ''
                OR icat.bob_regional_key IS NULL
        THEN
            '99'
        ELSE icat.bob_regional_key
    END AS bob_regional_key,
    soi.fk_marketplace_merchant
FROM
    ims_sales_order_item soi
        JOIN
    ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        JOIN
    ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item)
        JOIN
    ims_sales_order_process sop ON soi.fk_refund_sales_order_process = sop.id_sales_order_process
        LEFT JOIN
    ims_product prod ON soi.sku = prod.sku
        LEFT JOIN
    ims_catalog_category icat ON prod.fk_catalog_category = icat.id_catalog_category
WHERE
    soi.bob_id_sales_order_item IN ('')