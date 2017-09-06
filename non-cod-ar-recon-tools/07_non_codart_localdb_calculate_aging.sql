/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
COD AR Recon For Calculate Aging
 
Prepared by		: Michael Julius
Modified by		: MJ

Changes made	: 

Instructions	: - Change @outstanding for a specific date before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @outstanding = '2017-06-05';

SELECT 
    *
FROM
    (SELECT 
            payment_method,
            SUM(IF(aging <= 7, total_paid_by_customer, 0)) AS 'indue',
            SUM(IF(aging > 7, total_paid_by_customer, 0)) AS 'overdue',
            SUM(IF(aging <= 7, total_paid_by_customer, 0)) AS '0 - 7 Days',
            SUM(IF(aging > 7 AND aging <= 14, total_paid_by_customer, 0)) '8 - 14 Days',
            SUM(IF(aging > 14 AND aging <= 30, total_paid_by_customer, 0)) '15 - 30 Days',
            SUM(IF(aging > 30, total_paid_by_customer, 0)) '> 30 Days',
            SUM(total_paid_by_customer) AS total
    FROM
        (SELECT 
            payment_method,
            SUM(total_paid_by_customer) total_paid_by_customer,
            DATEDIFF(@outstanding, ovip_date) aging
    FROM
        non_cod_recon.ar_outstanding
    GROUP BY payment_method , aging) fin
    GROUP BY payment_method) result