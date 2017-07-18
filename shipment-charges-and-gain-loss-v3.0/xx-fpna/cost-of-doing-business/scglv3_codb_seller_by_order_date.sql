/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Cost of Doing Business

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

-- Cross Border Rate
SET @cbrate = -2161.67824846249000;

SELECT 
    *,
    CASE
        WHEN chargeable_weight_3pl / qty > 400 THEN 0
        WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
        ELSE 1
    END 'pass'
FROM
    scglv3.anondb_calculate
WHERE
    order_date >= @extractstart
        AND order_date < @extractend
        AND tax_class IN ('local' , 'international')
HAVING pass = 1