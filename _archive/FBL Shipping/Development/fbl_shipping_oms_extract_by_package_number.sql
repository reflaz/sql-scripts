SELECT 
    *, formula_weight / total_formula_weight 'shipping_fee_rate'
FROM
    (SELECT 
        so.order_nr 'order_nr',
            ssoi.id_sales_order_item 'sc_sales_order_item',
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            sup.type 'seller_type',
            IF(result.type_concat LIKE '%merchant,supplier%'
                OR result.type_concat LIKE '%supplier,merchant%', 'supplier,merchant', IF(result.type_concat LIKE '%merchant%', 'merchant', 'supplier')) 'type_concats',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            result.shipment_provider_name 'shipment_provider',
            result.tracking_number 'tracking_number',
            result.package_number 'package_number',
            soa.city 'destination_city',
            soi.shipping_surcharge '',
            CONCAT(cc.package_width, ' x ', cc.package_length, ' x ', cc.package_height) 'package_dimension',
            ROUND((cc.package_width * cc.package_length * cc.package_height) / 6000, 2) 'volumetric_weight',
            cc.package_weight 'package_weight',
            IF(ROUND((cc.package_width * cc.package_length * cc.package_height) / 6000, 2) > cc.package_weight, ROUND((cc.package_width * cc.package_length * cc.package_height) / 6000, 2), cc.package_weight) 'formula_weight',
            result.total_formula_weight
    FROM
        (SELECT 
        pck.id_package,
            pck.package_number,
            pd.id_package_dispatching,
            SUM(soi.shipping_surcharge) 'total_shipping_surcharge',
            SUM(IF(ROUND((cc.package_width * cc.package_length * cc.package_height) / 6000, 2) > cc.package_weight, ROUND((cc.package_width * cc.package_length * cc.package_height) / 6000, 2), cc.package_weight)) 'total_formula_weight',
            pd.tracking_number,
            sp.shipment_provider_name,
            GROUP_CONCAT(sup.type) 'type_concat'
    FROM
        oms_live.oms_package pck
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    WHERE
        pck.package_number IN ('')
    GROUP BY pd.tracking_number) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.sales_order_item ssoi ON soi.id_sales_order_item = ssoi.src_id
    LEFT JOIN screport.seller sel ON ssoi.fk_seller = sel.id_seller
    GROUP BY soi.id_sales_order_item) result