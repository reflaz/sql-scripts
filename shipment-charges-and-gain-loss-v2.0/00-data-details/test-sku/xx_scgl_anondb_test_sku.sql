SELECT 
    *,
    IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END,
            0) 'chargeable_weight',
    IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END,
            0) 'chargeable_volumetric_weight',
    CASE
        WHEN tax_class = 'international' THEN 'CB'
        WHEN delivery_type = 'digital' THEN 0
        WHEN
            first_shipment_provider = 'Digital Delivery'
                OR last_shipment_provider = 'Digital Delivery'
        THEN
            0
        WHEN
            delivery_type IN ('express' , 'nextday', 'sameday')
                AND last_shipment_provider LIKE '%Go-Jek%'
        THEN
            'GO-JEK'
        WHEN is_marketplace = 0 THEN 'RETAIL'
        WHEN shipping_type = 'warehouse' THEN 'FBL'
        WHEN
            first_shipment_provider = 'Acommerce'
                AND last_shipment_provider = 'Acommerce'
        THEN
            'DIRECT BILLING'
        WHEN
            payment_method <> 'CashOnDelivery'
                AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
        THEN
            'DIRECT BILLING'
        ELSE 'MASTER ACCOUNT'
    END 'business_unit'
FROM
    scgl.anondb_extract ae
GROUP BY sku
HAVING business_unit IN ('DIRECT BILLING' , 'MASTER ACCOUNT', 'FBL', 'RETAIL')