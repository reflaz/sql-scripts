USE `ma_gain_loss`;

SELECT 
    *,
    rounded_weight * shipment_rate * (1 - shipment_discount) 'charge_from_shipment_provider',
    rounded_weight * seller_charge_rate 'charge_to_seller',
    total_shipping_surcharge 'charge_to_customer',
    (rounded_weight * shipment_rate * (1 - shipment_discount)) - (rounded_weight * seller_charge_rate) - total_shipping_surcharge 'shipment_gain_loss'
FROM
    (SELECT 
        order_nr,
            bob_id_sales_order_item,
            order_date,
            shipped_date,
            delivered_date,
            total_shipping_surcharge,
            total_unit_price,
            total_paid_price,
            total_coupon_money_value,
            total_cart_rule_discount,
            coupon_code,
            cart_rule_display_names,
            sku,
            id_supplier,
            sc_seller_id,
            sd.seller_name,
            sd.seller_type,
            tax_class,
            IF(vs.seller_id IS NOT NULL
                AND sd.order_date >= vs.start_date
                AND sd.order_date < IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW()), 1, 0) 'vip_calculation',
            tracking_number,
            shipment_provider,
            sd.origin,
            sd.id_region,
            sd.region,
            sd.id_city,
            sd.city,
            sd.id_district,
            sd.district,
            IF(fz.id_district IS NOT NULL, 1, 0) 'free_zone',
            length,
            width,
            height,
            IF(shipment_provider LIKE '%MP%'
                OR shipment_provider LIKE '%FBL%'
                OR shipment_provider LIKE '%NINJA VAN%'
                OR shipment_provider LIKE '%LEX X%', 'MA', IF(shipment_provider IS NOT NULL, 'DB', NULL)) 'shipment_type',
            total_weight,
            total_volumetric_weight,
            formula_weight,
            rounded_weight,
            jr.rate 'shipment_rate',
            CASE
                WHEN
                    seller_type = 'merchant'
                        AND shipment_provider = 'JNE'
                THEN
                    0
                WHEN shipment_provider LIKE '%LEX%' THEN 0.2
                WHEN shipment_provider LIKE '%JNE%' THEN 0.3
                ELSE 0
            END 'shipment_discount',
            CASE
                WHEN seller_type = 'supplier' THEN 0
                WHEN
                    shipment_provider LIKE '%MP%'
                        OR shipment_provider LIKE '%FBL%'
                        OR shipment_provider LIKE '%NINJA VAN%'
                        OR shipment_provider LIKE '%LEX X%'
                THEN
                    (CASE
                        WHEN
                            vs.seller_id IS NOT NULL
                                AND sd.order_date >= vs.start_date
                                AND sd.order_date < IFNULL(IF(vs.end_date < vs.start_date, NULL, vs.end_date), NOW())
                        THEN
                            1000
                        WHEN shipment_provider LIKE '%LEX%' THEN 6464
                        ELSE 7000
                    END)
                ELSE 7000
            END 'seller_charge_rate'
    FROM
        (SELECT 
        *,
            IF(shipment_provider LIKE '%LEX%', CEIL(formula_weight), IF(formula_weight < 1, 1, IF(MOD(formula_weight, 1) <= 0.3, FLOOR(formula_weight), CEIL(formula_weight)))) 'rounded_weight'
    FROM
        (SELECT 
        *,
            COUNT(order_nr) 'qty',
            SUM(IFNULL(shipping_surcharge, 0)) 'total_shipping_surcharge',
            SUM(IFNULL(unit_price, 0)) 'total_unit_price',
            SUM(IFNULL(paid_price, 0)) 'total_paid_price',
            SUM(IFNULL(coupon_money_value, 0)) 'total_coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'total_cart_rule_discount',
            SUM(IFNULL(weight, 0)) 'total_weight',
            SUM(IFNULL(volumetric_weight, 0)) 'total_volumetric_weight',
            IF(SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)), SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0))) 'formula_weight'
    FROM
        oms_data
    GROUP BY id_package_dispatching , id_supplier) result) sd
    LEFT JOIN free_zone fz ON sd.id_district = fz.id_district
    LEFT JOIN jne_rate jr ON sd.origin = jr.origin
        AND sd.id_district = jr.id_district
    LEFT JOIN vip_seller vs ON sd.sc_seller_id = vs.seller_id) result;