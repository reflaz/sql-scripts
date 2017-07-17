SELECT 
    oms_so.order_nr 'Order Number',
    oms_pd.tracking_number 'Tracking Number',
    oms_soi.bob_id_sales_order_item 'Sales Order Item',
    IFNULL(SUM(oms_soi.paid_price), 0) 'Paid Price',
    IFNULL(SUM(oms_soi.shipping_surcharge), 0) 'Item Shipping Surcharge',
    SUM(IFNULL(oms_soi.paid_price, 0) + IFNULL(oms_soi.shipping_surcharge, 0)) 'Total',
    IFNULL(oms_so.created_at, '') 'Created Date',
    IFNULL(oms_ship.created_at, '') 'Shipped Date',
    IFNULL(oms_delv.real_action_date, '') 'Delivered Date',
    IFNULL(oms_delv.created_at, '') 'Delivered Status Updated Date',
    IFNULL(oms_user.username, '') 'Delivered Creator',
    oms_sois.name 'Item Status',
    oms_so.times_shipped 'Times Shipped',
    oms_sp.shipment_provider_name 'Current Delivery Company',
    IF(oms_so.times_shipped > 1,
        oms_sp1.shipment_provider_name,
        '') 'Delivery Company 1st',
    IF(oms_so.times_shipped > 1,
        oms_pd1.tracking_number,
        '') 'Tracking Number 1st',
    IF(oms_so.times_shipped > 1,
        oms_sp2.shipment_provider_name,
        '') 'Delivery Company 2nd',
    IF(oms_so.times_shipped > 1,
        oms_pd2.tracking_number,
        '') 'Tracking Number 2nd',
    IF(oms_so.times_shipped > 1,
        oms_sp3.shipment_provider_name,
        '') 'Delivery Company 3rd',
    IF(oms_so.times_shipped > 1,
        oms_pd3.tracking_number,
        '') 'Tracking Number 3rd',
    bob_sup.type 'Supplier Type',
    bob_sup.name 'Supplier Name',
    oms_soi.name 'Description'
FROM
    (SELECT 
        so.*,
            pck.id_package,
            (LENGTH(GROUP_CONCAT(ps.name)) - LENGTH(REPLACE(GROUP_CONCAT(ps.name), 'packed,shipped', ''))) / LENGTH('packed,shipped') AS 'times_shipped'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.oms_package pck ON so.id_sales_order = pck.fk_sales_order
    LEFT JOIN oms_live.oms_package_status_history psh ON pck.id_package = psh.fk_package
    LEFT JOIN oms_live.oms_package_status ps ON psh.fk_package_status = ps.id_package_status
    WHERE
        so.created_at >= CONCAT(YEAR(NOW()), '-01-01')
            AND so.created_at < '2015-11-01'
            AND so.payment_method = 'CashOnDelivery'
            AND psh.fk_package_status IN ('2' , '4')
    GROUP BY pck.package_number
    ORDER BY psh.id_package_status_history) oms_so
        LEFT JOIN
    oms_live.ims_sales_order_address oms_adbil ON oms_so.fk_sales_order_address_billing = oms_adbil.id_sales_order_address
        LEFT JOIN
    oms_live.ims_sales_order_address oms_adshp ON oms_so.fk_sales_order_address_shipping = oms_adshp.id_sales_order_address
        LEFT JOIN
    oms_live.oms_package_item oms_pi ON oms_so.id_package = oms_pi.fk_package
        LEFT JOIN
    oms_live.ims_sales_order_item oms_soi ON oms_pi.fk_sales_order_item = oms_soi.id_sales_order_item
        AND fk_sales_order_item_status IN ('5' , '8',
        '11',
        '27',
        '38',
        '42',
        '55',
        '56',
        '57',
        '68',
        '78')
        LEFT JOIN
    oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.oms_package_status_history oms_ship ON oms_so.id_package = oms_ship.fk_package
        AND oms_ship.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = oms_so.id_package
                AND fk_package_status = 4)
        LEFT JOIN
    oms_live.oms_package_status_history oms_delv ON oms_so.id_package = oms_delv.fk_package
        AND oms_delv.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = oms_so.id_package
                AND fk_package_status = 6)
        LEFT JOIN
    oms_live.oms_package_dispatching oms_pd ON oms_so.id_package = oms_pd.fk_package
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd1 ON oms_so.id_package = oms_pd1.fk_package
        AND oms_pd1.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_so.id_package
                AND tracking_number IS NOT NULL
        GROUP BY tracking_number
        ORDER BY id_package_dispatching_history
        LIMIT 0 , 1)
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd2 ON oms_so.id_package = oms_pd2.fk_package
        AND oms_pd2.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_so.id_package
                AND tracking_number IS NOT NULL
        GROUP BY tracking_number
        ORDER BY id_package_dispatching_history
        LIMIT 1 , 1)
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd3 ON oms_so.id_package = oms_pd3.fk_package
        AND oms_pd3.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_so.id_package
                AND tracking_number IS NOT NULL
        GROUP BY tracking_number
        ORDER BY id_package_dispatching_history
        LIMIT 2 , 1)
        LEFT JOIN
    oms_live.ims_user oms_user ON oms_delv.fk_ims_user = oms_user.id_user
        LEFT JOIN
    oms_live.oms_shipment_provider oms_sp ON oms_pd.fk_shipment_provider = oms_sp.id_shipment_provider
        LEFT JOIN
    oms_live.oms_shipment_provider oms_sp1 ON oms_pd1.fk_shipment_provider = oms_sp1.id_shipment_provider
        LEFT JOIN
    oms_live.oms_shipment_provider oms_sp2 ON oms_pd2.fk_shipment_provider = oms_sp2.id_shipment_provider
        LEFT JOIN
    oms_live.oms_shipment_provider oms_sp3 ON oms_pd3.fk_shipment_provider = oms_sp3.id_shipment_provider
        LEFT JOIN
    bob_live.supplier bob_sup ON oms_soi.bob_id_supplier = bob_sup.id_supplier
WHERE
    bob_sup.type = 'merchant'
GROUP BY oms_so.id_package;