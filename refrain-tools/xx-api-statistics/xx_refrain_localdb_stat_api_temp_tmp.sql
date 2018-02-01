/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
API Statistics - Temporary API to New ANON DB Data

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain_live;

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
            SUM(IFNULL(ad.formula_weight, 0)) 'formula_weight',
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
    GROUP BY fk_api_type , api_date , posting_type , charge_type , is_actual , is_marketplace , status) statistics;

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

SELECT 
    *
FROM
    (SELECT 
        act.api_type,
            ad.api_date,
            ad.posting_type,
            ad.charge_type,
            ad.is_actual,
            ad.package_number,
            ad.short_code,
            CASE
                WHEN ad.is_marketplace <> til.is_marketplace THEN 1
                WHEN IFNULL(ad.tax_class, 'tax_class') <> COALESCE(til.tax_class, ad.tax_class, 'tax_class') THEN 1
                ELSE 0
            END 'wrong_bu'
    FROM
        api_data ad
    JOIN api_cons_type act ON ad.fk_api_type = act.id_api_type
    JOIN tmp_item_level til ON ad.package_number = til.package_number
        AND IFNULL(ad.short_code, 'short_code') = COALESCE(til.short_code, ad.short_code, 'short_code')
    WHERE
        ad.created_at IS NULL
    GROUP BY ad.fk_api_type , ad.api_date , ad.posting_type , ad.charge_type , ad.is_actual , ad.package_number , ad.short_code
    HAVING wrong_bu > 1) wrong_bu