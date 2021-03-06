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

SET @extractstart = '2016-01-01';
SET @extractend = '2016-07-01';

SELECT 
    delivered_date, COUNT(bob_id_sales_order_item) 'count_soi'
FROM
    (SELECT 
        DATE_FORMAT(delivered_date, '%Y-%m-%d') 'delivered_date',
            bob_id_sales_order_item
    FROM
        scglv3.anondb_calculate
    WHERE
        delivered_date >= @extractstart
            AND delivered_date < @extractend) ae
GROUP BY delivered_date