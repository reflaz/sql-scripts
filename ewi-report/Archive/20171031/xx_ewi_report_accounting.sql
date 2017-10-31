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
SET @extractstart = '2016-11-21';
SET @extractend = '2016-11-28';-- this must be the day after the expected end date/h+1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr 'order_number',
        soi.bob_id_sales_order_item 'sales_order_item',
        so.payment_method 'payment_method',
		sois.name 'item_status',
		so.created_at 'order_date',
		MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'verified_date',
		MIN(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'delivered_date',
		MIN(IF(soish.fk_sales_order_item_status = 27, soish.created_at, NULL)) 'delivered_date_input',
        soi.paid_price,
		soi.shipping_amount,
		soi.shipping_surcharge,
		sc.item_price_credit,
		sc.commission,
		sc.payment_fee,
		sc.shipping_fee_credit,
		sc.shipping_fee,
		(sc.item_price_credit + sc.commission + sc.payment_fee + sc.shipping_fee_credit + sc.item_price + sc.comission_credit + sc.shipping_fee + sc.seller_credit + sc.seller_credit_item + sc.other_fee + sc.seller_debit_item) 'amount_paid_seller',
		sc.transaction_id 'transaction_id',
		sc.transaction_date,
		sc.sc_id_seller
            
    FROM
        (SELECT 
            MIN(tr.created_at) 'transaction_date',
            SUM(IF(tr.fk_transaction_type = 13, tr.value, 0)) 'item_price_credit',
            SUM(IF(tr.fk_transaction_type = 16, tr.value, 0)) 'commission',
            SUM(IF(tr.fk_transaction_type = 3, tr.value, 0)) 'payment_fee',
            SUM(IF(tr.fk_transaction_type = 8, tr.value, 0)) 'shipping_fee_credit',
            SUM(IF(tr.fk_transaction_type = 14, tr.value, 0)) 'item_price',
            SUM(IF(tr.fk_transaction_type = 15, tr.value, 0)) 'comission_credit',
            SUM(IF(tr.fk_transaction_type = 7, tr.value, 0)) 'shipping_fee',
            SUM(IF(tr.fk_transaction_type = 19, tr.value, 0)) 'seller_credit',
            SUM(IF(tr.fk_transaction_type = 36, tr.value, 0)) 'seller_credit_item',
            SUM(IF(tr.fk_transaction_type = 20, tr.value, 0)) 'other_fee',
            SUM(IF(tr.fk_transaction_type = 37, tr.value, 0)) 'seller_debit_item',
            soi.id_sales_order_item,
            soi.src_id,
            tr.number 'transaction_id',
            ts.number 'statement_id',
            sel.tax_class,
            sel.short_code 'sc_id_seller',
            sel.name 'seller_name',
            sel.name_company 'legal_name'
		FROM
			asc_live.transaction tr
		LEFT JOIN asc_live.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
		LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
		LEFT JOIN asc_live.seller sel ON soi.fk_seller = sel.id_seller
		WHERE
			tr.created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
				AND tr.created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
				AND tr.fk_transaction_type IN (3 , 7, 8, 13, 14, 15, 16, 20, 26)
		GROUP BY tr.ref) sc

    LEFT JOIN oms_live.ims_sales_order_item soi ON sc.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (67, 27) -- (5 , 27, 56, 67, 68, 78)
    WHERE
        soi.id_sales_order_item IS NOT NULL
    GROUP BY soi.id_sales_order_item) result;