/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Tax Invoice Automation System - Transaction Extract

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
SET @extractstart = '2016-12-01';
SET @extractend = '2017-01-01';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        IFNULL(tr.number, 'NULL') 'transaction_number',
            IFNULL(tt.description, 'NULL') 'transaction_type',
            IFNULL(tr.value, 'NULL') 'value',
            IFNULL(DATE_FORMAT(tr.created_at, '%Y-%m-%d %H:%i:%s'), 'NULL') 'transaction_date',
            IFNULL(tr.description, 'NULL') 'description',
            IFNULL(soi.id_sales_order_item, 'NULL') 'sap_item_id',
            IFNULL(DATE_FORMAT(soish.created_at, '%Y-%m-%d %H:%i:%s'), 'NULL') 'delivered_date',
            IFNULL(sel.src_id, 'NULL') 'bob_id_supplier'
    FROM
        asc_live.transaction tr
    LEFT JOIN asc_live.transaction_type tt ON tr.fk_transaction_type = tt.id_transaction_type
    LEFT JOIN asc_live.sales_order_item scsoi ON tr.ref = scsoi.id_sales_order_item
    LEFT JOIN asc_live.seller sel ON tr.fk_seller = sel.id_seller
    LEFT JOIN oms_live.ims_sales_order_item soi ON scsoi.src_id = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    WHERE
        tr.created_at >= @extractstart
            AND tr.created_at < @extractend
            AND tr.fk_transaction_type IN (3 , 4, 67, 84, 15, 16, 65, 66, 123, 112, 137)
    GROUP BY transaction_number) sca;