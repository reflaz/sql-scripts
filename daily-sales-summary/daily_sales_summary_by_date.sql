/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Daily Sales Summary

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
SET @extractstart = '2017-03-01';
SET @extractend = '2017-03-05';-- This MUST be D + 1

SELECT 
    order_date,
    business_unit,
    COUNT(DISTINCT order_nr) 'count_so',
    COUNT(bob_id_sales_order_item) 'count_soi',
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(shipping_amount) 'total_shipping_amount',
    SUM(shipping_surcharge) 'total_shipping_surcharge',
    SUM(coupon_money_value) 'total_coupon_money_value'
FROM
    (SELECT 
        so.order_nr,
            soi.bob_id_sales_order_item,
            CASE
                WHEN soi.is_marketplace = 0 THEN 'Retail'
                ELSE 'MP'
            END 'business_unit',
            verified.created_at AS ovip_date,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.coupon_money_value,
            DATE_FORMAT(so.created_at, '%Y-%m-%d') 'order_date'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    JOIN oms_live.ims_sales_order_item_status_history verified ON soi.id_sales_order_item = verified.fk_sales_order_item
        AND verified.fk_sales_order_item_status = 69
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend) so
GROUP BY order_date , business_unit