/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by SAP Item ID
 
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

SELECT 
    result.bob_id_sales_order_item,
    IFNULL(result.asc_sales_order_item,
            result.lsc_sales_order_item) 'sc_sales_order_item',
    result.sap_item_id,
    result.order_nr,
    result.payment_method,
    result.item_name,
    result.sku,
    result.id_supplier,
    IFNULL(result.asc_short_code,
            result.lsc_short_code) 'short_code',
    result.seller_name,
    result.seller_type,
    IFNULL(result.asc_tax_class,
            result.lsc_tax_class) 'tax_class',
    result.unit_price,
    result.paid_price,
    result.shipping_amount,
    result.shipping_surcharge,
    IF(result.asc_payment_fee = 0,
        result.lsc_payment_fee,
        result.asc_payment_fee) 'sc_payment_fee',
    IF(result.asc_shipping_fee = 0,
        result.lsc_shipping_fee,
        result.asc_shipping_fee) 'sc_shipping_fee',
    IF(result.asc_commission_fee = 0,
        result.lsc_commission_fee,
        result.asc_commission_fee) 'sc_commission_fee',
    result.coupon_money_value,
    result.cart_rule_discount,
    result.coupon_code,
    result.coupon_type,
    result.cart_rule_display_names,
    result.last_status,
    result.instant_refund,
    result.order_date,
    result.first_shipped_date,
    result.last_shipped_date,
    result.delivered_date,
    result.delivery_updater,
    result.package_number,
    result.invoice_number,
    result.first_tracking_number,
    result.first_shipment_provider,
    result.last_tracking_number,
    result.last_shipment_provider,
    result.origin,
    result.destination_city,
    result.id_district
FROM
    (SELECT 
        result.*,
            lsc_soi.id_sales_order_item 'lsc_sales_order_item',
            lsc_sel.tax_class 'lsc_tax_class',
            lsc_sel.short_code 'lsc_short_code',
            SUM(IF(lsc_tr.fk_transaction_type = 3, lsc_tr.value, 0)) 'lsc_payment_fee',
            SUM(IF(lsc_tr.fk_transaction_type = 7, lsc_tr.value, 0)) 'lsc_shipping_fee',
            SUM(IF(lsc_tr.fk_transaction_type = 16, lsc_tr.value, 0)) 'lsc_commission_fee'
    FROM
        (SELECT 
        result.*,
            asc_soi.id_sales_order_item 'asc_sales_order_item',
            CASE
                WHEN asc_sel.tax_class = 0 THEN 'local'
                WHEN asc_sel.tax_class = 1 THEN 'international'
            END AS 'asc_tax_class',
            asc_sel.short_code 'asc_short_code',
            SUM(IF(asc_tr.fk_transaction_type = 3, asc_tr.value, 0)) 'asc_payment_fee',
            SUM(IF(asc_tr.fk_transaction_type = 7, asc_tr.value, 0)) 'asc_shipping_fee',
            SUM(IF(asc_tr.fk_transaction_type = 16, asc_tr.value, 0)) 'asc_commission_fee'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item,
            soi.id_sales_order_item 'sap_item_id',
            so.order_nr,
            so.payment_method,
            soi.name 'item_name',
            soi.sku,
            sup.id_supplier,
            sup.name 'seller_name',
            sup.type 'seller_type',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
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
            pck.package_number,
            pck.invoice_number,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            CASE
                WHEN soi.fk_mwh_warehouse = 1 THEN 'DKI Jakarta'
                WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
            END 'origin',
            soa.city 'destination_city',
            dst.id_customer_address_region 'id_district'
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = pck.id_package
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
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
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    WHERE
        soi.id_sales_order_item IN ()
    GROUP BY soi.id_sales_order_item) result
    LEFT JOIN asc_live.seller asc_sel ON result.id_supplier = asc_sel.src_id
    LEFT JOIN asc_live.sales_order_item asc_soi ON result.sap_item_id = asc_soi.src_id
    LEFT JOIN asc_live.transaction asc_tr ON asc_soi.id_sales_order_item = asc_tr.ref
        AND asc_tr.fk_transaction_type IN (3 , 7, 16)
    GROUP BY result.bob_id_sales_order_item) result
    LEFT JOIN screport.seller lsc_sel ON result.id_supplier = lsc_sel.src_id
    LEFT JOIN screport.sales_order_item lsc_soi ON result.sap_item_id = lsc_soi.src_id
    LEFT JOIN screport.transaction lsc_tr ON lsc_soi.id_sales_order_item = lsc_tr.ref
        AND lsc_tr.fk_transaction_type IN (3 , 7, 16)
    GROUP BY result.bob_id_sales_order_item) result