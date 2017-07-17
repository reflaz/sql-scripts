/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by LSC SOI
 
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
    *
FROM
    (SELECT 
        soi.bob_id_sales_order_item,
            lsc_soi.sc_sales_order_item,
            soi.id_sales_order_item 'sap_item_id',
            so.order_nr,
            so.payment_method,
            soi.name 'item_name',
            soi.sku,
            sup.id_supplier,
            IFNULL(asc_sel.short_code, lsc_sel.short_code) 'short_code',
            sup.name 'seller_name',
            sup.type 'seller_type',
            IFNULL(CASE
                WHEN asc_sel.tax_class = 0 THEN 'local'
                WHEN asc_sel.tax_class = 1 THEN 'international'
            END, lsc_sel.tax_class) 'tax_class',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            lsc_soi.sc_payment_fee,
            lsc_soi.sc_shipping_fee,
            lsc_soi.sc_commission_fee,
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
        (SELECT 
        lsc_soi.src_id,
            lsc_soi.id_sales_order_item 'sc_sales_order_item',
            SUM(IF(lsc_tr.fk_transaction_type = 3, lsc_tr.value, 0)) 'sc_payment_fee',
            SUM(IF(lsc_tr.fk_transaction_type = 7, lsc_tr.value, 0)) 'sc_shipping_fee',
            SUM(IF(lsc_tr.fk_transaction_type = 16, lsc_tr.value, 0)) 'sc_commission_fee'
    FROM
        screport.sales_order_item lsc_soi
    LEFT JOIN screport.transaction lsc_tr ON lsc_soi.id_sales_order_item = lsc_tr.ref
    WHERE
        lsc_soi.id_sales_order_item IN ()
    GROUP BY lsc_soi.id_sales_order_item) lsc_soi
    LEFT JOIN oms_live.ims_sales_order_item soi ON lsc_soi.src_id = soi.id_sales_order_item
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
    LEFT JOIN asc_live.seller asc_sel ON sup.id_supplier = asc_sel.src_id
    LEFT JOIN screport.seller lsc_sel ON sup.id_supplier = lsc_sel.src_id
    GROUP BY soi.id_sales_order_item) result