/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.4
Changes made	: - 1.4. Change layout
				  - 1.3. Took out SKU category, as it is not needed anymore, to speed up the script.
				  - 1.3. To cater weekly and bi-weekly statement. Also add other transactions in the result (other fee,
					seller credit item, seller debit item, seller credit). Implemented in second part of the script (UNION).

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-10-10';
SET @extractend = '2016-10-20';-- this must be the day after the expected end date/h+1

SELECT 
    '' AS 'order_number',
    '' AS 'sales_order_item',
    '' AS 'sap_item_id',
    '' AS 'sc_sales_order_item',
    '' AS 'payment_method',
    '' AS 'item_status',
    '' AS 'order_date',
    '' AS 'verified_date',
    '' AS 'shipped_date',
    soish.real_action_date AS 'delivered_date',
    soish.created_at AS 'delivered_date_input',
    '' AS 'returned_date',
    '' AS 'replaced_date',
    '' AS 'refunded_date',
    0 AS 'unit_price',
    0 AS 'paid_price',
    0 AS 'coupon_money_value',
    0 AS 'cart_rule_discount',
    0 AS 'shipping_amount',
    0 AS 'shipping_surcharge',
    0 AS 'item_price_credit',
    0 AS 'commission',
    0 AS 'payment_fee',
    0 AS 'shipping_fee_credit',
    0 AS 'item_price',
    0 AS 'comission_credit',
    0 AS 'shipping_fee',
    IF(tr.fk_transaction_type = 19,
        tr.value,
        0) 'seller_credit',
    IF(tr.fk_transaction_type = 36,
        tr.value,
        0) 'seller_credit_item',
    IF(tr.fk_transaction_type = 20,
        tr.value,
        0) 'other_fee',
    IF(tr.fk_transaction_type = 37,
        tr.value,
        0) 'seller_debit_item',
    tr.value 'amount_paid_seller',
    tr.number 'transaction_id',
    tr.created_at 'transaction_date',
    ts.start_date 'statement_time_frame_start',
    ts.end_date 'statement_time_frame_end',
    tr.description AS 'sku',
    '' AS 'district_id',
    '' AS 'awb',
    '' AS 'shipment_provider',
    sel.short_code 'sc_id_seller',
    sel.name 'seller_name',
    sel.name_company 'legal_name',
    sel.tax_class
FROM
    asc_live.transaction tr
        LEFT JOIN
    asc_live.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
        LEFT JOIN
    asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
        LEFT JOIN
    asc_live.seller sel ON tr.fk_seller = sel.id_seller
        LEFT JOIN
    asc_live.sales_order_item asoi ON tr.ref = asoi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order_item soi ON asoi.src_id = soi.id_sales_order_item
        LEFT JOIN
    oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
WHERE
    tr.created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
        AND tr.created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
        AND tr.fk_transaction_type IN (19 , 20, 36, 37)
        AND tr.value IS NOT NULL;