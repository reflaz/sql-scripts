SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            so.created_at 'order_date',
            sois.name 'last_status',
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 69 THEN soish.created_at
                ELSE NULL
            END) AS order_verification,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 67 THEN soish.created_at
                ELSE NULL
            END) AS finance_verified,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 5 THEN soish.created_at
                ELSE NULL
            END) AS shipped,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 9 THEN soish.created_at
                ELSE NULL
            END) AS cancelled,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status IN (8 , 11) THEN soish.created_at
                ELSE NULL
            END) AS returned,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status IN (56 , 78) THEN soish.created_at
                ELSE NULL
            END) AS refunded_replaced,
            MIN(CASE
                WHEN soish.fk_sales_order_item_status = 27 THEN soish.created_at
                ELSE NULL
            END) AS delivered,
            pd.tracking_number,
            sp.shipment_provider_name,
            sup.name,
            sup.type AS supplier_type
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    WHERE
    soi.bob_id_sales_order_item = '28725655'
        -- so.created_at >= '2016-03-28'
           -- AND so.created_at < '2016-04-04'
            -- AND 
    GROUP BY soi.id_sales_order_item) result