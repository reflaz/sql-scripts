/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Number
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-07-27';
SET @extractend = '2016-07-28'; -- This MUST be H + 1

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
            soi.sc_commission_fee,
            soi.coupon_money_value,
            soi.cart_rule_discount,
            so.coupon_code,
            sovt.name 'coupon_type',
            soi.cart_rule_display_names,
            sois.name 'last_status',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'finance_verified',
            MIN(IF(soish.fk_sales_order_item_status = 71, soish.created_at, NULL)) 'handled_by_mp',
            MAX(IF(soish.fk_sales_order_item_status IN (50 , 76), soish.created_at, NULL)) 'packed',
            pck.package_number,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            soi.sc_shipping_fee 'sc_shipping_fee',
            sfom.origin 'origin',
            soa.city 'destination_city',
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
        soi.*,
            scsoi.id_sales_order_item 'sc_sales_order_item',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'sc_payment_fee',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'sc_shipping_fee',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'sc_commission_fee'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN screport.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN screport.transaction tr ON scsoi.id_sales_order_item = tr.ref
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
    GROUP BY soi.id_sales_order_item) soi
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history hst
        LEFT JOIN oms_live.oms_shipment_provider sp ON hst.fk_shipment_provider = sp.id_shipment_provider
        WHERE
            fk_package = pck.id_package)
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (50 , 67, 71, 76)
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
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
        pd.tracking_number IS NULL
            AND (sup.type = 'supplier'
            OR sel.tax_class = 'local')
    GROUP BY soi.id_sales_order_item
    HAVING finance_verified IS NOT NULL) result) result) result