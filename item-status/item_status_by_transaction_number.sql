/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Item Status by SAP Item ID
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameter in excel using this formula: ="'"&Column&"'," --> change Column accordingly
                  - Insert formatted SAP Item ID in >> WHERE oms_soi.id_sales_order_item IN () << part of the script
                  - Delete the last comma (,)
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    *
FROM
    (SELECT 
        tr.number 'transaction_id',
            oms_so.order_nr,
            oms_soi.bob_id_sales_order_item 'sales_order_item',
            oms_soi.id_sales_order_item 'oms_item_no',
            oms_so.payment_method,
            oms_soi.unit_price,
            oms_soi.paid_price,
            oms_soi.shipping_surcharge,
            oms_sois.name AS current_status,
            MIN(oms_so.created_at) AS created_date,
            MIN(oms_pck.created_at) AS package_date,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 69 THEN oms_soish.created_at
                ELSE NULL
            END) AS order_verification,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 67 THEN oms_soish.created_at
                ELSE NULL
            END) AS finance_verified,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 5 THEN oms_soish.created_at
                ELSE NULL
            END) AS shipped,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 9 THEN oms_soish.created_at
                ELSE NULL
            END) AS cancelled,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status IN (8 , 11) THEN oms_soish.created_at
                ELSE NULL
            END) AS returned,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status IN (56 , 78) THEN oms_soish.created_at
                ELSE NULL
            END) AS refunded_replaced,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 27 THEN oms_soish.created_at
                ELSE NULL
            END) AS delivered,
            MIN(CASE
                WHEN oms_soish.fk_sales_order_item_status = 27 THEN oms_soish.real_action_date
                ELSE NULL
            END) AS real_delivered,
            SUM(CASE
                WHEN oms_soish.fk_sales_order_item_status IN (50 , 76) THEN 1
                ELSE 0
            END) AS times_shipped,
            CASE
                WHEN
                    is_marketplace = 0
                        AND oms_soi.fk_marketplace_merchant IS NOT NULL
                THEN
                    1
                ELSE 0
            END AS mp_to_retail_change,
            bob_sup.name AS seller_name,
            bob_sup.type AS seller_type,
            soa.city 'destination_city'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.sales_order_item ssoi ON tr.ref = ssoi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item oms_soi ON ssoi.src_id = oms_soi.id_sales_order_item
    JOIN oms_live.ims_sales_order oms_so ON oms_soi.fk_sales_order = oms_so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON oms_so.fk_sales_order_address_shipping = soa.id_sales_order_address
    JOIN oms_live.ims_sales_order_item_status_history oms_soish ON oms_soi.id_sales_order_item = oms_soish.fk_sales_order_item
    JOIN oms_live.ims_sales_order_item_status oms_sois ON oms_soi.fk_sales_order_item_status = oms_sois.id_sales_order_item_status
    LEFT JOIN oms_live.oms_package_item oms_pi ON oms_soi.id_sales_order_item = oms_pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package oms_pck ON oms_pi.fk_package = oms_pck.id_package
    LEFT JOIN bob_live.supplier bob_sup ON oms_soi.bob_id_supplier = bob_sup.id_supplier
    WHERE
        tr.number IN ()
    GROUP BY bob_id_sales_order_item) result;