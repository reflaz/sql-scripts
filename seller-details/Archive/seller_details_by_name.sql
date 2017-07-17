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
        sup.name 'Seller Name',
            sup.name_company 'Legal Name',
            sup.vat_number 'NPWP No',
            sa.address1 'BOB Address',
            sa.city 'BOB City',
            sa.postcode 'BOB Postal Code',
            sa.contact_name 'BOB PIC',
            sa.contact_email 'BOB Email Address',
            osa.street 'OMS Address',
            osa.city 'OMS City',
            osa.postcode 'OMS Postal Code',
            osa.contact_name 'OMS PIC',
            osa.contact_email 'OMS Email Address',
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_address1":"', - 1), '"', 1) 'SC Address',
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_city":"', - 1), '"', 1) 'SC City',
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_postcode":"', - 1), '"', 1) 'SC Postal Code',
            sel.person_in_charge 'SC PIC',
            sel.email 'SC Email Address'
    FROM
        screport.seller sel
    LEFT JOIN bob_live.supplier sup ON sup.id_supplier = sel.src_id
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND address_type = 'customercare')
    LEFT JOIN oms_live.ims_supplier_address osa ON sa.id_supplier_address = osa.bob_id_supplier_address
        AND osa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            oms_live.ims_supplier_address
        WHERE
            bob_id_supplier_address = sa.id_supplier_address)
    WHERE
        sel.name IN ()) result