/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Sales Order SC Transaction Details
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.4
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
    so.order_nr 'order_number',
    soi.bob_id_sales_order_item 'sales_order_item',
    soi.id_sales_order_item 'sap_item_id',
    trans.sc_id_sales_order_item 'sc_id_sales_order_item',
    so.payment_method 'payment_method',
    sois.name 'item_status',
    so.created_at 'order_date',
    (SELECT 
            MIN(created_at)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 67) 'verified_date',
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
            MIN(created_at)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 68) 'returned_date',
    (SELECT 
            MIN(created_at)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 78) 'replaced_date',
    (SELECT 
            MIN(created_at)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 56) 'refunded_date',
    soi.unit_price,
    soi.paid_price,
    soi.coupon_money_value,
    soi.cart_rule_discount,
    soi.shipping_amount,
    soi.shipping_surcharge,
    trans.commission,
    trans.commission_adjustment,
    trans.payment_fee,
    trans.payment_fee_adjustment,
    trans.auto_shipping_fee,
    trans.manual_shipping_fee_lzd,
    trans.manual_shipping_fee_3p,
    trans.shipping_fee_adjustment,
    trans.amount_paid_seller,
    trans.transaction_id 'transaction_id',
    trans.transaction_date,
    trans.start_date 'statement_time_frame_start',
    trans.end_date 'statement_time_frame_end',
    soi.sku,
    soa.fk_customer_address_region 'district_id',
    pd.tracking_number 'awb',
    sp.shipment_provider_name 'shipment_provider',
    trans.sc_id_seller,
    trans.seller_name,
    trans.legal_name,
    trans.tax_class
FROM
    (SELECT 
        asctr.*,
            ts.id_transaction_statement,
            ts.start_date,
            ts.end_date,
            ts.created_at 'statement_date',
            ts.number 'statement_id'
    FROM
        (SELECT 
        sc.*,
            IFNULL((SELECT 
                    MIN(tr.number)
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND ta.id_transaction IS NULL), (SELECT 
                    MIN(ta.number)
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item)) 'transaction_id',
            IFNULL((SELECT 
                    MIN(tr.created_at)
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND ta.id_transaction IS NULL), (SELECT 
                    MIN(ta.created_at)
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item)) 'transaction_date',
            IFNULL((SELECT 
                    MIN(tr.fk_transaction_statement)
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND ta.id_transaction IS NULL), (SELECT 
                    MIN(ta.fk_transaction_statement)
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item)) 'fk_transaction_statement',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (15 , 16)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (15 , 16)), 0)) * - 1 'commission',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (65 , 66, 123)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (65 , 66, 123)), 0)) * - 1 'commission_adjustment',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (3 , 4)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (3 , 4)), 0)) * - 1 'payment_fee',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (67 , 84)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (67 , 84)), 0)) * - 1 'payment_fee_adjustment',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (8 , 142)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (8 , 142)), 0)) * - 1 'auto_shipping_fee',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (7 , 143)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (7 , 143)), 0)) * - 1 'manual_shipping_fee_lzd',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type = 21
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type = 21), 0)) * - 1 'manual_shipping_fee_3p',
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
                        OR ta.description LIKE '%flat fee%')), 0)) * - 1 'shipping_fee_adjustment',
            (IFNULL((SELECT 
                    SUM(IFNULL(tr.value, 0))
                FROM
                    asc_live.transaction tr
                LEFT JOIN asc_live.transaction_archive ta ON tr.number = ta.number
                WHERE
                    tr.ref = sc_id_sales_order_item
                        AND tr.fk_transaction_type IN (13 , 16, 3, 8, 14, 15, 7, 19, 36, 20, 37)
                        AND ta.id_transaction IS NULL), 0) + IFNULL((SELECT 
                    SUM(IFNULL(ta.value, 0))
                FROM
                    asc_live.transaction_archive ta
                WHERE
                    ta.ref = sc_id_sales_order_item
                        AND ta.fk_transaction_type IN (13 , 16, 3, 8, 14, 15, 7, 19, 36, 20, 37)), 0)) * - 1 'amount_paid_seller'
    FROM
        (SELECT 
        ascso.order_nr,
            ascsoi.id_sales_order_item 'sc_id_sales_order_item',
            ascsoi.src_id,
            ascsel.tax_class,
            ascsel.short_code 'sc_id_seller',
            ascsel.name 'seller_name',
            ascsel.name_company 'legal_name'
    FROM
        asc_live.sales_order ascso
    LEFT JOIN asc_live.sales_order_item ascsoi ON ascso.id_sales_order = ascsoi.fk_sales_order
    LEFT JOIN asc_live.seller ascsel ON ascsel.id_seller = ascsoi.fk_seller
    WHERE
        ascso.order_nr IN ()) sc) asctr
    LEFT JOIN asc_live.transaction_statement ts ON ts.id_transaction_statement = fk_transaction_statement) trans
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON trans.src_id = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order so ON so.id_sales_order = soi.fk_sales_order
        LEFT JOIN
    oms_live.ims_sales_order_item_status sois ON sois.id_sales_order_item_status = soi.fk_sales_order_item_status
        LEFT JOIN
    oms_live.ims_sales_order_address soa ON soa.id_sales_order_address = so.fk_sales_order_address_shipping
        LEFT JOIN
    oms_live.oms_package_item pi ON pi.fk_sales_order_item = soi.id_sales_order_item
        LEFT JOIN
    oms_live.oms_package pck ON pi.fk_package = pck.id_package
        LEFT JOIN
    oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
        LEFT JOIN
    oms_live.oms_shipment_provider sp ON sp.id_shipment_provider = pd.fk_shipment_provider
