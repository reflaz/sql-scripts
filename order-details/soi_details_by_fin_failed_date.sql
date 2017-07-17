/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Number
 
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
SET @extractstart = '2016-10-01';
SET @extractend = '2016-10-02';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            so.payment_method,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            sois.name 'last_status',
            soish.created_at 'finance_failed_date',
            MIN(IF(soish1.fk_sales_order_item_status = 6, soish.created_at, NULL)) 'cancelled_date',
            MIN(IF(soish1.fk_sales_order_item_status = 56, soish.created_at, NULL)) 'refund_completed_date'
    FROM
        (SELECT 
        fk_sales_order_item, created_at
    FROM
        oms_live.ims_sales_order_item_status_history
    WHERE
        updated_at >= @extractstart
            AND updated_at < @extractend
            AND fk_sales_order_item_status = 66) soish
    LEFT JOIN oms_live.ims_sales_order_item soi ON soish.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish1 ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish1.fk_sales_order_item IN (6 , 56)
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status) result