SELECT 
    sfrc.origin,
    mapping.*,
    sfrc.leadtime,
    sfrc.rounding,
    sfrc.weight_break,
    sfrc.flat_rate,
    sfrc.step_rate,
    sfrc.is_live
FROM
    (SELECT 
        reg.id_customer_address_region 'id_region',
            reg.name 'region',
            cty.id_customer_address_region 'id_city',
            cty.name 'city',
            dst.id_customer_address_region 'id_district',
            dst.name 'district'
    FROM
        bob_live.customer_address_region reg
    LEFT JOIN bob_live.customer_address_region cty ON reg.id_customer_address_region = cty.fk_customer_address_region
    LEFT JOIN bob_live.customer_address_region dst ON cty.id_customer_address_region = dst.fk_customer_address_region
    WHERE
        reg.fk_customer_address_region IS NULL
            AND cty.id_customer_address_region IS NOT NULL
    GROUP BY dst.id_customer_address_region) mapping
        LEFT JOIN
    bob_live.shipping_fee_rate_card_kg sfrc ON mapping.id_district = sfrc.destination_zone
WHERE
    sfrc.is_live = 1
        AND sfrc.origin <> 'Cross Border'