/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Shipping Charge Data Extract
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-05-01';
SET @extractend = '2016-05-08';

SELECT 
    order_nr,
    bob_id_sales_order_item,
    sc_id_sales_order_item,
    sku,
    seller_id,
    sc_seller_id,
    seller_name,
    seller_type,
    tax_class,
    total_unit_price,
    total_paid_price,
    total_shipping_surcharge,
    order_date,
    shipped_date,
    delivered_date,
    first_tracking_number,
    first_shipment_provider,
    last_tracking_number,
    last_shipment_provider,
    total_weight,
    total_volumetric_weight,
    formula_weight,
    rounded_weight,
    rate,
    charge_to_seller
FROM
    (SELECT 
        *,
            SUM(unit_price) 'total_unit_price',
            SUM(paid_price) 'total_paid_price',
            SUM(shipping_surcharge) 'total_shipping_surcharge',
            SUM(weight) 'total_weight',
            SUM(volumetric_weight) 'total_volumetric_weight',
            IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) 'formula_weight',
            CASE
                WHEN result.first_shipment_provider LIKE '%LEX%' THEN CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)))
                ELSE IF(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) < 1, 1, IF(MOD(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)), 1) <= 0.3, FLOOR(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))), CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)))))
            END 'rounded_weight',
            CASE
                WHEN result.first_shipment_provider LIKE '%LEX%' THEN 6464
                ELSE 7000
            END 'rate',
            CASE
                WHEN result.first_shipment_provider LIKE '%LEX%' THEN CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))) * 6464
                ELSE IF(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) < 1, 1, IF(MOD(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)), 1) <= 0.3, FLOOR(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))), CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))))) * 7000
            END 'charge_to_seller'
    FROM
        (SELECT 
        *, length * width * height / 6000 'volumetric_weight'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item 'bob_id_sales_order_item',
            scsoi.id_sales_order_item 'sc_id_sales_order_item',
            so.order_nr 'order_nr',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.sku 'sku',
            pdh.id_package_dispatching_history 'id_package_dispatching',
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            sfom.origin 'origin',
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
            sel.tax_class,
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
        fk_package
    FROM
        oms_live.oms_package_dispatching_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND tracking_number IS NOT NULL
    GROUP BY fk_package) _pdh
    JOIN oms_live.oms_package_dispatching_history pdh ON _pdh.fk_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = _pdh.fk_package
                AND tracking_number IS NOT NULL
                AND created_at >= @extractstart
                AND created_at < @extractend)
    LEFT JOIN oms_live.oms_package_dispatching pd ON pdh.fk_package_dispatching = pd.id_package_dispatching
    LEFT JOIN oms_live.oms_package pck ON pd.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
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
    WHERE
        sel.tax_class = 'local'
            AND sfom.origin IS NOT NULL
    GROUP BY soi.id_sales_order_item) result
    WHERE
        shipped_date >= @extractstart
            AND shipped_date < @extractend
            AND (first_shipment_provider LIKE '%MP%'
            OR first_shipment_provider LIKE '%FBL%')
    HAVING weight <= 7 AND volumetric_weight <= 7) result
    GROUP BY result.id_package_dispatching , result.seller_id) result