SET @extractstart = '2015-07-01';
SET @extractend = now();
SET @sellertype = 'supplier'; -- supplier/merchant

SELECT 
    oms_so.order_nr 'Order Number',
    oms_pd.tracking_number 'Tracking Number',
    oms_so.bob_id_sales_order_item 'Sales Order Item',
    IFNULL(SUM(oms_so.paid_price), 0) 'Paid Price',
    IFNULL(SUM(oms_so.shipping_surcharge), 0) 'Item Shipping Surcharge',
    SUM(IFNULL(oms_so.paid_price, 0) + IFNULL(oms_so.shipping_surcharge, 0)) 'Total',
    IFNULL(oms_so.created_at, '') 'Created Date',
    IFNULL(oms_ship.created_at, '') 'Shipped Date',
    IFNULL(oms_delv.real_action_date, '') 'Real Delivered Date',
    IFNULL(oms_delv.created_at, '') 'Delivered Updated Date',
    IFNULL(oms_user.username, '') 'Delivered Creator',
    oms_sois.name 'Item Status',
    oms_so.times_shipped 'Times Shipped',
    oms_sp.shipment_provider_name 'Current Delivery Company',
    oms_so.packed_shipped,
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
    oms_so.item_name 'Description',
    oms_so.supplier_name 'Supplier Type',
    oms_so.supplier_type 'Supplier Name'
FROM
    (SELECT 
        so.order_nr,
            so.created_at,
            so.fk_sales_order_address_billing,
            so.fk_sales_order_address_shipping,
            soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            soi.fk_sales_order_item_status,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.bob_id_supplier,
            soish.created_at 'status_created',
            GROUP_CONCAT(pckshp.name) 'packed_shipped',
            (LENGTH(GROUP_CONCAT(pckshp.name)) - LENGTH(REPLACE(GROUP_CONCAT(pckshp.name), 'packed,shipped', ''))) / LENGTH('packed,shipped') AS 'times_shipped',
            soi.name 'item_name',
            bob_sup.type 'supplier_type',
            bob_sup.name 'supplier_name'
    FROM
        (SELECT 
        *
    FROM
        oms_live.ims_sales_order so
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND so.payment_method = 'CashOnDelivery') so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN ('50' , '5')
    LEFT JOIN oms_live.ims_sales_order_item_status pckshp ON soish.fk_sales_order_item_status = pckshp.id_sales_order_item_status
    LEFT JOIN bob_live.supplier bob_sup ON soi.bob_id_supplier = bob_sup.id_supplier
    WHERE
        bob_sup.type = @sellertype
    GROUP BY soi.id_sales_order_item) oms_so
        LEFT JOIN
    oms_live.ims_sales_order_item_status oms_sois ON oms_so.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_address oms_adbil ON oms_so.fk_sales_order_address_billing = oms_adbil.id_sales_order_address
        LEFT JOIN
    oms_live.ims_sales_order_address oms_adshp ON oms_so.fk_sales_order_address_shipping = oms_adshp.id_sales_order_address
        LEFT JOIN
    oms_live.oms_package_item oms_pi ON oms_so.id_sales_order_item = oms_pi.fk_sales_order_item
        LEFT JOIN
    oms_live.oms_package oms_pck ON oms_pi.fk_package = oms_pck.id_package
        LEFT JOIN
    oms_live.oms_package_status_history oms_ship ON oms_pck.id_package = oms_ship.fk_package
        AND oms_ship.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = oms_pck.id_package
                AND fk_package_status = 4)
        LEFT JOIN
    oms_live.oms_package_status_history oms_delv ON oms_pck.id_package = oms_delv.fk_package
        AND oms_delv.id_package_status_history = (SELECT 
            MAX(id_package_status_history)
        FROM
            oms_live.oms_package_status_history
        WHERE
            fk_package = oms_pck.id_package
                AND fk_package_status = 6)
        LEFT JOIN
    oms_live.oms_package_dispatching oms_pd ON oms_pck.id_package = oms_pd.fk_package
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd1 ON oms_pck.id_package = oms_pd1.fk_package
        AND oms_pd1.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_pck.id_package
                AND tracking_number IS NOT NULL
        GROUP BY tracking_number
        ORDER BY id_package_dispatching_history
        LIMIT 0 , 1)
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd2 ON oms_pck.id_package = oms_pd2.fk_package
        AND oms_pd2.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_pck.id_package
                AND tracking_number IS NOT NULL
        GROUP BY tracking_number
        ORDER BY id_package_dispatching_history
        LIMIT 1 , 1)
        LEFT JOIN
    oms_live.oms_package_dispatching_history oms_pd3 ON oms_pck.id_package = oms_pd3.fk_package
        AND oms_pd3.id_package_dispatching_history = (SELECT 
            id_package_dispatching_history
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = oms_pck.id_package
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
GROUP BY oms_so.id_sales_order_item;