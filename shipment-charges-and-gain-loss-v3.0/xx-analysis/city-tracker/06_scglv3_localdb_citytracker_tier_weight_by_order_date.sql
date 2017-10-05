/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
City Tracker by Tier Mapping
 
Prepared by		: Ryan Disastra
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-07-29';
SET @extractend = '2017-08-01';-- This MUST be D + 1

SELECT 
    fin.city_temp 'city',
    fin.zone_type,
    tier,
    threshold_kg,
    threshold_order,
    IF(step_rate = 0
            AND threshold_order LIKE '%>=%',
        'free',
        'paid') 'is_free',
	sum(fin.formula_weight) 'formula_weight',
    SUM(fin.unit_price) 'total_unit_price',
    SUM(fin.paid_price) 'total_paid_price',
    SUM(fin.nmv) 'nmv',
    COUNT(DISTINCT fin.order_nr) 'total_so',
    COUNT(DISTINCT fin.id_package_dispatching) 'total_pck',
    SUM(fin.qty) 'total_soi',
    SUM(fin.unit_price) / COUNT(DISTINCT fin.order_nr) 'aov',
    SUM(fin.shipping_surcharge) 'total_shipping_surcharge',
    SUM(fin.shipping_amount) 'total_shipping_amount',
    SUM(fin.total_delivery_cost) 'total_delivery_cost',
    SUM(fin.total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(fin.shipping_surcharge) + SUM(fin.shipping_amount) + SUM(fin.total_shipment_fee_mp_seller) + SUM(fin.total_delivery_cost) 'net_subsidy'
FROM
    (SELECT 
        city.*,
            CASE
                WHEN order_value < value_threshold THEN CONCAT('< ', value_threshold)
                ELSE CONCAT('>= ', value_threshold)
            END 'threshold_order',
            CASE
                WHEN formula_weight <= (rounding + 0.3) THEN CONCAT('<= ', (rounding + 0.3))
                ELSE CONCAT('> ', (rounding + 0.3))
            END 'threshold_kg'
    FROM
        (SELECT 
        package.*,
            value_threshold,
            weight_break,
            step_rate,
            sfrck.id_shipping_fee_rate_card_kg 'sfrck',
            maks.id_shipping_fee_rate_card_kg 'maks',
            maks.max_weight_break,
            IF(weight_break = 999999, maks.max_weight_break, weight_break) 'rounding'
    FROM
        (SELECT 
        pack.*, least(GREATEST(weight, volumetric_weight),999999) 'formula_weight'
    FROM
        (SELECT 
        order_nr,
            id_package_dispatching,
            zone_type_temp 'zone_type',
            id_district_temp,
            id_city,
            city_temp,
            tier,
            COUNT(bob_id_sales_order_item) 'qty',
            origin_temp,
            order_value,
            SUM(unit_price) 'unit_price',
            SUM(paid_price) 'paid_price',
            SUM(total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
            SUM(total_delivery_cost_item) 'total_delivery_cost',
            SUM(shipping_surcharge_temp) 'shipping_surcharge',
            SUM(shipping_amount_temp) 'shipping_amount',
            SUM(nmv) 'nmv',
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight'
    FROM
        (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.zone_type 'zone_type_temp',
            ac.id_district 'id_district_temp',
            zm.id_city 'id_city',
            zm.city 'city_temp',
            tm.tier 'tier',
            ac.bob_id_sales_order_item,
            ac.origin 'origin_temp',
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
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
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
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
            END, 0) 'volumetric_weight'
    FROM
        anondb_calculate ac
    LEFT JOIN zone_mapping zm ON ac.id_district = zm.id_district
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= zm.end_date
	LEFT JOIN tier_mapping tm ON ac.id_district = tm.id_district
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) item
    GROUP BY order_nr , id_package_dispatching) pack) package
    LEFT JOIN shipping_fee_rate_card sfrc ON package.id_district_temp = sfrc.destination_zone
        AND sfrc.origin = package.origin_temp
        AND sfrc.charging_level = 'Source'
        AND sfrc.threshold_level = 'Source'
        AND sfrc.leadtime = 'Standard'
        AND sfrc.fee_type = 'FIX'
        AND sfrc.product_class = 'A'
    LEFT JOIN shipping_fee_rate_card_kg sfrck ON package.id_district_temp = sfrck.destination_zone
        AND sfrck.origin = package.origin_temp
        AND sfrck.leadtime = 'Standard'
        AND sfrck.id_shipping_fee_rate_card_kg = (SELECT 
            MIN(sfrc_kg.id_shipping_fee_rate_card_kg)
        FROM
            shipping_fee_rate_card_kg sfrc_kg
        WHERE
            sfrc_kg.destination_zone = package.id_district_temp
                AND sfrc_kg.origin = package.origin_temp
                AND formula_weight <= (sfrc_kg.weight_break + 0.3))
    LEFT JOIN (SELECT 
        id_shipping_fee_rate_card_kg,
            destination_zone,
            origin,
            weight_break 'max_weight_break'
    FROM
        shipping_fee_rate_card_kg sfrck
    WHERE
        sfrck.id_shipping_fee_rate_card_kg = (SELECT 
                MAX(sfrck_max.id_shipping_fee_rate_card_kg)
            FROM
                shipping_fee_rate_card_kg sfrck_max
            WHERE
                sfrck_max.weight_break NOT LIKE '%999999%'
                    AND sfrck_max.destination_zone = sfrck.destination_zone
                    AND sfrck_max.origin = sfrck.origin)) maks ON maks.destination_zone = sfrck.destination_zone
        AND maks.origin = sfrck.origin) city) fin
GROUP BY fin.id_city, fin.zone_type, tier, threshold_kg, threshold_order