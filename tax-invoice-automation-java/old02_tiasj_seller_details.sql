/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Tax Invoice Automation System - Seller Details

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

SELECT 
    *
FROM
    (SELECT 
        sel.src_id 'bob_id_supplier',
            sel.id_seller 'sc_id_seller',
            sel.short_code 'sc_short_code',
            sel.name_company 'legal_name',
            sel.name 'seller_name',
            CASE
                WHEN sel.tax_class = 0 THEN 'local'
                WHEN sel.tax_class = 1 THEN 'international'
            END 'tax_class',
            sel.vat_number,
            CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_address1":"', - 1), '","', 1), ', ', SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_city":"', - 1), '","', 1), ' ', SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_postcode":"', - 1), '","', 1)) 'address',
            sel.email,
            sel.updated_at
    FROM
        asc_live.seller sel
    WHERE
        sel.src_id IN ()
    GROUP BY sel.src_id) sc;