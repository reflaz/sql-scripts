/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by BOB SOI
 
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

/*
 result.bob_id_sales_order_item,
    result.sc_sales_order_item,
    result.sap_item_id,
    result.uid,
    result.order_nr,
    result.payment_method,
    result.item_name,
    result.sku,
    result.id_supplier,
    result.short_code,
    result.seller_name,
    result.seller_type,
    result.tax_class,
    result.unit_price,
    result.paid_price,
    result.shipping_amount,
    result.shipping_surcharge,
    result.sc_payment_fee,
    result.sc_shipping_fee,
    result.sc_commission_fee,
    result.sc_seller_credit_item,
    result.sc_seller_debit_item,
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
    result.real_delivered_date,
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
*/
SELECT 
    soi.bob_id_sales_order_item,
    'sc_id_sales_order_item',
    soi.id_sales_order_item 'sap_item_id',
    'uid',
    so.order_nr,
    so.payment_method,
    soi.name 'item_name',
    soi.sku,
    sup.id_supplier 'bob_id_supplier',
    ascsel.short_code,
    sup.name 'seller_name',
    sup.type 'seller_type',
    'tax_class',
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
    'instant_refund',
    so.created_at 'order_date',
    IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 5),
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 4)) 'first_shipped_date',
    IFNULL((SELECT 
                    MAX(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 5),
            (SELECT 
                    MAX(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 4)) 'last_shipped_date',
    IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 27),
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 6)) 'delivered_date',
    IFNULL((SELECT 
                    MIN(real_action_date)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 27),
            (SELECT 
                    MIN(real_action_date)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 6)) 'real_delivered_date',
    IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 44),
            (SELECT 
                    MIN(created_at)
                FROM
                    oms_live.oms_package_status_history
                WHERE
                    fk_package = pck.id_package
                        AND fk_package_status = 5)) 'failed_delivery_date',
    (SELECT 
            username
        FROM
            oms_live.ims_user
        WHERE
            id_user = IFNULL((SELECT 
                            fk_user
                        FROM
                            oms_live.ims_sales_order_item_status_history
                        WHERE
                            fk_sales_order_item = soi.id_sales_order_item
                                AND fk_sales_order_item_status = 27),
                    (SELECT 
                            fk_ims_user
                        FROM
                            oms_live.oms_package_status_history
                        WHERE
                            fk_package = pck.id_package
                                AND fk_package_status = 6))) 'delivery_updater',
    pck.package_number 'package_number',
    pck.invoice_number 'invoice_number',
    pdh.tracking_number 'first_tracking_number',
    sp1.shipment_provider_name 'first_shipment_provider',
    pd.tracking_number 'last_tracking_number',
    sp2.shipment_provider_name 'last_shipment_provider',
    'origin',
    'destination_city',
    'id_district'
FROM
    oms_live.ims_sales_order_item soi
        LEFT JOIN
    oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soish.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.oms_package_item pi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pck.id_package = pi.fk_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package = pck.id_package
                AND tracking_number IS NOT NULL)
        LEFT JOIN
    oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
        LEFT JOIN
    oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON soa.id_sales_order_address = so.fk_sales_order_address_shipping
        LEFT JOIN
    oms_live.ims_customer_address_region dst ON dst.id_customer_address_region = soa.fk_customer_address_region
        LEFT JOIN
    oms_live.ims_sales_order_voucher_type sovt ON sovt.id_sales_order_voucher_type = so.fk_voucher_type
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON sois.id_sales_order_item_status = soi.fk_sales_order_item_status
        LEFT JOIN
    bob_live.supplier sup ON sup.id_supplier = soi.bob_id_supplier
        LEFT JOIN
    asc_live.seller ascsel ON ascsel.src_id = sup.id_supplier
WHERE
    soi.bob_id_sales_order_item IN ('111968957')