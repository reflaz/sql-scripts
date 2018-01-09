SELECT 
    *
FROM
    (SELECT 
        sup.id_supplier,
            ascsel.short_code,
            sup.name 'seller_name',
            sup.type 'seller_type',
            CASE
                WHEN sa.fk_country = 101 THEN 'local'
                WHEN ascsel.tax_class = 0 THEN 'local'
                WHEN ascsel.tax_class = 1 THEN 'international'
            END 'tax_class',
            sfom.origin,
            sa.fk_country_region
    FROM
        bob_live.supplier sup
    LEFT JOIN bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MAX(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL
                AND address_type IN ('warehouse'))
    LEFT JOIN bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country = sfom.fk_country
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country = sa.fk_country
                AND COALESCE(fk_country_region, sa.fk_country_region, 1) = IFNULL(sa.fk_country_region, 1)
                AND is_live = 1)
    LEFT JOIN asc_live.seller ascsel ON sup.id_supplier = ascsel.src_id) sup