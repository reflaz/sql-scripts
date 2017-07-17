SELECT 
    sel.name 'Seller Name',
    sel.name_company 'Legal Name',
    sel.vat_number 'NPWP No',
    sa.street 'Address',
    sa.city 'City',
    sa.postcode 'Postcal Code',
    bsa.contact_name 'PIC',
    sel.email 'Email Address'
FROM
    screport.seller sel
        LEFT JOIN
    bob_live.supplier sup ON sel.src_id = sup.id_supplier
        LEFT JOIN
    bob_live.supplier_address bsa ON sup.id_supplier = bsa.fk_supplier
		AND bsa.address_type = 'customercare'
        LEFT JOIN
    oms_live.ims_supplier_address sa ON bsa.id_supplier_address = sa.bob_id_supplier_address
WHERE
    sel.name IN ('')
GROUP BY sel.id_seller