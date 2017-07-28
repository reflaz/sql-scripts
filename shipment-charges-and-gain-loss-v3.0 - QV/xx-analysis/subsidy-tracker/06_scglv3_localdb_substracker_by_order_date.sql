USE scglv3_qv;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-06-26';
SET @extractend = '2017-06-27';-- Thianondb_calculates MUST be D + 1

SELECT 
    fin.city_temp 'city',
    fin.zone_type,
    threshold_kg,
    threshold_order,
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
                WHEN formula_weight <= 1.3 THEN '0-1 kg'
                WHEN formula_weight <= 2.3 THEN '1-2 kg'
                WHEN formula_weight <= 3.3 THEN '2-3 kg'
                ELSE '>3 kg'
            END 'threshold_kg',
            CASE
                WHEN order_value < 30000 THEN '0-30k'
                WHEN order_value < 50000 THEN '30k-50k'
                WHEN order_value < 75000 THEN '50k-75k'
                WHEN order_value < 100000 THEN '75k-100k'
                ELSE '>100k'
            END 'threshold_order'
    FROM
        (SELECT 
        pack.*,
            IF(pack.simple_weight > 0
                OR pack.vol_sim_weight > 0, GREATEST(pack.simple_weight, pack.vol_sim_weight), GREATEST(pack.config_weight, pack.vol_conf_weight)) 'formula_weight'
    FROM
        (SELECT 
        order_nr,
            id_package_dispatching,
            zone_type_temp 'zone_type',
            id_district_temp,
            city_temp,
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
            SUM(config_weight) 'config_weight',
            SUM(vol_conf_weight) 'vol_conf_weight',
            SUM(simple_weight) 'simple_weight',
            SUM(vol_sim_weight) 'vol_sim_weight'
    FROM
        (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.zone_type 'zone_type_temp',
            ac.id_district 'id_district_temp',
            zm.city 'city_temp',
            ac.bob_id_sales_order_item,
            ac.origin 'origin_temp',
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.total_shipment_fee_mp_seller_item,
            ac.total_delivery_cost_item,
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
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
            IFNULL(config_weight, 0) 'config_weight',
            IFNULL((config_length * config_width * config_height / 6000), 0) 'vol_conf_weight',
            IFNULL(simple_weight, 0) 'simple_weight',
            IFNULL((simple_length * simple_width * simple_height / 6000), 0) 'vol_sim_weight'
    FROM
        anondb_calculate ac
    LEFT JOIN zone_mapping zm ON ac.id_district = zm.id_district
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ac.order_date, IFNULL(ac.first_shipped_date, 1)) <= zm.end_date
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) item
    GROUP BY order_nr , id_package_dispatching) pack) city) fin
GROUP BY fin.city_temp , fin.zone_type , threshold_kg , threshold_order