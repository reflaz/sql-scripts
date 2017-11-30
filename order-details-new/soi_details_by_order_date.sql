/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Date
 
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
SET @extractstart = '2016-10-01';
SET @extractend = '2016-10-02';-- This MUST be D + 1

SELECT 
    result.bob_id_sales_order_item,
    result.sc_id_sales_order_item,
    result.sap_item_id,
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
    result.commission,
    result.commission_adjustment,
    result.payment_fee,
    result.payment_fee_adjustment,
    result.auto_shipping_fee,
    result.manual_shipping_fee_lzd,
    result.manual_shipping_fee_3p,
    result.shipping_fee_adjustment,
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
FROM
    (SELECT 
        res.*,
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (15 , 16)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (15 , 16)), 0) * - 1 'commission',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (65 , 66, 123)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (65 , 66, 123)), 0) * - 1 'commission_adjustment',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (3 , 4)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (3 , 4)), 0) * - 1 'payment_fee',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (67 , 84)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (67 , 84)), 0) * - 1 'payment_fee_adjustment',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (8 , 142)), 0) * - 1 'auto_shipping_fee',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (7 , 143)
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (7 , 143)), 0) * - 1 'manual_shipping_fee_lzd',
            IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type = 21
                        AND ta.id_transaction IS NOT NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type = 21), 0) * - 1 'manual_shipping_fee_3p',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (19 , 20, 36, 37, 64, 104, 138, 140, 141, 144, 145)
                        AND ta.id_transaction IS NULL
                        AND (tr.description LIKE '%shipping%'
                        OR tr.description LIKE '%flat fee%')), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (19 , 20, 36, 37, 64, 104, 138, 140, 141, 144, 145)
                        AND (ta.description LIKE '%shipping%'
                        OR ta.description LIKE '%flat fee%')), 0)) * - 1 'shipping_fee_adjustment'
    FROM
        (SELECT 
        soi.bob_id_sales_order_item,
            COALESCE((SELECT 
                    id_sales_order_item
                FROM
                    asc_live.sales_order_item
                WHERE
                    src_id = soi.id_sales_order_item), (SELECT 
                    id_sales_order_item
                FROM
                    asc_live.sales_order_item_archive
                WHERE
                    src_id = soi.id_sales_order_item)) 'sc_id_sales_order_item',
            soi.id_sales_order_item 'sap_item_id',
            so.order_nr,
            so.payment_method,
            soi.name 'item_name',
            soi.sku,
            sup.id_supplier 'id_supplier',
            ascsel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN
                    is_marketplace = 1
                        AND sa.fk_country = 101
                THEN
                    'local'
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
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
            IFNULL((SELECT 
                    MIN(created_at)
                FROM
                    oms_live.ims_sales_order_item_status_history
                WHERE
                    fk_sales_order_item = soi.id_sales_order_item
                        AND fk_sales_order_item_status = 5), (SELECT 
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
                        AND fk_sales_order_item_status = 5), (SELECT 
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
                        AND fk_sales_order_item_status = 27), (SELECT 
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
                        AND fk_sales_order_item_status = 27), (SELECT 
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
                        AND fk_sales_order_item_status = 44), (SELECT 
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
                            id_sales_order_item_status_history = (SELECT 
                                    MIN(id_sales_order_item_status_history)
                                FROM
                                    oms_live.ims_sales_order_item_status_history
                                WHERE
                                    fk_sales_order_item = soi.id_sales_order_item
                                        AND fk_sales_order_item_status = 27)), (SELECT 
                            fk_ims_user
                        FROM
                            oms_live.oms_package_status_history
                        WHERE
                            id_package_status_history = (SELECT 
                                    MIN(id_package_status_history)
                                FROM
                                    oms_live.oms_package_status_history
                                WHERE
                                    fk_package = pck.id_package
                                        AND fk_package_status = 6)))) 'delivery_updater',
            pck.package_number 'package_number',
            pck.invoice_number 'invoice_number',
            pdh.tracking_number 'first_tracking_number',
            sp1.shipment_provider_name 'first_shipment_provider',
            pd.tracking_number 'last_tracking_number',
            sp2.shipment_provider_name 'last_shipment_provider',
            CASE
                WHEN
                    sup.type = 'supplier'
                        OR (ascsel.tax_class = 0
                        AND st.name = 'warehouse')
                        OR (ascsel.tax_class = 0
                        AND sfom.origin IS NULL)
                THEN
                    CASE
                        WHEN soi.fk_mwh_warehouse = 1 THEN 'DKI Jakarta'
                        WHEN soi.fk_mwh_warehouse = 2 THEN 'East Java'
                        WHEN soi.fk_mwh_warehouse = 3 THEN 'North Sumatera'
                        ELSE wh.name
                    END
                WHEN sfom.origin IS NOT NULL THEN sfom.origin
                ELSE 'Cross Border'
            END 'origin',
            soa.city 'destination_city',
            dst.id_customer_address_region 'id_district'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history ovip ON soi.id_sales_order_item = ovip.fk_sales_order_item
        AND ovip.fk_sales_order_item_status = 69
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_package_item pi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.oms_package pck ON pi.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_package_dispatching_history pdh ON pck.id_package = pdh.fk_package
        AND pdh.id_package_dispatching_history = (SELECT 
            MIN(id_package_dispatching_history)
        FROM
            oms_live.oms_package_dispatching_history
        WHERE
            fk_package_dispatching = pd.id_package_dispatching
                AND tracking_number IS NOT NULL)
    LEFT JOIN oms_live.oms_shipment_provider sp1 ON pdh.fk_shipment_provider = sp1.id_shipment_provider
    LEFT JOIN oms_live.oms_shipment_provider sp2 ON pd.fk_shipment_provider = sp2.id_shipment_provider
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.oms_shipping_type st ON st.id_shipping_type = soi.fk_shipping_type
    LEFT JOIN oms_live.oms_warehouse wh ON wh.id_warehouse = soi.fk_mwh_warehouse
    LEFT JOIN oms_live.ims_sales_order_voucher_type sovt ON sovt.id_sales_order_voucher_type = so.fk_voucher_type
    LEFT JOIN oms_live.oms_flag flag ON flag.id_flag = so.fk_flag
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL
                AND address_type = 'warehouse')
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country = sfom.fk_country
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country = sa.fk_country
                AND IFNULL(fk_country_region, sa.fk_country_region) = sa.fk_country_region
                AND is_live = 1)
    WHERE
        so.created_at > @extractstart
            AND so.created_at <= @extractend) res) result