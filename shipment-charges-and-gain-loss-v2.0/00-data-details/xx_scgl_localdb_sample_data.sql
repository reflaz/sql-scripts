SELECT 
    *,
    total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost 'gain_loss'
FROM
    scgl.anondb_calculate
WHERE
    fk_shipment_scheme IN (1 , 2, 3, 4, 7)
		AND rounded_weight <= 400
        AND shipping_fee_to_customer IS NOT NULL
        AND order_date < '2017-01-01'
LIMIT 100000;

SELECT 
    *,
    total_shipment_fee_mp_seller + shipping_fee_to_customer - total_delivery_cost 'gain_loss'
FROM
    scgl.anondb_calculate
WHERE
    fk_shipment_scheme IN (1 , 2, 3, 4, 7)
		AND rounded_weight <= 400
        AND shipping_fee_to_customer IS NOT NULL
        AND order_date >= '2017-01-01'
LIMIT 100000;