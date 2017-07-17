SELECT 
    sfom.origin 'origin',
    cr.name 'region',
    sa.city,
    COUNT(sel.id_seller) 'seller_count'
FROM
    screport.seller sel
        LEFT JOIN
    bob_live.supplier sup ON sel.src_id = sup.id_supplier
        LEFT JOIN
    bob_live.supplier_address sa ON sup.id_supplier = sa.fk_supplier
        AND sa.id_supplier_address = (SELECT 
            MIN(id_supplier_address)
        FROM
            bob_live.supplier_address
        WHERE
            fk_supplier = sup.id_supplier
                AND fk_country_region IS NOT NULL)
        LEFT JOIN
    bob_live.country_region cr ON sa.fk_country_region = cr.id_country_region
        LEFT JOIN
    bob_live.shipping_fee_origin_mapping sfom ON sa.fk_country_region = sfom.fk_country_region
        AND sfom.id_shipping_fee_origin_mapping = (SELECT 
            MAX(id_shipping_fee_origin_mapping)
        FROM
            bob_live.shipping_fee_origin_mapping
        WHERE
            fk_country_region = sa.fk_country_region)
WHERE
    sel.verified = 1
        AND sel.account_status = 1
GROUP BY sfom.origin