
SELECT 
    result.*, zt.zone_type
FROM
    (SELECT 
        *,
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0) 'weight',
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'volumetric_weight',
            GREATEST(IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0), IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0)) 'formula_weight',
            CASE
                WHEN tax_class = 'international' THEN 'CB'
                WHEN delivery_type = 'digital' THEN 'digital'
                WHEN
                    first_shipment_provider = 'Digital Delivery'
                        OR last_shipment_provider = 'Digital Delivery'
                THEN
                    'digital'
                WHEN
                    delivery_type IN ('express' , 'nextday', 'sameday')
                        AND last_shipment_provider LIKE '%Go-Jek%'
                THEN
                    'gojek'
                WHEN is_marketplace = 0 THEN 'retail'
                WHEN shipping_type = 'warehouse' THEN 'fbl'
                WHEN
                    first_shipment_provider = 'Acommerce'
                        AND last_shipment_provider = 'Acommerce'
                THEN
                    'db'
                WHEN
                    payment_method <> 'CashOnDelivery'
                        AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                        AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                THEN
                    'db'
                ELSE 'ma'
            END 'shipment_scheme'
    FROM
        scgl.anondb_extract
    HAVING formula_weight <= 400
        AND shipment_scheme IN ('db' , 'ma', 'fbl', 'retail')) result
        LEFT JOIN
    free_zone fz ON result.id_district = fz.id_district
        LEFT JOIN
    zone_type zt ON fz.fk_zone_type = zt.id_zone_type
WHERE
    formula_weight > 2
        AND shipping_surcharge = 0