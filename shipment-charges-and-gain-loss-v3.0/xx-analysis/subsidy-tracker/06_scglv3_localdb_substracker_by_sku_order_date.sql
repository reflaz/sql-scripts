/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker SKU by Order Date
 
Prepared by		: Ryan Disastra
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
				  - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-11-20';
SET @extractend = '2017-11-21';-- This MUST be D + 1

SELECT 
    fin.origin,
    fin.city 'destination_city',
    fin.shipment_scheme 'BU',
    fin.sku,
    fin.is_free,
    SUM(formula_weight) 'total_formula_weight',
    SUM(chargeable_weight_seller) 'total_chargeable_weight_seller',
    SUM(chargeable_weight_3pl) 'total_chargeable_weight_3pl',
    SUM(fin.unit_price) 'total_unit_price',
    SUM(fin.paid_price) 'total_paid_price',
    SUM(fin.nmv) 'nmv',
    COUNT(DISTINCT fin.order_nr) 'total_so',
    COUNT(DISTINCT fin.id_package_dispatching) 'total_pck',
    COUNT(bob_id_sales_order_item) 'total_soi',
    SUM(fin.unit_price) / COUNT(DISTINCT fin.order_nr) 'aov',
    SUM(fin.shipping_surcharge) 'total_shipping_surcharge',
    SUM(fin.shipping_amount) 'total_shipping_amount',
    SUM(fin.total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(fin.total_delivery_cost_item) 'total_delivery_cost',
    SUM(fin.shipping_surcharge) + SUM(fin.shipping_amount) + SUM(fin.total_shipment_fee_mp_seller_item) + SUM(fin.total_delivery_cost_item) 'net_subsidy'
FROM
    (SELECT 
        city.*,
            CASE
                WHEN order_value < 50000 THEN '< 50k'
                WHEN order_value < 100000 THEN '< 100k'
                WHEN order_value < 150000 THEN '< 150k'
                WHEN order_value < 200000 THEN '< 200k'
                WHEN order_value < 250000 THEN '< 250k'
                WHEN order_value < 300000 THEN '< 300k'
                ELSE '>= 300k'
            END 'range_order_value',
            CASE
                WHEN formula_weight <= 1.3 THEN '<= 1kg'
                WHEN formula_weight <= 2.3 THEN '<= 2kg'
                WHEN formula_weight <= 3.3 THEN '<= 3kg'
                WHEN formula_weight <= 4.3 THEN '<= 4kg'
                WHEN formula_weight <= 5.3 THEN '<= 5kg'
                WHEN formula_weight <= 6.3 THEN '<= 6kg'
                WHEN formula_weight <= 7.3 THEN '<= 7kg'
                ELSE '> 7kg'
            END 'range_kg'
    FROM
        (SELECT 
        item.*,
            GREATEST(weight, volumetric_weight) 'formula_weight',
            CASE
                WHEN
                    IFNULL(shipping_amount, 0) = 0
                        AND IFNULL(shipping_surcharge, 0) = 0
                THEN
                    'free'
                ELSE 'paid'
            END 'is_free'
    FROM
        (SELECT 
        ac.order_nr,
            ac.bob_id_sales_order_item,
            ac.sku,
            ac.bob_id_supplier,
            ac.short_code,
            ac.seller_name,
            ac.seller_type,
            (SELECT 
                    SUM(IFNULL(unit_price, 0))
                FROM
                    anondb_calculate
                WHERE
                    order_nr = ac.order_nr) 'order_value',
            IFNULL(ac.unit_price, 0) 'unit_price',
            IFNULL(ac.paid_price, 0) 'paid_price',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_amount, 0) / 1.1
                ELSE IFNULL(shipping_amount, 0)
            END 'shipping_amount',
            CASE
                WHEN is_marketplace = 0 THEN IFNULL(shipping_surcharge, 0) / 1.1
                ELSE IFNULL(shipping_surcharge, 0)
            END 'shipping_surcharge',
            IFNULL(paid_price / 1.1, 0) + IFNULL(shipping_surcharge / 1.1, 0) + IFNULL(shipping_amount / 1.1, 0) + IF(coupon_type <> 'coupon', IFNULL(coupon_money_value / 1.1, 0), 0) 'nmv',
            IFNULL(ac.total_shipment_fee_mp_seller_item, 0) 'total_shipment_fee_mp_seller_item',
            IFNULL(ac.total_delivery_cost_item, 0) 'total_delivery_cost_item',
            ac.shipment_scheme,
            ac.id_package_dispatching,
            ac.origin,
            ac.zone_type,
            ac.id_district,
            tm.id_city,
            tm.city,
            tm.id_tier_mapping,
            tm.tier,
            IFNULL(ac.chargeable_weight_seller_ps, 0) / IFNULL(qty_ps, 0) 'chargeable_weight_seller',
            IFNULL(ac.chargeable_weight_3pl_ps, 0) / IFNULL(qty_ps, 0) 'chargeable_weight_3pl',
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
            CASE
                WHEN chargeable_weight_3pl_ps / qty_ps > 400 THEN 0
                WHEN ABS(total_delivery_cost_item / unit_price) > 5 THEN 0
                WHEN shipping_amount + shipping_surcharge > 40000000 THEN 0
                ELSE 1
            END 'pass'
    FROM
        anondb_calculate ac
    LEFT JOIN tier_mapping tm ON ac.id_district = tm.id_district
    WHERE
        ac.order_date >= @extractstart
            AND ac.order_date < @extractend
            AND ac.sku IN ()
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) item) city) fin
GROUP BY fin.origin , fin.id_city, fin.shipment_scheme , fin.sku , fin.is_free