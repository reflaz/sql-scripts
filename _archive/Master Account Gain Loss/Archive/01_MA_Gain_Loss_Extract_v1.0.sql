/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account v1.0
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 
Instructions	: Run the query on any date. The result should be shipped items data for last month. After the
				  result extracted, please check if the period is correct!
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'	

SET @extractend = '2016-05-16';-- DATE(DATE_ADD(NOW(), INTERVAL 2 - IF(DAYOFWEEK(NOW()) = 1, 8, DAYOFWEEK(NOW())) DAY)); -- this must be the day after (h+1)
SET @extractstart = '2016-05-01';-- DATE_ADD(@extractend,INTERVAL -7 DAY);

SELECT 
    *, length * width * height / 6000 'volumetric_weight'
FROM
    (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            scsoi.id_sales_order_item 'sc_id_sales_order_item',
            so.order_nr 'order_nr',
            so.created_at 'order_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            soi.shipping_surcharge 'shipping_surcharge',
            soi.sku 'sku',
            pd.id_package_dispatching 'id_package_dispatching',
            pd.tracking_number 'tracking_number',
            sp.shipment_provider_name 'shipment_provider',
            IFNULL(sfom.origin, IF(sel.tax_class = 'international', 'DKI Jakarta', NULL)) 'origin',
            IF(reg.id_customer_address_region IS NOT NULL, reg.id_customer_address_region, IF(cty.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region)) 'id_region',
            IF(reg.id_customer_address_region IS NOT NULL, reg.name, IF(cty.id_customer_address_region IS NOT NULL, cty.name, dst.name)) 'region',
            IF(reg.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region) 'id_city',
            IF(reg.id_customer_address_region IS NOT NULL, cty.name, dst.name) 'city',
            IF(reg.id_customer_address_region IS NOT NULL, dst.id_customer_address_region, NULL) 'id_district',
            IF(reg.id_customer_address_region IS NOT NULL, dst.name, NULL) 'district',
            sup.id_supplier 'seller_id',
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            sup.type 'seller_type',
            IFNULL(sel.tax_class, sup.tax_class) 'tax_class',
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
        *
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 4
    GROUP BY fk_package) ps
    LEFT JOIN oms_live.oms_package pck ON ps.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.fk_country_region IS NOT NULL
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    GROUP BY soi.id_sales_order_item) result
WHERE
    shipped_date >= @extractstart
        AND shipped_date < @extractend
        AND shipment_provider IN ('LEX FBL' , 'LEX MP',
        'ESL MP',
        'JNE FBL',
        'JNE MP',
        'JNE MP SUB',
        'NCS MP',
        'REPEX MP')