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
SET @outstanding = '2017-01-23';

SELECT 
    *
FROM
    (SELECT 
        id_shipment_provider,
            shipment_provider_name,
            SUM(IF(aging <= 7, total_paid_by_customer, 0)) AS 'indue',
            SUM(IF(aging > 7, total_paid_by_customer, 0)) AS 'overdue',
            SUM(IF(aging <= 7, total_paid_by_customer, 0)) AS '0 - 7 Days',
            SUM(IF(aging > 7 AND aging <= 14, total_paid_by_customer, 0)) '8 - 14 Days',
            SUM(IF(aging > 14 AND aging <= 30, total_paid_by_customer, 0)) '15 - 30 Days',
            SUM(IF(aging > 30, total_paid_by_customer, 0)) '> 30 Days',
            SUM(total_paid_by_customer) AS total
    FROM
        (SELECT 
        id_shipment_provider,
            shipment_provider_name,
            SUM(total_paid_by_customer) total_paid_by_customer,
            DATEDIFF(@outstanding, delivered_date) aging
    FROM
        cod_ar_recon.ar_outstanding
    GROUP BY id_shipment_provider , shipment_provider_name , aging) fin
    GROUP BY id_shipment_provider , shipment_provider_name) result