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

USE refrain;

SELECT 
    *
FROM
    (SELECT 
        'api_data_direct_billing' AS 'api_type',
            api_date,
            posting_type,
            charge_type,
            is_actual,
            status,
            COUNT(*) 'total_temporary_api_data',
            SUM(IFNULL(amount, 0)) 'amount',
            SUM(IFNULL(discount, 0)) 'discount',
            SUM(IFNULL(tax_amount, 0)) 'tax_amount',
            SUM(IFNULL(total_amount, 0)) 'total_amount',
            SUM(CASE
                WHEN amount < 0 THEN 1
                ELSE 0
            END) 'wrong_amount_sign',
            SUM(CASE
                WHEN discount > 0 THEN 1
                ELSE 0
            END) 'wrong_discount_sign',
            SUM(CASE
                WHEN tax_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_tax_amount_sign',
            SUM(CASE
                WHEN total_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_total_amount_sign',
            SUM(CASE
                WHEN TRIM(package_number) = '' THEN 1
                WHEN package_number IS NULL THEN 1
                ELSE 0
            END) 'missing_package_number',
            SUM(CASE
                WHEN TRIM(short_code) = '' THEN 1
                WHEN short_code IS NULL THEN 1
                ELSE 0
            END) 'missing_short_code'
    FROM
        api_data_direct_billing
    WHERE
        created_at IS NULL
    GROUP BY api_date , posting_type , charge_type , is_actual , status UNION ALL SELECT 
        'api_data_master_account',
            api_date,
            posting_type,
            charge_type,
            is_actual,
            status,
            COUNT(*) 'total_temporary_api_data',
            SUM(IFNULL(amount, 0)) 'amount',
            SUM(IFNULL(discount, 0)) 'discount',
            SUM(IFNULL(tax_amount, 0)) 'tax_amount',
            SUM(IFNULL(total_amount, 0)) 'total_amount',
            SUM(CASE
                WHEN amount < 0 THEN 1
                ELSE 0
            END) 'wrong_amount_sign',
            SUM(CASE
                WHEN discount > 0 THEN 1
                ELSE 0
            END) 'wrong_discount_sign',
            SUM(CASE
                WHEN tax_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_tax_amount_sign',
            SUM(CASE
                WHEN total_amount < 0 THEN 1
                ELSE 0
            END) 'wrong_total_amount_sign',
            SUM(CASE
                WHEN TRIM(package_number) = '' THEN 1
                WHEN package_number IS NULL THEN 1
                ELSE 0
            END) 'missing_package_number',
            SUM(CASE
                WHEN TRIM(short_code) = '' THEN 1
                WHEN short_code IS NULL THEN 1
                ELSE 0
            END) 'missing_short_code'
    FROM
        api_data_master_account
    WHERE
        created_at IS NULL
    GROUP BY api_date , posting_type , charge_type , is_actual , status) statistics;

SELECT 
    *
FROM
    (SELECT 
        addb.package_number 'missing_package_number_reference'
    FROM
        api_data_direct_billing addb
    LEFT JOIN tmp_item_level til ON addb.package_number = til.package_number
    WHERE
        til.bob_id_sales_order_item IS NULL UNION ALL SELECT 
        adma.package_number 'missing_package_number_reference'
    FROM
        api_data_master_account adma
    LEFT JOIN tmp_item_level til ON adma.package_number = til.package_number
    WHERE
        til.bob_id_sales_order_item IS NULL) mpn
GROUP BY missing_package_number_reference;