/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
API Statistics

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain_staging;

SELECT 
    *
FROM
    (SELECT 
        act.api_type,
            ad.api_date,
            ad.posting_type,
            ad.charge_type,
            ad.is_actual,
            ad.status,
            COUNT(ad.id_api_data) 'total_temporary_api_data',
            SUM(IFNULL(ad.amount, 0)) 'amount',
            SUM(IFNULL(ad.discount, 0)) 'discount',
            SUM(IFNULL(ad.tax_amount, 0)) 'tax_amount',
            SUM(IFNULL(ad.total_amount, 0)) 'total_amount',
            SUM(CASE
                WHEN ad.amount < 0 THEN 1
                ELSE 0
            END) 'wrong_amount_sign',
            SUM(CASE
                WHEN ad.discount > 0 THEN 1
                ELSE 0
            END) 'wrong_discount_sign',
            SUM(CASE
                WHEN ad.tax_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_tax_amount_sign',
            SUM(CASE
                WHEN ad.total_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_total_amount_sign',
            SUM(CASE
                WHEN TRIM(ad.package_number) = '' THEN 1
                WHEN ad.package_number IS NULL THEN 1
                ELSE 0
            END) 'missing_package_number',
            SUM(CASE
                WHEN TRIM(ad.short_code) = '' THEN 1
                WHEN ad.short_code IS NULL THEN 1
                ELSE 0
            END) 'missing_short_code'
    FROM
        api_data ad
    LEFT JOIN api_cons_type act ON ad.fk_api_type = act.id_api_type
    WHERE
        ad.created_at IS NULL
    GROUP BY api_date , posting_type , charge_type , is_actual , status) statistics;

SELECT 
    *
FROM
    (SELECT 
        act.api_type,
            ad.package_number 'missing_package_number_reference'
    FROM
        api_data ad
    LEFT JOIN api_cons_type act ON ad.fk_api_type = act.id_api_type
    LEFT JOIN tmp_item_level til ON ad.package_number = til.package_number
    WHERE
        ad.created_at IS NULL
            AND til.bob_id_sales_order_item IS NULL) mpn
GROUP BY missing_package_number_reference;