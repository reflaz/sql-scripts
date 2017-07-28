/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Data Check

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

SET @extractstart = '2016-01-01';
SET @extractend = '2016-07-01';

SELECT 
    first_shipped_date,
    COUNT(bob_id_sales_order_item) 'count_soi'
FROM
    (SELECT 
        DATE_FORMAT(first_shipped_date, '%Y-%m-%d') 'first_shipped_date',
            bob_id_sales_order_item
    FROM
        anondb_calculate
    WHERE
        first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend) ae
GROUP BY first_shipped_date