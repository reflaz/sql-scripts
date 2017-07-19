/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Pricing Subsidy Dashboard by Date by SKU
 
Prepared by		: RM
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractstart for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2016-10-21';
SET @extractend = '2017-01-01';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        bob_id_supplier,
            short_code,
            seller_name,
            tax_class,
            sku,
            period,
            COUNT(DISTINCT count_so) count_so,
            COUNT(count_soi) count_soi,
            SUM(temp_unit_price) sum_unit_price,
            SUM(temp_paid_price) sum_paid_price
    FROM
        (SELECT 
        order_nr,
            bob_id_sales_order_item,
            sku,
            unit_price,
            paid_price,
            order_date,
            bob_id_supplier,
            short_code,
            seller_name,
            tax_class,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN '2016-10-21 - 2016-12-01'
            END AS period,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN order_nr
            END AS count_so,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN bob_id_sales_order_item
            END AS count_soi,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN unit_price
            END AS temp_unit_price,
            CASE
                WHEN order_date >= '2016-10-21' and order_date < '2016-12-01' and sku = 'AC016ELAA57M8DANID-10481220' THEN paid_price
            END AS temp_paid_price
    FROM
		scglv3.anondb_calculate
    WHERE
		order_date >= @extractstart
            AND order_date < @extractend
			AND sku IN ()
    GROUP BY bob_id_sales_order_item
    HAVING period IS NOT NULL) result
    GROUP BY sku , period) result