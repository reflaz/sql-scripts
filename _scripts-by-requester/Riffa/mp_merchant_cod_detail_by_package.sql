/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss AnonDB Population Extract

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- DO NOT CHANGE THIS EVER!
SET @volumetric_constant = 6000;
SET @jne_rounding = 0.3;

SELECT 
    *
FROM
    (SELECT 
        *,
            CASE
                WHEN last_shipment_provider LIKE '%JNE%' THEN IF(formula_weight < 1, 1, IF(MOD(formula_weight, 1) <= @jne_rounding, FLOOR(formula_weight), CEIL(formula_weight)))
                ELSE CEIL(formula_weight)
            END 'rounded_weight',
            0 AS 'bulky'
    FROM
        (SELECT 
        *,
            length * width * height / @volumetric_constant 'volumetric_weight',
            IF(weight > (length * width * height / @volumetric_constant), weight, (length * width * height / @volumetric_constant)) 'formula_weight'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item,
            soi.sc_sales_order_item,
            so.order_nr,
            so.payment_method,
            soi.sku,
            sup.id_supplier 'bob_id_supplier',
            sel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            sel.tax_class,
            ss.enable_cod,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.marketplace_commission_fee,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            soi.value 'sc_shipping_fee',
            so.coupon_code,
            sovt.name 'coupon_type',
            soi.cart_rule_display_names,
            sois.name 'last_status',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'first_shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 44, soish.created_at, NULL)) 'not_delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 6, soish.created_at, NULL)) 'closed_date',
            MIN(IF(soish.fk_sales_order_item_status = 56, soish.created_at, NULL)) 'refund_completed_date',
            ppt.name 'pickup_provider_type',
            soi.id_package_dispatching,
            soi.package_number,
            soi.first_tracking_number,
            soi.first_shipment_provider,
            soi.last_tracking_number,
            soi.last_shipment_provider,
            sfom.origin 'origin',
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
            scsoi.id_sales_order_item 'sc_sales_order_item',
            SUM(tr.value) 'value'
    FROM
        (SELECT 
        pck.id_package,
            pck.package_number,
            pd.id_package_dispatching,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider'
    FROM
        oms_live.oms_package pck
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pd.id_package_dispatching = pdh.fk_package_dispatching
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history hst
        LEFT JOIN oms_live.oms_shipment_provider sp ON hst.fk_shipment_provider = sp.id_shipment_provider
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    WHERE
        pck.package_number IN ()
    HAVING first_shipment_provider IS NOT NULL
        AND last_shipment_provider IS NOT NULL) result
    LEFT JOIN oms_live.oms_package_item pi ON result.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
        AND tr.fk_transaction_type = 7
    GROUP BY soi.id_sales_order_item) soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27, 44, 6, 56)
    LEFT JOIN oms_live.ims_supplier osup ON soi.bob_id_supplier = osup.bob_id_supplier
    LEFT JOIN oms_live.oms_pickup_provider_type ppt ON osup.fk_pickup_provider_type = ppt.id_pickup_provider_type
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.catalog_simple_package_unit cspu ON cspu.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.supplier_shop ss ON sup.id_supplier = ss.fk_supplier
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
    GROUP BY soi.id_sales_order_item) result) result) result