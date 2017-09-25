/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker by City Tier Mapping
 
Prepared by		: Ryan Disastra
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-08-14';
SET @extractend = '2017-08-16';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        bu,
            SUM(IF(is_delivered = 1, IFNULL(total_delivery_cost_item, 0), 0)) 'outbound'
    FROM
        (SELECT 
        *,
            IF(order_date >= @extractstart
                AND order_date < @extractend, 1, 0) 'is_ordered',
            IF(first_shipped_date >= @extractstart
                AND first_shipped_date < @extractend, 1, 0) 'is_shipped',
            IF(delivered_date >= @extractstart
                AND delivered_date < @extractend, 1, 0) 'is_delivered',
            IF(not_delivered_date >= @extractstart
                AND not_delivered_date < @extractend, 1, 0) 'is_not_delivered',
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN (shipping_amount + shipping_surcharge) > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN shipment_scheme = 'FBL' THEN 'MASTER ACCOUNT'
                ELSE shipment_scheme
            END 'bu'
    FROM
        scglv3.anondb_calculate
    WHERE
        ((delivered_date >= @extractstart
            AND delivered_date < @extractend)
            OR (not_delivered_date >= @extractstart
            AND not_delivered_date < @extractend)
            OR (first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend)
            OR (order_date >= @extractstart
            AND order_date < @extractend))
            AND shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) result
    GROUP BY bu) result