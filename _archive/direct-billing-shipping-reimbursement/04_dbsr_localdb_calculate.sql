/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Direct Billing Shipping Reimbursement LocalDB Calculate
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE dbsr;

SELECT 
    order_nr 'Order Number',
    bob_id_sales_order_item 'Sales Order Item',
    sc_sales_order_item 'SC Sales Order Item',
    sku 'SKU',
    sc_seller_id 'SC Seller ID',
    seller_name 'Seller Name',
    total_shipping_amount 'Total Shipping Amount',
    total_shipping_surcharge 'Total Shipping Surcharge',
    total_shipping_surcharge_non_bulky 'Total Shipping Surcharge Non Bulky',
    order_date 'Order Date',
    shipped_date 'Shipped Date',
    delivered_date 'Delivered Date',
    last_tracking_number 'Tracking Number',
    last_shipment_provider 'Shipment Provider',
    origin 'Origin',
    city 'City',
    id_district 'District ID',
    total_weight 'Total Weight',
    total_volumetric_weight 'Total Volumetric Weight',
    formula_weight 'Formula Weight',
    rounded_weight 'Rounded Weight',
    rounded_weight_non_bulky 'Rounded Weight Non Bulky',
    total_charge_to_seller 'Total Charge to Seller',
    rate '3PL Rate',
    total_charge_from_3pl 'Total 3PL Charge',
    reimburse_to_seller 'Shipping Reimbursement/Charge',
    remarks 'Remarks'
FROM
    (SELECT 
        result.*,
            (rounded_weight_non_bulky * 7000) 'total_charge_to_seller',
            rounded_weight_non_bulky * rate 'total_charge_from_3pl',
            CASE
                WHEN last_shipment_provider LIKE '%Seller Fleet%' THEN 0
                ELSE IF((rounded_weight_non_bulky * rate) - (rounded_weight_non_bulky * 7000) - result.total_shipping_surcharge_non_bulky > 0, (rounded_weight_non_bulky * rate) - (rounded_weight_non_bulky * 7000) - result.total_shipping_surcharge_non_bulky, 0)
            END - result.total_shipping_amount 'reimburse_to_seller',
            IF(LENGTH(result.origin) > 0
                AND rate IS NOT NULL, '', IF(LENGTH(result.origin) = 0
                AND rate IS NULL, 'Origin and destination unknown', IF(LENGTH(result.origin) = 0, 'Origin unknown', 'Destination Unknown'))) 'remarks'
    FROM
        (SELECT 
        oms.*,
            CASE
                WHEN oms.formula_weight = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.formula_weight < 1, 1, IF(MOD(oms.formula_weight, 1) <= 0.3, FLOOR(oms.formula_weight), CEIL(oms.formula_weight)))
                ELSE CEIL(oms.formula_weight)
            END 'rounded_weight',
            CASE
                WHEN oms.formula_weight_non_bulky = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.formula_weight_non_bulky < 1, 1, IF(MOD(oms.formula_weight_non_bulky, 1) <= 0.3, FLOOR(oms.formula_weight_non_bulky), CEIL(oms.formula_weight_non_bulky)))
                ELSE CEIL(oms.formula_weight_non_bulky)
            END 'rounded_weight_non_bulky',
            jr.rate
    FROM
        (SELECT 
        oms.order_nr,
            oms.bob_id_sales_order_item,
            oms.sc_sales_order_item,
            oms.sku,
            oms.sc_seller_id,
            oms.seller_name,
            SUM(IFNULL(oms.shipping_amount, 0)) 'total_shipping_amount',
            SUM(IFNULL(oms.shipping_surcharge, 0)) 'total_shipping_surcharge',
            SUM(IF(oms.item_rounded_weight > 7
                OR oms.item_formula_weight <= 0.17, 0, oms.shipping_surcharge)) 'total_shipping_surcharge_non_bulky',
            oms.order_date,
            oms.shipped_date,
            oms.delivered_date,
            oms.last_tracking_number,
            oms.last_shipment_provider,
            IF(oms.origin_city LIKE '%bandung%', 'Bandung', IF(oms.origin = '', 'DKI Jakarta', oms.origin)) 'origin',
            oms.city,
            oms.id_district,
            SUM(IFNULL(oms.weight, 0)) 'total_weight',
            SUM(IFNULL(oms.volumetric_weight, 0)) 'total_volumetric_weight',
            IF(SUM(IFNULL(oms.weight, 0)) > SUM(IFNULL(oms.volumetric_weight, 0)), SUM(IFNULL(oms.weight, 0)), SUM(IFNULL(oms.volumetric_weight, 0))) 'formula_weight',
            IF(SUM(IF(oms.item_rounded_weight > 7
                OR oms.item_formula_weight <= 0.17, 0, IFNULL(oms.weight, 0))) > SUM(IF(oms.item_rounded_weight > 7
                OR oms.item_formula_weight <= 0.17, 0, IFNULL(oms.volumetric_weight, 0))), SUM(IF(oms.item_rounded_weight > 7
                OR oms.item_formula_weight <= 0.17, 0, IFNULL(oms.weight, 0))), SUM(IF(oms.item_rounded_weight > 7
                OR oms.item_formula_weight <= 0.17, 0, IFNULL(oms.volumetric_weight, 0)))) 'formula_weight_non_bulky'
    FROM
        oms
    JOIN free_zone fz ON oms.id_district = fz.id_district
    GROUP BY last_tracking_number) oms
    LEFT JOIN jne_rate jr ON oms.origin = jr.origin
        AND oms.id_district = jr.id_district) result) result