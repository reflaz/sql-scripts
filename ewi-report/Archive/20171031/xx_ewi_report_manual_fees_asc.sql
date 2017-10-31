/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
EWI Report
 
Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.4
Changes made	:

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-08-01';
SET @extractend = '2017-08-02'; -- this must be the day after the expected end date/h+1

SELECT 
    *
FROM
    (SELECT 
        IFNULL(so.order_nr, '') 'order_nr',
            IFNULL(soi.bob_id_sales_order_item, '') 'bob_id_sales_order_item',
            IFNULL(soi.id_sales_order_item, '') 'sap_item_id',
            IFNULL(asoi.id_sales_order_item, '') 'sc_sales_order_item',
            IFNULL(soish.real_action_date, '') 'real_delivered_date',
            IFNULL(soish.created_at, '') 'oms_delivered_date',
            tt.description 'transaction_type',
            IFNULL(tr.value, 0) 'value',
            IFNULL(tr.taxes_vat, 0) 'vat',
            IFNULL(tr.taxes_wht, 0) 'wht',
            CASE
                WHEN tr.is_wht_in_amount = 0 THEN 'exclusive'
                WHEN tr.is_wht_in_amount = 1 THEN 'inclusive'
            END 'is_wht_inclusive',
            tr.description,
            tr.number 'transaction_number',
            tr.created_at 'transaction_date',
            IFNULL(ts.number, '') 'statement_number',
            IFNULL(ts.start_date, '') 'statement_time_frame_start',
            IFNULL(ts.end_date, '') 'statement_time_frame_end',
            CASE
                WHEN ts.paid = 0 THEN 'not paid'
                WHEN ts.paid = 1 THEN 'paid'
                ELSE 'no statement'
            END 'is_paid',
            soi.bob_id_supplier,
            sel.short_code,
            sel.name 'seller_name',
            sel.name_company 'legal_name',
            CASE
                WHEN sel.tax_class = 0 THEN 'local'
                WHEN sel.tax_class = 1 THEN 'international'
            END 'tax_class'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.transaction_statement ts ON ts.id_transaction_statement = tr.fk_transaction_statement
    LEFT JOIN asc_live.seller sel ON tr.fk_seller = sel.id_seller
    LEFT JOIN asc_live.sales_order_item asoi ON tr.ref = asoi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item soi ON asoi.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    WHERE
        tr.created_at >= STR_TO_DATE(@extractstart, '%Y-%m-%d')
            AND tr.created_at < STR_TO_DATE(@extractend, '%Y-%m-%d')
            AND tr.fk_transaction_type NOT IN (3 , 4, 8, 13, 14, 15, 16, 22, 28, 117, 118, 119, 120, 121, 122, 142)) result;