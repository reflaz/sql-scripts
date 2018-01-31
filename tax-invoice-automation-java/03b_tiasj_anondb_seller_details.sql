/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Tax Invoice Automation System - Seller Details

Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
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
            sel.email,
            sel.tmp_data,
            sel.updated_at
    FROM
        asc_live.seller sel
    WHERE
        sel.src_id IN ()
    GROUP BY sel.src_id) sc;