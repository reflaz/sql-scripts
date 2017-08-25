/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller ASF Details

Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your Excel File
				  - Format the parameter in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameter
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    sel.src_id 'bob_id_supplier',
    sel.short_code,
    sel.name 'seller_name',
    CASE
        WHEN sel.tax_class = 0 THEN 'local'
        WHEN sel.tax_class = 1 THEN 'international'
    END 'tax_class',
    CASE
        WHEN MAX(sfee.id_seller_fee) IS NOT NULL THEN 'Master Account'
        ELSE 'Direct Billing'
    END 'seller_type'
FROM
    asc_live.seller sel
        LEFT JOIN
    asc_live.seller_fee sfee ON sel.id_seller = sfee.fk_seller
        AND sfee.fk_fee IN (173)
        AND sfee.value = 0
        LEFT JOIN
    asc_live.fee ON sfee.fk_fee = fee.id_fee
WHERE
    sel.short_code IS NOT NULL
        AND sel.tax_class = 0
        AND sel.account_status = 1
        AND sel.verified = 1
GROUP BY sel.src_id