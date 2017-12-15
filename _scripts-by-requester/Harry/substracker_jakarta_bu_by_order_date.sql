/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker Jakarta BU by Order Date
 
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
SET @extractstart = '2017-11-01';
SET @extractend = '2017-11-02';-- This MUST be D + 1

SELECT 
    flag_category,
    SUM(formula_weight) 'total_formula_weight',
    SUM(chargeable_weight_seller) 'total_chargeable_weight_seller',
    SUM(chargeable_weight_3pl) 'total_chargeable_weight_3pl',
    SUM(unit_price) 'total_unit_price',
    SUM(paid_price) 'total_paid_price',
    SUM(nmv) 'nmv',
    COUNT(DISTINCT order_nr) 'total_so',
    COUNT(DISTINCT id_package_dispatching) 'total_pck',
    SUM(qty) 'total_soi',
    SUM(unit_price) / COUNT(DISTINCT order_nr) 'aov',
    SUM(shipping_surcharge) 'total_shipping_surcharge',
    SUM(shipping_amount) 'total_shipping_amount',
    SUM(total_shipment_fee_mp_seller) 'total_shipment_fee_mp_seller',
    SUM(total_delivery_cost) 'total_delivery_cost'
FROM
    (SELECT 
        package.*,
            CASE
                WHEN
                    (formula_weight > 2.3
                        AND formula_weight <= 7.3)
                        AND origin = 'DKI Jakarta'
                        AND zone_type = 'Jabodetabek'
                THEN
                    CASE
                        WHEN flag_retail_fbl = 'Retail' THEN 'Inner Jakarta Retail'
                        WHEN flag_retail_fbl = 'FBL' THEN 'Inner Jakarta FBL'
                        WHEN first_shipment_provider LIKE '%LEX%' THEN 'Inner Jakarta LEX'
                        ELSE 'Others'
                    END
                ELSE 'Others'
            END 'flag_category'
    FROM
        (SELECT 
        pack.*,
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
        order_nr,
            order_value,
            SUM(unit_price) 'unit_price',
            SUM(paid_price) 'paid_price',
            SUM(shipping_amount) 'shipping_amount',
            SUM(shipping_surcharge) 'shipping_surcharge',
            SUM(nmv) 'nmv',
            SUM(total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
            SUM(total_delivery_cost_item) 'total_delivery_cost',
            id_package_dispatching,
            origin,
            zone_type,
            id_district,
            id_city,
            city,
            id_tier_mapping,
            tier,
            first_shipment_provider,
            flag_retail_fbl,
            COUNT(bob_id_sales_order_item) 'qty',
            SUM(chargeable_weight_seller) 'chargeable_weight_seller',
            SUM(chargeable_weight_3pl) 'chargeable_weight_3pl',
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight'
    FROM
        (SELECT 
        ac.order_nr,
            ac.bob_id_sales_order_item,
            CASE
                WHEN
                    is_marketplace = 0
                THEN
                    'Retail'
                WHEN
                    shipping_type = 'warehouse'
                        AND is_marketplace = 1
                THEN
                    'FBL'
                ELSE 'non_warehouse'
            END 'flag_retail_fbl',
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
            ac.id_package_dispatching,
            ac.origin,
            ac.zone_type,
            ac.id_district,
            tm.id_city,
            tm.city,
            tm.id_tier_mapping,
            tm.tier,
            ac.first_shipment_provider,
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
            AND ac.shipment_scheme IN ('RETAIL' , 'FBL', 'DIRECT BILLING', 'MASTER ACCOUNT')
    HAVING pass = 1) item
    GROUP BY order_nr , id_package_dispatching , flag_retail_fbl) pack) package) fin
GROUP BY flag_category