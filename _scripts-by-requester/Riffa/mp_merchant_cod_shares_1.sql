SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';

SELECT 
    result.name 'Seller Name',
    result.short_code 'SC Seller ID',
    result.tax_class 'Tax Class',
    result.total_paid_price 'Total Paid Price',
    IF(MAX(fk_catalog_attribute_option_vouchers_is_digital) IS NOT NULL,
        1,
        0) 'Have Digital Goods',
    result.city 'Seller\'s City',
    result.enable_cod 'COD Flag'
FROM
    (SELECT 
        sup.id_supplier,
            sup.name,
            sel.short_code,
            sel.tax_class,
            SUM(soi.paid_price) 'total_paid_price',
            sa.city,
            ss.enable_cod
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        fk_package_status = 6
            AND created_at >= @extractstart
            AND created_at < @extractend) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_shop ss ON sup.id_supplier = ss.fk_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND city IS NOT NULL
                AND TRIM(city) <> '')
    JOIN screport.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        sup.type = 'merchant'
    GROUP BY sup.id_supplier) result
        LEFT JOIN
    bob_live.catalog_config cc ON result.id_supplier = cc.product_owner
        AND cc.status = 'active'
        LEFT JOIN
    bob_live.catalog_config_vouchers ccv ON cc.id_catalog_config = ccv.fk_catalog_config
GROUP BY result.id_supplier