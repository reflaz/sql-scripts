/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.4
Changes made	: - 1.4. Change layout
				  - 1.3. Took out SKU category, as it is not needed anymore, to speed up the script.
				  - 1.3. To cater weekly and bi-weekly statement. Also add other transactions in the result (other fee,
					seller credit item, seller debit item, seller credit). Implemented in other script.

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-05-01';
SET @extractend = '2016-05-16'; -- this must be the day after the expected end date/h+1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr 'order_number',
            soi.bob_id_sales_order_item 'sales_order_item',
            soi.id_sales_order_item 'sap_item_id',
            sc.id_sales_order_item 'sc_sales_order_item',
            so.created_at 'order_date',
            sois.name 'item_status',
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'verified_date',
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
            soi.sku 'sku',
            pd.tracking_number 'awb',
            sp.shipment_provider_name 'shipment_provider',
            sc.sc_id_seller,
            sc.seller_name,
            sc.legal_name,
            so.payment_method 'payment_method',
            sc.start_date 'time_frame_start',
            sc.end_date 'time_frame_end',
            sc.transaction_id 'transaction_id'
    FROM
        (SELECT 
        ts.id_transaction_statement,
            ts.start_date,
            ts.end_date,
            ts.created_at 'statement_date',
            MIN(tr.created_at) 'transaction_date',
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
            tr.number 'transaction_id',
            ts.number 'statement_id',
            sel.tax_class,
            sel.short_code 'sc_id_seller',
            sel.name 'seller_name',
            sel.name_company 'legal_name'
    FROM
        screport.transaction tr
    LEFT JOIN screport.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN screport.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    LEFT JOIN screport.seller sel ON soi.fk_seller = sel.id_seller
    WHERE
        tr.created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
            AND tr.created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
            AND tr.fk_transaction_type IN (3 , 7, 8, 13, 14, 15, 16, 20, 26)
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
    GROUP BY soi.id_sales_order_item) result;