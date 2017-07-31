/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by ASC SOI
 
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
            asc_soi.sc_sales_order_item,
            soi.id_sales_order_item 'sap_item_id',
            so.order_nr,
            so.payment_method,
            soi.name 'item_name',
            soi.sku,
            sup.id_supplier,
            IFNULL(asc_sel.short_code, NULL) 'short_code',
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN asc_sel.tax_class = 0 THEN 'local'
                WHEN asc_sel.tax_class = 1 THEN 'international'
            END 'tax_class',
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            asc_soi.sc_payment_fee,
            asc_soi.sc_shipping_fee,
            asc_soi.sc_commission_fee,
            asc_soi.sc_seller_credit_item,
            asc_soi.sc_seller_debit_item,
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
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'real_delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, user.username, NULL)) 'delivery_updater',
            pck.package_number,
            pck.invoice_number,
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            CASE
                WHEN asc_sel.tax_class = 1 THEN 'Cross Border'
                WHEN
                    sup.type = 'supplier'
                        OR st.name = 'warehouse'
                        OR soi.fk_mwh_warehouse <> 1
                        OR sfom.origin IS NULL
                THEN
                    CASE
                        WHEN soi.fk_mwh_warehouse = 1 THEN 'DKI Jakarta'
                        WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                        WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
                        WHEN soi.fk_mwh_warehouse = 4 THEN 'DKI Jakarta'
                    END
                ELSE sfom.origin
            END 'origin',
            soa.city 'destination_city',
            dst.id_customer_address_region 'id_district'
    FROM
        (SELECT 
        asc_soi.src_id,
            asc_soi.id_sales_order_item 'sc_sales_order_item',
            SUM(IF(asc_tr.fk_transaction_type = 3, asc_tr.value, 0)) 'sc_payment_fee',
            SUM(IF(asc_tr.fk_transaction_type = 7, asc_tr.value, 0)) 'sc_shipping_fee',
            SUM(IF(asc_tr.fk_transaction_type = 16, asc_tr.value, 0)) 'sc_commission_fee',
            SUM(IF(asc_tr.fk_transaction_type = 36, asc_tr.value, 0)) 'sc_seller_credit_item',
            SUM(IF(asc_tr.fk_transaction_type = 37, asc_tr.value, 0)) 'sc_seller_debit_item'
    FROM
        asc_live.sales_order_item asc_soi
    LEFT JOIN asc_live.transaction asc_tr ON asc_soi.id_sales_order_item = asc_tr.ref
    WHERE
        asc_soi.id_sales_order_item IN ()
            AND asc_tr.fk_transaction_type IN (3 , 7, 16, 36, 37)
    GROUP BY asc_soi.id_sales_order_item) asc_soi
    LEFT JOIN oms_live.ims_sales_order_item soi ON asc_soi.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.oms_shipping_type st ON soi.fk_shipping_type = st.id_shipping_type
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
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL
                AND address_type = 'warehouse')
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region
                AND origin <> 'Cross Border'
                AND is_live = 1)
    LEFT JOIN asc_live.seller asc_sel ON sup.id_supplier = asc_sel.src_id
    GROUP BY soi.id_sales_order_item) result