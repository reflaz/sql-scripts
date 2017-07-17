/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by First Shipped Date
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-08-02';
SET @extractend = '2016-08-03'; -- This MUST be H + 1

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
            soi.id_sales_order_item 'sap_item_id',
            so.order_nr,
            so.payment_method,
            soi.name 'item_name',
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
            soi.sc_payment_fee 'sc_payment_fee',
            soi.sc_shipping_fee 'sc_shipping_fee',
            soi.sc_commission_fee 'sc_commission_fee',
            soi.coupon_money_value,
            soi.cart_rule_discount,
            so.coupon_code,
            sovt.name 'coupon_type',
            soi.cart_rule_display_names,
            sois.name 'last_status',
            IF(flag.id_flag = 9, 'Yes', 'No') 'instant_refund',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'first_shipped_date',
            MAX(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'last_shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, user.username, NULL)) 'delivery_updater',
            soi.package_number,
            soi.invoice_number,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
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
            pck.id_package,
            pck.package_number,
            pck.invoice_number,
            scsoi.id_sales_order_item 'sc_sales_order_item',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'sc_payment_fee',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'sc_shipping_fee',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'sc_commission_fee'
    FROM
        oms_live.oms_package_status_history psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN asc_live.sales_order_item scsoi ON soi.id_sales_order_item = scsoi.src_id
    LEFT JOIN asc_live.transaction tr ON scsoi.id_sales_order_item = tr.ref
    WHERE
        psh.created_at >= @extractstart
            AND psh.created_at < @extractend
            AND psh.fk_package_status = 4
    GROUP BY soi.id_sales_order_item) soi
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON soi.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = soi.id_package
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_package_dispatching pd ON soi.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27)
    LEFT JOIN oms_live.ims_user user ON soish.fk_user = user.id_user
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON so.fk_voucher_type = sovt.id_sales_order_voucher_type
    LEFT JOIN oms_live.oms_flag flag ON so.fk_flag = flag.id_flag
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
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    GROUP BY soi.id_sales_order_item
    HAVING first_shipped_date >= @extractstart
        AND first_shipped_date < @extractend) result) result) result