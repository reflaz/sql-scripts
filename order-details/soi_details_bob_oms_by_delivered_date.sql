SET @extractstart = '2017-04-01';
SET @extractend = '2017-11-20';

SELECT 
    so.order_nr,
    soi.bob_id_sales_order_item,
    so.payment_method,
    so.created_at 'order_date',
    psh.created_at 'delivered_date',
    usr.username 'delivery_updater',
    soi.unit_price,
    soi.paid_price,
    soi.shipping_amount,
    soi.shipping_surcharge,
    IFNULL(soi.paid_price, 0) + IFNULL(soi.shipping_amount, 0) + IFNULL(soi.shipping_surcharge, 0) 'paid_by_customer'
FROM
    (SELECT 
        fk_package, fk_ims_user, created_at
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
            AND fk_ims_user = 2157
    GROUP BY fk_package) psh
        LEFT JOIN
    oms_live.ims_user usr ON psh.fk_ims_user = usr.id_user
        LEFT JOIN
    oms_live.oms_package pck ON psh.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
GROUP BY soi.bob_id_sales_order_item