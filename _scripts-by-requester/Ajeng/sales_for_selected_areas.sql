/*AND soa.fk_customer_address_region IN ('17441')*/
            
SELECT 
    *, length * width * height / 6000 'volumetric_weight'
FROM
    (SELECT 
        result.order_nr,
            result.bob_id_sales_order_item,
            result.unit_price,
            result.paid_price,
            sois.name 'last_status',
            result.created_at,
            result.finance_verified 'finance_verified',
            result.shipped_date 'shipped_date',
            result.delivered_date 'delivered_date',
            pd.tracking_number,
            sp.shipment_provider_name,
            sfom.origin,
            IF(regn.id_customer_address_region IS NOT NULL, regn.id_customer_address_region, IF(city.id_customer_address_region IS NOT NULL, city.id_customer_address_region, dist.id_customer_address_region)) 'id_region',
            IF(regn.id_customer_address_region IS NOT NULL, regn.name, IF(city.id_customer_address_region IS NOT NULL, city.name, dist.name)) 'region',
            IF(regn.id_customer_address_region IS NOT NULL, city.id_customer_address_region, dist.id_customer_address_region) 'id_city',
            IF(regn.id_customer_address_region IS NOT NULL, city.name, dist.name) 'city',
            IF(regn.id_customer_address_region IS NOT NULL, dist.id_customer_address_region, NULL) 'id_district',
            IF(regn.id_customer_address_region IS NOT NULL, dist.name, NULL) 'district',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) 'length',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) 'width',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) 'height',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.weight, 0), IFNULL(cc.package_weight, 0)) 'weight'
    FROM
        (SELECT 
        so.order_nr,
            so.fk_sales_order_address_shipping,
            so.created_at,
            soi.id_sales_order_item,
            soi.bob_id_sales_order_item,
            soi.bob_id_supplier,
            soi.sku,
            soi.fk_sales_order_item_status,
            soi.unit_price,
            soi.paid_price,
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'finance_verified',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    WHERE
        so.created_at >= '2016-03-01'
            AND so.created_at < '2016-04-01'
            AND soi.shipping_surcharge = 0
    GROUP BY soi.id_sales_order_item) result
    LEFT JOIN oms_live.ims_sales_order_address soa ON soa.id_sales_order_address = result.fk_sales_order_address_shipping
    LEFT JOIN oms_live.ims_customer_address_region dist ON dist.id_customer_address_region = soa.fk_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region city ON dist.fk_customer_address_region = city.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region regn ON city.fk_customer_address_region = regn.id_customer_address_region
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON result.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_package_item pi ON result.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN bob_live.catalog_simple cs ON result.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON result.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.fk_country_region IS NOT NULL
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
    GROUP BY result.id_sales_order_item) result