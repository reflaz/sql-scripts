-- sup.id_supplier = 15041

SELECT 
    *
FROM
    (SELECT 
        result1.*,
            IF(weight > dim_weight, weight, dim_weight) 'chargeable_weight',
            IF(weight_1 > dim_weight_1, weight_1, dim_weight_1) 'chargeable_weight_1',
            GROUP_CONCAT(cty.id_city
                SEPARATOR ', ') 'restricted_to_id',
            GROUP_CONCAT(cty.city
                SEPARATOR ', ') 'restricted_to_city'
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
            END, 0) 'weight',
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'dim_weight',
            IFNULL(CASE
                WHEN
                    simple_weight_1 > 0
                        OR (simple_length_1 * simple_width_1 * simple_height_1) > 0
                THEN
                    simple_weight_1
                ELSE config_weight
            END, 0) 'weight_1',
            IFNULL(CASE
                WHEN
                    simple_weight_1 > 0
                        OR (simple_length_1 * simple_width_1 * simple_height_1) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'dim_weight_1'
    FROM
        (SELECT 
        sup.id_supplier,
            sup.name 'supplier_name',
            sup.status 'supplier_status',
            cs.status_source,
            cc.display_if_out_of_stock,
            csi.sku 'sku_source',
            cc.sku 'sku_config',
            cc.name 'item_name',
            csi.status 'status_simple',
            IF(csi.status = 'active', cspu.length, NULL) 'simple_length',
            IF(csi.status = 'active', cspu.width, NULL) 'simple_width',
            IF(csi.status = 'active', cspu.height, NULL) 'simple_height',
            IF(csi.status = 'active', cspu.weight, NULL) 'simple_weight',
            cspu.length 'simple_length_1',
            cspu.width 'simple_width_1',
            cspu.height 'simple_height_1',
            cspu.weight 'simple_weight_1',
            cc.status 'status_config',
            cc.package_length 'config_length',
            cc.package_width 'config_width',
            cc.package_height 'config_height',
            cc.package_weight 'config_weight'
    FROM
        bob_live.supplier sup
    LEFT JOIN bob_live.catalog_source cs ON sup.id_supplier = cs.fk_supplier
    LEFT JOIN bob_live.catalog_simple csi ON cs.fk_catalog_simple = csi.id_catalog_simple
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON csi.id_catalog_simple = cspu.fk_catalog_simple
    LEFT JOIN bob_live.catalog_config cc ON csi.fk_catalog_config = cc.id_catalog_config
    WHERE
        sup.type = 'supplier'
    GROUP BY csi.sku) result) result1
    LEFT JOIN bob_live.shipping_import_sku_blacklist bl ON bl.sku_config = result1.sku_config
    LEFT JOIN (SELECT 
        reg.id_customer_address_region 'id_region',
            reg.name 'region',
            cty.id_customer_address_region 'id_city',
            cty.name 'city'
    FROM
        bob_live.customer_address_region reg
    LEFT JOIN bob_live.customer_address_region cty ON reg.id_customer_address_region = cty.fk_customer_address_region
    WHERE
        reg.fk_customer_address_region IS NULL
            AND cty.id_customer_address_region IS NOT NULL
    GROUP BY cty.id_customer_address_region) cty ON NOT FIND_IN_SET(cty.id_city, bl.location_id)
    GROUP BY result1.sku_source
    HAVING chargeable_weight <= 0.17
        OR chargeable_weight_1 <= 0.17) result2