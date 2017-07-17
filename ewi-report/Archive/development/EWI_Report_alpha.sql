/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-03-21';
SET @extractend = '2016-03-28'; -- this must be the day after

SELECT 
    * -- , bob_lv2.name_en 'cat_lv2'
FROM
    (SELECT 
        soi.id_sales_order_item 'sap_item_id',
            soi.bob_id_sales_order_item 'sales_order_item',
            sc.id_sales_order_item 'sc_sales_order_item',
            so.created_at 'order_date',
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'verified_date',
            sois.name 'item_status',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'delivered_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date_input',
            MIN(IF(soish.fk_sales_order_item_status = 68, soish.created_at, NULL)) 'returned_date',
            soi.unit_price 'unit_price',
            soi.paid_price 'paid_price',
            soi.shipping_surcharge 'shipping_surcharge',
            sc.item_price_credit,
            sc.shipping_fee_credit,
            sc.commission,
            sc.payment_fee,
            sc.item_price,
            sc.comission_credit,
            sc.return_to_seller_fee,
            sc.shipping_fee,
            sc.other_fee,
            (sc.item_price_credit + sc.shipping_fee_credit + sc.commission + sc.payment_fee + sc.item_price + sc.comission_credit + sc.return_to_seller_fee + sc.shipping_fee + sc.other_fee) 'amount_paid_seller',
            soi.coupon_money_value,
            soi.cart_rule_discount,
            (IFNULL(sc.commission, 0) + IFNULL(sc.payment_fee, 0)) / 1.1 'gross_commission_income',
            ((IFNULL(sc.commission, 0) + IFNULL(sc.payment_fee, 0)) / 1.1) * 0.1 'vat_out',
            sc.transaction_date,
            sc.tax_class,
            so.order_nr 'order_number',
            soi.sku 'sku',
            pd.tracking_number 'awb',
            sp.shipment_provider_name 'shipment_provider',
            sc.sc_id_seller,
            sc.seller_name,
            so.payment_method 'payment_method',
            sc.start_date 'time_frame_start',
            sc.end_date 'time_frame_end',
            sc.number 'transaction_statement_id'
    FROM
        (SELECT 
        ts.id_transaction_statement,
            ts.start_date,
            ts.end_date,
            ts.created_at 'statement_date',
            MIN(IF(tr.fk_transaction_type = 13, tr.created_at, NULL)) 'transaction_date',
            SUM(IF(tr.fk_transaction_type = 13, tr.value, 0)) 'item_price_credit',
            SUM(IF(tr.fk_transaction_type = 8, tr.value, 0)) 'shipping_fee_credit',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'commission',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'payment_fee',
            SUM(IF(tr.fk_transaction_type = 14, tr.value, 0)) 'item_price',
            SUM(IF(tr.fk_transaction_type = 15, tr.value, 0)) 'comission_credit',
            SUM(IF(tr.fk_transaction_type = 26, tr.value, 0)) 'return_to_seller_fee',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'shipping_fee',
            SUM(IF(tr.fk_transaction_type = 20, tr.value, 0)) 'other_fee',
            soi.id_sales_order_item,
            soi.src_id,
            ts.number,
            sel.tax_class,
            sel.short_code 'sc_id_seller',
            sel.name 'seller_name'
    FROM
        screport.transaction_statement ts
    LEFT JOIN screport.transaction tr ON ts.id_transaction_statement = tr.fk_transaction_statement
        AND tr.fk_transaction_type IN (3 , 7, 8, 13, 14, 15, 16, 20, 26)
    LEFT JOIN screport.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN screport.seller sel ON soi.fk_seller = sel.id_seller
    WHERE
        start_date >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
            AND end_date < STR_TO_DATE(@extractend, '%Y-%m-%d')
    GROUP BY tr.ref) sc
    LEFT JOIN oms_live.ims_sales_order_item soi ON sc.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (67 , 5, 27, 68)
    LEFT JOIN oms_live.oms_package_item pi ON soi.id_sales_order_item = pi.fk_sales_order_item
    LEFT JOIN oms_live.oms_package_dispatching pd ON pi.fk_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    WHERE
        soi.id_sales_order_item IS NOT NULL
    GROUP BY soi.id_sales_order_item) result
--         LEFT JOIN
--     bob_live.sales_order_item bob_soi ON result.sales_order_item = bob_soi.id_sales_order_item
--         LEFT JOIN
--     bob_live.catalog_simple bob_cs ON bob_soi.fk_catalog_simple = bob_cs.id_catalog_simple
--         LEFT JOIN
--     bob_live.catalog_config bob_cc ON bob_cs.fk_catalog_config = bob_cc.id_catalog_config
--         LEFT JOIN
--     bob_live.catalog_category bob_ccat ON bob_cc.primary_category = bob_ccat.id_catalog_category
--         LEFT JOIN
--     bob_live.catalog_category bob_lv2 ON bob_ccat.lft >= bob_lv2.lft
--         AND bob_ccat.rgt <= bob_lv2.rgt
--         AND bob_lv2.id_catalog_category = (SELECT 
--             cc.id_catalog_category
--         FROM
--             bob_live.catalog_category cc
--         WHERE
--             cc.lft <= bob_ccat.lft
--                 AND cc.rgt >= bob_ccat.rgt
--                 AND cc.id_catalog_category <> 1
--         LIMIT 1 , 1)