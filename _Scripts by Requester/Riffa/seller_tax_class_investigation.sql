SELECT 
    sel.name 'seller_name',
    sel.name_company 'company_name',
    sel.short_code,
    sel.created_at,
    sel.updated_at,
    sel.tax_class,
    sel.registration_src,
    sel.completed_registration,
    sa.street,
    sa.city,
    co.name 'country'
FROM
    screport.seller sel
        LEFT JOIN
    oms_live.ims_supplier sup ON sel.src_id = sup.bob_id_supplier
        LEFT JOIN
    oms_live.ims_supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND address_type = 'standard'
        LEFT JOIN
    oms_live.ims_country co ON sa.fk_country = co.id_country
WHERE
    sel.name IN ('')
GROUP BY sel.id_seller