SELECT 
    fk_mwh_warehouse,
    id_city,
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    COUNT(DISTINCT order_nr) 'total_so',
    COUNT(id_sales_order_item) 'total_soi'
FROM
    (SELECT 
        so.order_nr,
            soi.id_sales_order_item,
            dst.fk_customer_address_region 'id_city',
            ship.shipped_date,
            IFNULL(soi.unit_price, 0) 'unit_price',
            IFNULL(soi.paid_price, 0) 'paid_price',
            IF(sel.tax_class = 1, 0, fk_mwh_warehouse) 'fk_mwh_warehouse'
    FROM
        (SELECT 
        fk_package, MAX(created_at) 'shipped_date'
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= '2016-10-11'
            AND created_at < '2016-12-08'
            AND fk_package_status = 4
    GROUP BY fk_package) ship
    LEFT JOIN oms_live.oms_package_item pi ON ship.fk_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN asc_live.seller sel ON soi.bob_id_supplier = sel.src_id
    WHERE
        soi.is_marketplace = 1) result
GROUP BY fk_mwh_warehouse , id_city