SELECT 
    origin,
    sku,
    unit_price,
    ROUND(IF(chargable_weight > chargable_volumetric_weight,
                chargable_weight,
                chargable_volumetric_weight),
            2) 'weight'
FROM
    (SELECT 
        *,
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0) 'chargable_weight',
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'chargable_volumetric_weight'
    FROM
        (SELECT 
        soi.sku,
            unit_price,
            CASE
                WHEN soi.fk_mwh_warehouse = 1 THEN 'DKI Jakarta'
                WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
            END 'origin',
            cc.package_length 'config_length',
            cc.package_width 'config_width',
            cc.package_height 'config_height',
            cc.package_weight 'config_weight',
            cspu.length 'simple_length',
            cspu.width 'simple_width',
            cspu.height 'simple_height',
            cspu.weight 'simple_weight'
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cs.id_catalog_simple = cspu.fk_catalog_simple
    LEFT JOIN screport.seller sel ON soi.bob_id_supplier = sel.src_id
    WHERE
        soi.created_at >= '2016-10-01'
            AND soi.created_at < '2016-12-01'
            AND soi.is_marketplace = 1
            AND soi.fk_mwh_warehouse = 3
            AND sel.tax_class = 'local'
    GROUP BY sku) result) result