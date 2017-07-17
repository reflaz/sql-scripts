/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.3
Changes made	: - 1.3. Took out SKU category, as it is not needed anymore, to speed up the script.
				  - 1.3. To cater weekly and bi-weekly statement. Also add other transactions in the result (other fee,
					seller credit item, seller debit item, seller credit).

Instructions	: Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-05-01';
SET @extractend = '2016-05-16'; -- this must be the day after the expected end date/h+1

SELECT 
    tr.value AS 'other_fee',
    tr.created_at AS 'transaction_date',
    sel.tax_class AS 'tax_class',
    tr.description AS 'description',
    tt.description AS 'transaction_type',
    sel.short_code 'sc_id_seller',
    sel.name 'seller_name',
    sel.name_company 'legal_name',
    ts.start_date 'time_frame_start',
    ts.end_date 'time_frame_end',
    tr.number 'transaction_statement_id'
FROM
    screport.transaction tr
        LEFT JOIN
    screport.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
        LEFT JOIN
    screport.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
        LEFT JOIN
    screport.seller sel ON tr.fk_seller = sel.id_seller
WHERE
    tr.created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
        AND tr.created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
        AND tr.fk_transaction_type IN (19 , 20, 36, 37)
        AND tr.value IS NOT NULL;