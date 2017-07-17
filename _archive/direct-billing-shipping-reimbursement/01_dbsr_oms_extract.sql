/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Reimbursement Extract v3.0
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 3.0
Changes made	: - 3.0 Add shipping amount, seller's city, change logic for shipment providers
				  - 2.0 Automate date based on extract date

Instructions	: Run the query on any date. The result should be shipping data for last week shipment reimbursement. After the
				  result extracted, please check if the period is correct!
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'

SET @extractend = DATE(DATE_ADD(NOW(), INTERVAL 2 - IF(DAYOFWEEK(NOW()) = 1, 8, DAYOFWEEK(NOW())) DAY)); -- this must be the day after (h+1)
SET @extractstart = DATE_ADD(@extractend,INTERVAL -7 DAY);

SELECT 
    *
FROM
    (SELECT 
        *,
            CASE
                WHEN last_shipment_provider LIKE '%JNE%' THEN IF(item_formula_weight < 1, 1, IF(MOD(item_formula_weight, 1) <= 0.3, FLOOR(item_formula_weight), CEIL(item_formula_weight)))
                ELSE CEIL(item_formula_weight)
            END 'item_rounded_weight'
    FROM
        (SELECT 
        *,
            length * width * height / 6000 'volumetric_weight',
            IF(weight > (length * width * height / 6000), weight, (length * width * height / 6000)) 'item_formula_weight'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item,
            soi.sc_sales_order_item,
            so.order_nr,
            so.payment_method,
            soi.sku,
            sup.id_supplier,
            sel.short_code 'sc_seller_id',
            sup.name 'seller_name',
            sup.type 'seller_type',
            sel.tax_class,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            sois.name 'last_status',
            so.created_at 'order_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            soi.package_number,
            soi.last_tracking_number,
            soi.last_shipment_provider,
            sfom.origin 'origin',
            sa.city 'origin_city',
            soa.city,
            dst.id_customer_address_region 'id_district',
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
        result.*,
            soi.*,
            scsoi.id_sales_order_item 'sc_sales_order_item'
    FROM
        (SELECT 
        pck.id_package,
            pck.package_number,
            pd.id_package_dispatching,
            pd.tracking_number 'last_tracking_number',
            sp.shipment_provider_name 'last_shipment_provider'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) result
    LEFT JOIN oms_live.oms_package pck ON result.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
        AND sp.id_shipment_provider IN (SELECT 
            id_shipment_provider
        FROM
            oms_live.oms_shipment_provider
        WHERE
            shipment_provider_name NOT LIKE '%LEX%'
                AND shipment_provider_name NOT LIKE '%MP%'
                AND shipment_provider_name NOT LIKE '%FBL%'
                AND shipment_provider_name NOT LIKE '%NINJA VAN%')
    HAVING last_shipment_provider IS NOT NULL) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    GROUP BY soi.id_sales_order_item) soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL)
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region)
    LEFT JOIN screport.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        sel.tax_class = 'local'
    GROUP BY soi.id_sales_order_item
    HAVING delivered_date >= @extractstart
        AND delivered_date < @extractend) result) result) result