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
SET @extractstart = '2016-06-01';
SET @extractend = '2016-07-01';

SELECT 
    order_nr,
    bob_id_sales_order_item,
    sc_sales_order_item,
    sku,
    qty,
    id_supplier,
    short_code,
    seller_name,
    seller_type,
    tax_class,
    total_unit_price,
    total_paid_price,
    total_shipping_surcharge,
    last_status,
    order_date,
    first_shipped_date,
    last_shipped_date,
    delivered_date,
    first_tracking_number,
    first_shipment_provider,
    last_tracking_number,
    last_shipment_provider,
    origin,
    id_region,
    region,
    id_city,
    city,
    id_district,
    district,
    total_weight,
    total_volumetric_weight,
    formula_weight,
    rounded_weight,
    rate,
    charge_to_seller,
    sc_shipping_fee
FROM
    (SELECT 
        *,
            COUNT(order_nr) 'qty',
            SUM(unit_price) 'total_unit_price',
            SUM(paid_price) 'total_paid_price',
            SUM(shipping_surcharge) 'total_shipping_surcharge',
            SUM(weight) 'total_weight',
            SUM(volumetric_weight) 'total_volumetric_weight',
            SUM(value) 'sc_shipping_fee',
            IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) 'formula_weight',
            CASE
                WHEN first_shipment_provider LIKE '%LEX%' THEN CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)))
                ELSE IF(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) < 1, 1, IF(MOD(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)), 1) <= 0.3, FLOOR(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))), CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)))))
            END 'rounded_weight',
            CASE
                WHEN first_shipment_provider LIKE '%LEX%' THEN 6464
                ELSE 7000
            END 'rate',
            CASE
                WHEN first_shipment_provider LIKE '%LEX%' THEN CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))) * 6464
                ELSE IF(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)) < 1, 1, IF(MOD(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight)), 1) <= 0.3, FLOOR(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))), CEIL(IF(SUM(weight) > SUM(volumetric_weight), SUM(weight), SUM(volumetric_weight))))) * 7000
            END 'charge_to_seller'
    FROM
        (SELECT 
        *, length * width * height / 6000 'volumetric_weight'
    FROM
        (SELECT 
        result.*,
            so.order_nr,
            so.created_at 'order_date',
            soi.bob_id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_surcharge,
            soi.sku 'sku',
            sois.name 'last_status',
            soish2.created_at 'first_shipped_date',
            soish3.created_at 'last_shipped_date',
            soish1.created_at 'delivered_date',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.length, 0), IFNULL(cc.package_length, 0)) 'length',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.width, 0), IFNULL(cc.package_width, 0)) 'width',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.height, 0), IFNULL(cc.package_height, 0)) 'height',
            IF(cspu.length * cspu.width * cspu.height IS NOT NULL
                OR cspu.weight IS NOT NULL, IFNULL(cspu.weight, 0), IFNULL(cc.package_weight, 0)) 'weight',
            sup.id_supplier,
            sup.name 'seller_name',
            sup.type 'seller_type',
            sfom.origin,
            IF(reg.id_customer_address_region IS NOT NULL, reg.id_customer_address_region, IF(cty.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region)) 'id_region',
            IF(reg.id_customer_address_region IS NOT NULL, reg.name, IF(cty.id_customer_address_region IS NOT NULL, cty.name, dst.name)) 'region',
            IF(reg.id_customer_address_region IS NOT NULL, cty.id_customer_address_region, dst.id_customer_address_region) 'id_city',
            IF(reg.id_customer_address_region IS NOT NULL, cty.name, dst.name) 'city',
            IF(reg.id_customer_address_region IS NOT NULL, dst.id_customer_address_region, NULL) 'id_district',
            IF(reg.id_customer_address_region IS NOT NULL, dst.name, NULL) 'district',
            scsoi.id_sales_order_item 'sc_sales_order_item',
            sel.short_code,
            sel.tax_class,
            SUM(IFNULL(tr.value, 0)) 'value'
    FROM
        (SELECT 
        pck.id_package,
            pd.id_package_dispatching,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider'
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 4
    GROUP BY fk_package) result
    LEFT JOIN oms_live.oms_package pck ON result.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pd.id_package_dispatching = pdh.fk_package_dispatching
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history hst
        LEFT JOIN oms_live.oms_shipment_provider sp ON hst.fk_shipment_provider = sp.id_shipment_provider
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL
                AND (sp.shipment_provider_name LIKE '%MP%'
                OR sp.shipment_provider_name LIKE '%FBL%'
                OR sp.shipment_provider_name = 'LEX X'
                OR sp.shipment_provider_name LIKE '%NCS%'))
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
        AND sp2.id_shipment_provider IN (SELECT 
            id_shipment_provider
        FROM
            oms_live.oms_shipment_provider
        WHERE
            shipment_provider_name LIKE '%MP%'
                OR shipment_provider_name LIKE '%FBL%'
                OR shipment_provider_name = 'LEX X'
                OR shipment_provider_name LIKE '%NCS%')
    HAVING first_shipment_provider IS NOT NULL
        AND last_shipment_provider IS NOT NULL) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish1 ON soi.id_sales_order_item = soish1.fk_sales_order_item
        AND soish1.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish2 ON soi.id_sales_order_item = soish2.fk_sales_order_item
        AND soish2.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish3 ON soi.id_sales_order_item = soish3.fk_sales_order_item
        AND soish3.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
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
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type = 7
    LEFT JOIN screport.seller sel ON scsoi.fk_seller = sel.id_seller
    WHERE
        soish3.created_at >= @extractstart
            AND soish3.created_at < @extractend
    GROUP BY soi.bob_id_sales_order_item) result
    HAVING weight <= 7 AND volumetric_weight <= 7
        AND seller_type = 'merchant') result
    GROUP BY id_package_dispatching , id_supplier) result