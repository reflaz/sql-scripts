SELECT 
    reg.id_customer_address_region 'id_region',
    reg.name 'region',
    cty.id_customer_address_region 'id_city',
    cty.name 'city',
    dst.id_customer_address_region 'id_district',
    dst.name 'district'
FROM
    oms_live.ims_customer_address_region dst
        LEFT JOIN
    oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
        LEFT JOIN
    oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
WHERE
    cty.name IN ('')