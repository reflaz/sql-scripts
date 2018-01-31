/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Tax Invoice Automation System - Commission Return

Prepared by		: R Maliangkay
Modified by		: 
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
SET @extractstart = '2017-11-01';
SET @extractend = '2017-12-01';-- This MUST be D + 1

SELECT 
    *
FROM
    (SELECT 
        IFNULL(sd.legal_name, '') 'legal_name',
            IFNULL(sd.seller_name, '') 'seller_name',
            CASE
                WHEN tmp_data LIKE '%"name":"%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(sd.tmp_data, '"name":"', - 1), '","', 1)
                ELSE ''
            END 'first_and_last_name',
            CASE
                WHEN tmp_data LIKE '%"business_reg_number":"%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(sd.tmp_data, '"business_reg_number":"', - 1), '","', 1)
                ELSE ''
            END 'business_reg_number',
            IFNULL(IF(TRIM(sd.vat_number) = 'null'
                OR TRIM(sd.vat_number) = '', '00.000.000.0-000.000', TRIM(sd.vat_number)), '00.000.000.0-000.000') 'vat_number',
            CASE
                WHEN tmp_data LIKE '%"customercare_address1":"%' THEN CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(sd.tmp_data, 'customercare_address1":"', - 1), '","', 1), ', ', SUBSTRING_INDEX(SUBSTRING_INDEX(sd.tmp_data, 'customercare_city":"', - 1), '","', 1), ' ', SUBSTRING_INDEX(SUBSTRING_INDEX(sd.tmp_data, 'customercare_postcode":"', - 1), '","', 1))
                ELSE ''
            END 'address',
            IFNULL(sd.email, '') 'email',
            result.*
    FROM
        (SELECT 
        delivered_month,
            transaction_type,
            SUM(amount_paid_to_seller) 'amount_paid_to_seller',
            SUM(amount_subjected_to_tax) 'amount_subjected_to_tax',
            SUM(tax_amount) 'tax_amount',
            IFNULL(tr.bob_id_supplier, '') 'bob_id_supplier'
    FROM
        (SELECT 
        *,
            IFNULL(value, 0) 'amount_paid_to_seller',
            - IFNULL(value, 0) / 1.1 'amount_subjected_to_tax',
            - IFNULL(value, 0) + (IFNULL(value, 0) / 1.1) 'tax_amount',
            CASE
                WHEN
                    transaction_type IN ('Commission Credit' , 'Reversal Commission', '')
                        AND delivered_date < @extractstart
                THEN
                    1
                WHEN
                    transaction_type IN ('Commission Credit' , 'Reversal Commission', '')
                        AND delivered_date IS NULL
                THEN
                    1
                ELSE 0
            END 'pass',
            DATE_FORMAT(delivered_date, '%Y-%m') 'delivered_month'
    FROM
        tias_java.transaction
    HAVING pass = 1) tr
    GROUP BY delivered_month , bob_id_supplier , transaction_type
    HAVING bob_id_supplier IS NOT NULL) result
    LEFT JOIN tias_java.seller_details sd ON result.bob_id_supplier = sd.bob_id_supplier) result