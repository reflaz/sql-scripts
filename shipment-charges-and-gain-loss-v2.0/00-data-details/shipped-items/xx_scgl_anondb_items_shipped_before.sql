/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Items Shipped Before

Prepared by		: R Maliangkay
Modified by		: RM
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
SET @extractstart = '2017-02-01';
SET @extractend = '2017-03-01';-- This MUST be D + 1

SELECT 
    COUNT(*) 'count_soi'
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            so.created_at 'order_date',
            sois.name 'soi_status',
            soi.last_status_change,
            sois1.name 'soish_status',
            soish.created_at 'soish_status_change'
    FROM
        oms_live.ims_sales_order_item soi
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item)
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN oms_live.ims_sales_order_item_status sois1 ON soish.fk_sales_order_item_status = sois1.id_sales_order_item_status
    WHERE
        soi.last_status_change >= @extractstart
            AND soi.last_status_change < @extractend
            AND soi.fk_sales_order_item_status = 5) result;