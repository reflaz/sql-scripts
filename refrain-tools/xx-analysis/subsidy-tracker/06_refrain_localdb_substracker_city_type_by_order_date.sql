/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker by City Tier Mapping
 
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

USE refrain_live;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-11-06';
SET @extractend = '2017-11-07';-- This MUST be D + 1

SELECT 
    fin.id_city,
    fin.city,
    fin.tier,
    fin.threshold_kg,
    fin.threshold_order,
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
                WHEN formula_weight <= 1.3 THEN '<= 1kg'
                WHEN formula_weight <= 2.3 THEN '<= 2kg'
                WHEN formula_weight <= 3.3 THEN '<= 3kg'
                WHEN formula_weight <= 4.3 THEN '<= 4kg'
                WHEN formula_weight <= 5.3 THEN '<= 5kg'
                WHEN formula_weight <= 6.3 THEN '<= 6kg'
                WHEN formula_weight <= 7.3 THEN '<= 7kg'
                ELSE '> 7kg'
            END 'threshold_kg',
            CASE
                WHEN order_value < 50000 THEN '< 50k'
                WHEN order_value < 100000 THEN '< 100k'
                WHEN order_value < 150000 THEN '< 150k'
                WHEN order_value < 200000 THEN '< 200k'
                WHEN order_value < 250000 THEN '< 250k'
                WHEN order_value < 300000 THEN '< 300k'
                WHEN order_value < 350000 THEN '< 350k'
                WHEN order_value < 400000 THEN '< 400k'
                WHEN order_value < 450000 THEN '< 450k'
                WHEN order_value < 500000 THEN '< 500k'
                ELSE '>= 500k'
            END 'threshold_order'
    FROM
        (SELECT 
        pack.*, GREATEST(weight, volumetric_weight) 'formula_weight'
    FROM
        (SELECT 
        order_nr,
            id_package_dispatching,
            id_district,
            id_city,
            city,
            id_city_tier,
            tier,
            COUNT(bob_id_sales_order_item) 'qty',
            origin,
            order_value,
            SUM(unit_price) 'unit_price',
            SUM(paid_price) 'paid_price',
            SUM(total_seller_charge) 'total_shipment_fee_mp_seller',
            SUM(total_delivery_cost) 'total_delivery_cost',
            SUM(shipping_surcharge_temp) 'shipping_surcharge',
            SUM(shipping_amount_temp) 'shipping_amount',
            SUM(nmv) 'nmv',
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight'
    FROM
        (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.id_district,
            tm.id_city,
            tm.city,
            tm.id_city_tier,
            tm.tier,
            ac.bob_id_sales_order_item,
            ac.origin,
            ac.order_value,
            ac.unit_price,
            ac.paid_price,
            ac.total_seller_charge,
            ac.total_delivery_cost,
            CASE
				WHEN fk_api_type <> 0 THEN 1
                WHEN ABS(total_delivery_cost / unit_price) > 5 THEN 0
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
            weight,
            volumetric_weight
    FROM
        fms_sales_order_item ac
    LEFT JOIN map_city_tier tm ON ac.id_district = tm.id_district
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) item
    GROUP BY order_nr , id_package_dispatching) pack) city) fin
GROUP BY fin.id_city , fin.tier , fin.threshold_order , fin.threshold_kg