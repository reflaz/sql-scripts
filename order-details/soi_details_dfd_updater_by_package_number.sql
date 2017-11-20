SELECT 
    *
FROM
    (SELECT 
        package_number,
            order_nr,
            bob_id_sales_order_item,
            unit_price,
            paid_price,
            shipping_amount,
            shipping_surcharge,
            last_status,
            IFNULL(failed_delivery_date_1, failed_delivery_date_2) 'failed_delivery_date',
            IFNULL(delivered_date_1, delivered_date_2) 'delivered_date',
            updater
    FROM
        (SELECT 
        pck.package_number,
            so.order_nr,
            soi.bob_id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            sois.name 'last_status',
            MIN(IF(psh.fk_package_status = 5, psh.created_at, NULL)) 'failed_delivery_date_1',
            MIN(IF(psh.fk_package_status = 6, psh.created_at, NULL)) 'delivered_date_1',
            MIN(IF(soish.fk_sales_order_item_status = 44, psh.created_at, NULL)) 'failed_delivery_date_2',
            MIN(IF(soish.fk_sales_order_item_status = 27, psh.created_at, NULL)) 'delivered_date_2',
            IFNULL(usr_1.username, usr_2.username) 'updater'
    FROM
        oms_live.oms_package pck
    LEFT JOIN oms_live.oms_package_status_history psh ON pck.id_package = psh.fk_package
        AND psh.fk_package_status IN (5 , 6)
    LEFT JOIN oms_live.ims_user usr_1 ON psh.fk_ims_user = usr_1.id_user
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (27 , 44)
    LEFT JOIN oms_live.ims_user usr_2 ON soish.fk_user = usr_2.id_user
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    WHERE
        pck.package_number IN ('')
    GROUP BY soi.bob_id_sales_order_item) result) result