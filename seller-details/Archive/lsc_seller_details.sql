/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Details

Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your Excel File
				  - If theres any apostrophe (') in the parameter, replace and add a backslash in front of it so it became like this (\')
				  - Format the parameter in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted Seller's Name in >> WHERE sel.name IN () << part of the script
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
        CONCAT('ID', sel.src_id) 'Seller ID',
            sel.short_code 'SC Seller ID',
            sel.name 'Seller Name',
            sel.name_company 'Legal Name',
            sel.tax_class 'Tax Class',
            sel.verified 'Verified',
            sel.account_status 'Account Status',
            CASE
                WHEN scon.value = '"1"' THEN 'Weekly'
                WHEN scon.value = '"2"' THEN 'Monthly'
                WHEN scon.value = '"3"' THEN 'Twice a Month'
                ELSE 'Default Setting'
            END 'Account Statement Frequency',
            sel.person_in_charge 'PIC',
            sel.email 'Email Address'
    FROM
        screport.seller sel
    LEFT JOIN screport.seller_config scon ON sel.id_seller = scon.fk_seller
        AND scon.field = 'account_statement_frequency') result