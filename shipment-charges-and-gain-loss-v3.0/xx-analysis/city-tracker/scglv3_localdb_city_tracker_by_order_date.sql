/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
City Tracker by Order Date
 
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
SET @extractstart = '2017-06-03';
SET @extractend = '2017-06-06';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        *,
            IFNULL(ac.paid_price / 1.1, 0) + IFNULL(ac.shipping_surcharge / 1.1, 0) + IFNULL(ac.shipping_amount / 1.1, 0) + IF(ac.coupon_type <> 'coupon', IFNULL(ac.coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        scglv3.anondb_calculate ac
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend) ae