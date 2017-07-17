SELECT 
    sfrc.origin,
    reg.id_customer_address_region 'id_region',
    reg.name 'region',
    cty.id_customer_address_region 'id_city',
    cty.name 'city',
    dst.id_customer_address_region 'id_district',
    dst.name 'district',
    sfrc.rounding,
    sfrc.weight_break,
    sfrc.flat_rate,
    sfrc.step_rate,
    is_live
FROM
    bob_live.customer_address_region cty
        LEFT JOIN
    bob_live.customer_address_region dst ON cty.id_customer_address_region = dst.fk_customer_address_region
        LEFT JOIN
    bob_live.customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
        LEFT JOIN
    bob_live.shipping_fee_rate_card_kg sfrc ON dst.id_customer_address_region = sfrc.destination_zone
WHERE
    cty.id_customer_address_region IN ('')
        AND sfrc.origin <> 'Cross Border'
        AND is_live = 1
        -- AND weight_break > 7