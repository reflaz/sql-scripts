/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Summary

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
SET @extractend = '2017-02-20';-- This MUST be D + 1

SET @unit_price_threshold = '50000';

SELECT 
    SUM(unit_price) 'total_unit_price',
    COUNT(order_nr) 'count_so',
    SUM(cart_rule_discount) 'total_cart_rule',
    SUM(coupon_money_value) 'total_coupon'
FROM
    scgl.anondb_extract
WHERE
    order_date >= @extractstart
        AND order_date < @extractend
        AND unit_price > @unit_price_threshold