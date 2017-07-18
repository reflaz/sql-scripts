-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-01';
SET @extractend = '2017-07-01';-- This MUST be D + 1

SELECT 
    city_temp 'city',
    zone_type,
    threshold_kg,
    threshold_order,
    pass,
    CASE
        WHEN
            threshold_order LIKE '%>=%'
                AND threshold_kg LIKE '%<%'
        THEN
            'free'
        ELSE 'paid'
    END 'is_free',
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(nmv) 'nmv',
    COUNT(DISTINCT order_nr) 'total_so',
    COUNT(DISTINCT id_package_dispatching) 'total_pck',
    SUM(qty) 'total_soi',
    SUM(unit_price) / COUNT(DISTINCT order_nr) 'aov',
    SUM(shipping_surcharge) 'total_shipping_surcharge',
    SUM(shipping_amount) 'total_shipping_amount',
    - SUM(total_delivery_cost) 'total_delivery_cost',
    SUM(total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(shipping_surcharge) + SUM(shipping_amount) + SUM(total_shipment_fee_mp_seller) - SUM(total_delivery_cost) 'net_subsidy'
FROM
    (SELECT 
        *,
            CASE
                WHEN order_value < value_threshold THEN CONCAT('< ', value_threshold)
                ELSE CONCAT('>= ', value_threshold)
            END 'threshold_order',
            CASE
                WHEN formula_weight <= rounding THEN CONCAT('<= ', rounding)
                ELSE CONCAT('> ', rounding)
            END 'threshold_kg'
    FROM
        (SELECT 
        city_temp,
            zone_type,
            id_district,
            order_nr,
            id_package_dispatching,
            origins_temp 'origin',
            pass,
            order_value,
            unit_price,
            paid_price,
            qty,
            shipping_surcharge,
            shipping_amount,
            nmv,
            total_shipment_fee_mp_seller,
            total_delivery_cost,
            simple_length,
            simple_width,
            simple_height,
            simple_weight,
            config_length,
            config_width,
            config_height,
            config_weight,
            value_threshold,
            weight_break 'rounding',
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
            END, 0)) 'formula_weight'
    FROM
        (SELECT 
        item.city 'city_temp',
            item.zone_type,
            item.id_district,
            item.order_nr,
            item.id_package_dispatching,
            item.origin 'origins_temp',
            item.order_value,
            item.pass,
            SUM(item.unit_price) 'unit_price',
            SUM(item.paid_price) 'paid_price',
            count(item.bob_id_sales_order_item) 'qty',
            SUM(shipping_surcharge_temp) 'shipping_surcharge',
            SUM(shipping_amount_temp) 'shipping_amount',
            SUM(nmv) 'nmv',
            SUM(item.total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
            SUM(item.total_delivery_cost_item) 'total_delivery_cost',
            SUM(item.simple_length) 'simple_length',
            SUM(item.simple_width) 'simple_width',
            SUM(item.simple_height) 'simple_height',
            SUM(item.simple_weight) 'simple_weight',
            SUM(item.config_length) 'config_length',
            SUM(item.config_width) 'config_width',
            SUM(item.config_height) 'config_height',
            SUM(item.config_weight) 'config_weight'
    FROM
        (SELECT 
        zm.city,
            ac.zone_type,
            ac.id_district,
            ac.order_nr,
            ac.id_package_dispatching,
            ac.bob_id_sales_order_item,
            ac.origin,
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.qty,
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            ac.simple_length,
            ac.simple_width,
            ac.simple_height,
            ac.simple_weight,
            ac.config_length,
            ac.config_width,
            ac.config_height,
            ac.config_weight,
            CASE
                WHEN chargeable_weight_3pl / qty > 400 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge_temp',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount_temp',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv'
    FROM
        scglv3.anondb_calculate ac
    LEFT JOIN scglv3.zone_mapping zm ON ac.id_district = zm.id_district
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= zm.end_date
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme in ('RETAIL','FBL','DIRECT BILLING','MASTER ACCOUNT')) item
    GROUP BY item.order_nr , item.id_package_dispatching) package_lv
    LEFT JOIN scglv3.shipping_fee_rate_card sfrc ON package_lv.id_district = sfrc.destination_zone
        AND sfrc.origin = package_lv.origins_temp
        and sfrc.charging_level = 'Source'
        and sfrc.threshold_level = 'Source'
        and sfrc.leadtime = 'Standard'
        and sfrc.fee_type = 'FIX'
    LEFT JOIN scglv3.shipping_fee_rate_card_kg sfrck ON package_lv.id_district = sfrck.destination_zone
        AND sfrck.origin = package_lv.origins_temp
        and sfrck.leadtime = 'Standard'
        AND sfrck.id_shipping_fee_rate_card_kg = (SELECT 
            MIN(sfrc_kg.id_shipping_fee_rate_card_kg)
        FROM
            scglv3.shipping_fee_rate_card_kg sfrc_kg
        WHERE
            sfrc_kg.destination_zone = package_lv.id_district
                AND sfrc_kg.origin = package_lv.origins_temp)) calc
    WHERE
        (formula_weight / qty) <= 400) city_lv
GROUP BY city_temp , zone_type , threshold_kg , threshold_order
HAVING pass = 1