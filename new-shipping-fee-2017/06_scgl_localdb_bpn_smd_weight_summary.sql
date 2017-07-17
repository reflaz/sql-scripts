SELECT 
    id_region,
    region,
    id_city,
    city_name 'city',
    weight_bucket,
    SUM(paid_price) paid_price,
    COUNT(DISTINCT order_nr) 'count_so',
    SUM(qty) 'count_soi',
    SUM(gain_loss) 'gain_loss'
FROM
    (SELECT 
        rc.id_region,
            rc.region,
            rc.id_city,
            rc.city 'city_name',
            ac.*,
            CASE
                WHEN ac.formula_weight <= 0.17 THEN '<= 0.17'
                WHEN ac.rounded_weight < 3 THEN '1-2 Kg'
                WHEN ac.rounded_weight < 4 THEN '3 Kg'
                WHEN ac.rounded_weight < 5 THEN '4 Kg'
                WHEN ac.rounded_weight < 6 THEN '5 Kg'
                WHEN ac.rounded_weight < 7 THEN '6 Kg'
                WHEN ac.rounded_weight < 8 THEN '7 Kg'
                ELSE '8 Kg and above'
            END 'weight_bucket',
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost 'gain_loss'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN scgl.rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    WHERE
        ac.order_date >= '2016-11-30'
        AND ac.order_date < '2016-12-05'
            AND ac.fk_shipment_scheme IN (1 , 2, 3, 4)
            AND rc.id_city IN (3950 , 3939)) result
GROUP BY id_city , weight_bucket