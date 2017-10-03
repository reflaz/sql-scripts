/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
BOB Rate Card KG Extract

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SELECT 
    sfrc_kg.*,
    reg.id_customer_address_region 'id_region',
    reg.name 'region',
    cty.id_customer_address_region 'id_city',
    cty.name 'city',
    dst.id_customer_address_region 'id_district',
    dst.name 'district'
FROM
    bob_live.shipping_fee_rate_card_kg sfrc_kg
        LEFT JOIN
    bob_live.customer_address_region dst ON sfrc_kg.destination_zone = dst.id_customer_address_region
        LEFT JOIN
    bob_live.customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
        LEFT JOIN
    bob_live.customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
WHERE
    is_live = 1