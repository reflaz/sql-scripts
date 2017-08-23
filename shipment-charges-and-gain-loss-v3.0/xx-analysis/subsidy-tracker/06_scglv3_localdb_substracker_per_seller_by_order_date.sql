/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Subsidy Tracker Seller Level by Order Date
 
Prepared by		: RM
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
SET @extractstart = '2017-08-15';
SET @extractend = '2017-08-20';-- This MUST be D + 1

SELECT 
    fin.bob_id_supplier,
    fin.short_code,
    fin.seller_name,
    fin.seller_type,
    fin.tax_class,
    fin.threshold_kg,
    fin.threshold_order,
    SUM(fin.unit_price) 'total_unit_price',
    SUM(fin.paid_price) 'total_paid_price',
    SUM(fin.nmv) 'nmv',
    COUNT(DISTINCT fin.order_nr) 'total_so',
    COUNT(DISTINCT fin.id_package_dispatching) 'total_pck',
    COUNT(fin.bob_id_sales_order_item) 'total_soi',
    SUM(fin.unit_price) / COUNT(DISTINCT fin.order_nr) 'aov',
    SUM(fin.shipping_surcharge_temp) 'total_shipping_surcharge',
    SUM(fin.shipping_amount_temp) 'total_shipping_amount',
    SUM(fin.total_delivery_cost_item) 'total_delivery_cost',
    SUM(fin.total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(fin.shipping_surcharge_temp) + SUM(fin.shipping_amount_temp) + SUM(fin.total_shipment_fee_mp_seller_item) + SUM(fin.total_delivery_cost_item) 'net_subsidy'
FROM
    (SELECT 
        ac.order_nr,
            ac.id_package_dispatching,
            ac.bob_id_supplier,
            ac.short_code,
            ac.seller_name,
            ac.seller_type,
            ac.tax_class,
            ac.zone_type 'zone_type_temp',
            ac.id_district 'id_district_temp',
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
            CASE
                WHEN pack.formula_weight <= 1.3 THEN '0-1kg'
                WHEN pack.formula_weight <= 2.3 THEN '1-2kg'
                WHEN pack.formula_weight <= 3.3 THEN '2-3kg'
                WHEN pack.formula_weight <= 4.3 THEN '3-4kg'
                WHEN pack.formula_weight <= 5.3 THEN '4-5kg'
                WHEN pack.formula_weight <= 6.3 THEN '5-6kg'
                WHEN pack.formula_weight <= 7.3 THEN '6-7kg'
                ELSE '> 7kg'
            END 'threshold_kg',
            CASE
                WHEN ac.order_value < 50000 THEN '0-50k'
                WHEN ac.order_value < 100000 THEN '50-100k'
                WHEN ac.order_value < 150000 THEN '100-150k'
                WHEN ac.order_value < 200000 THEN '150-200k'
                WHEN ac.order_value < 250000 THEN '200-250k'
                WHEN ac.order_value < 300000 THEN '250-300k'
                ELSE '> 300k'
            END 'threshold_order'
    FROM
        (SELECT 
        order_nr,
            id_package_dispatching,
            GREATEST(SUM(weight), SUM(volumetric_weight)) 'formula_weight'
    FROM
        (SELECT 
        order_nr,
            IFNULL(id_package_dispatching, 1) 'id_package_dispatching',
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
        anondb_calculate
    WHERE
        order_date >= @extractstart
            AND order_date < @extractend) item
    GROUP BY order_nr , id_package_dispatching) pack
    LEFT JOIN anondb_calculate ac ON pack.order_nr = ac.order_nr
        AND pack.id_package_dispatching = IFNULL(ac.id_package_dispatching, 1)
    WHERE
        ac.bob_id_supplier IN ()
    GROUP BY ac.bob_id_sales_order_item
    HAVING pass = 1) fin
GROUP BY bob_id_supplier , threshold_kg , threshold_order