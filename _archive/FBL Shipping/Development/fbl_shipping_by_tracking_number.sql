/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
FBL Shipping OMS Extract by Tracking Number
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Insert formatted Tracking Number in >> WHERE tracking_number IN () << part of the script
				  - You can format the ID in excel using this formula: ="'"&Column&"'," --> change Column accordingly
                  - Delete the last comma (,)
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *, formula_weight / total_formula_weight 'shipping_fee_rate'
FROM
    (SELECT 
        so.order_nr 'order_nr',
            soi.bob_id_sales_order_item 'sales_order_item',
            ssoi.id_sales_order_item 'sc_sales_order_item',
            soi.sku,
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            sel.tax_class 'tax_class',
            sup.type 'seller_type',
            IF(result.type_concat LIKE '%merchant,supplier%'
                OR result.type_concat LIKE '%supplier,merchant%', 'supplier,merchant', IF(result.type_concat LIKE '%merchant%', 'merchant', 'supplier')) 'package_seller_type',
            so.created_at 'order_date',
            sois.name 'item_status',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            result.shipment_provider_name 'shipment_provider',
            result.tracking_number 'tracking_number',
            result.package_number 'package_number',
            sa.city 'origin_city',
            soa.city 'destination_city',
            soi.shipping_surcharge 'shipping_surcharge',
            CONCAT(IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)), ' x ', IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)), ' x ', IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0))) 'package_dimension',
            ROUND(IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) / 6000, 2) 'volumetric_weight',
            cc.package_weight 'package_weight',
            ROUND(IF(result.total_weight > result.total_volumetric_weight, cc.package_weight, IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) / 6000), 2) 'formula_weight',
            ROUND(IF(result.total_weight > result.total_volumetric_weight, result.total_weight, result.total_volumetric_weight), 2) 'total_formula_weight'
    FROM
        (SELECT 
        pck.id_package,
            pd.id_package_dispatching_history,
            SUM(soi.shipping_surcharge) 'total_shipping_surcharge',
            SUM(ROUND(cc.package_weight, 2)) 'total_weight',
            SUM(ROUND(IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) * IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) / 6000, 2)) 'total_volumetric_weight',
            pd.tracking_number,
            pck.package_number,
            sp.shipment_provider_name,
            GROUP_CONCAT(sup.type) 'type_concat'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_dispatching_history
    WHERE
        tracking_number IN ('')
    GROUP BY tracking_number) pd
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package pck ON pd.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    GROUP BY pd.tracking_number) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.fk_country_region IS NOT NULL
        AND sa.address_type = 'standard'
    LEFT JOIN screport.sales_order_item ssoi ON soi.id_sales_order_item = ssoi.src_id
    LEFT JOIN screport.seller sel ON ssoi.fk_seller = sel.id_seller
    GROUP BY soi.id_sales_order_item) result