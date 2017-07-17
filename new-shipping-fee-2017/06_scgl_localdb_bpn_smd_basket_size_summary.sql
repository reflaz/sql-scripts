SELECT 
    id_region,
    region,
    id_city,
    city_name 'city',
    basket_size_bucket,
    SUM(paid_price) paid_price,
    COUNT(DISTINCT order_nr) 'count_so',
    SUM(qty) 'count_soi',
    SUM(gain_loss) 'gain_loss'
FROM
    (SELECT 
        *,
            CASE
                WHEN basket_size < 30000 THEN 'Below IDR 30K'
                WHEN basket_size < 50000 THEN 'IDR 30K - 50K'
                WHEN basket_size < 100000 THEN 'IDR 50K - 100K'
                WHEN basket_size < 200000 THEN 'IDR 100K - 200K'
                WHEN basket_size < 500000 THEN 'IDR 200K - 500K'
                WHEN basket_size < 1000000 THEN 'IDR 500K - 1M'
                ELSE '1M and over'
            END 'basket_size_bucket'
    FROM
        (SELECT 
        rc.id_region,
            rc.region,
            rc.id_city,
            rc.city 'city_name',
            ac.*,
            (SELECT 
                    SUM(unit_price)
                FROM
                    anondb_calculate
                WHERE
                    order_nr = ac.order_nr) 'basket_size',
            ac.total_shipment_fee_mp_seller + ac.shipping_fee_to_customer - ac.total_delivery_cost 'gain_loss'
    FROM
        scgl.anondb_calculate ac
    LEFT JOIN scgl.rate_card rc ON ac.id_district = rc.id_district
        AND ac.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1
    WHERE
        ac.order_date >= '2016-12-19'
            AND ac.order_date < '2016-12-21'
            AND ac.fk_shipment_scheme IN (1 , 2, 3, 4)
            AND rc.id_city IN (3950 , 3939)) result) result
GROUP BY id_city, basket_size_bucket