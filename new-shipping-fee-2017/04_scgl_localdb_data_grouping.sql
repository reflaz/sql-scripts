/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Data Grouping

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
USE scgl;

TRUNCATE TABLE anondb_calculate;

INSERT INTO anondb_calculate
SELECT 
    bob_id_sales_order_item,
    sc_sales_order_item,
    order_nr,
    payment_method,
    sku,
    primary_category,
    bob_id_supplier,
    short_code,
    seller_name,
    seller_type,
    tax_class,
    temp_unit_price AS unit_price,
    temp_paid_price AS paid_price,
    temp_shipping_amount AS shipping_amount,
    CASE
        WHEN
            temp_shipping_surcharge = 0
                AND CEIL(temp_formula_weight) > 7
        THEN
            CEIL(temp_formula_weight) * jne_rate
        ELSE temp_shipping_surcharge
    END 'calculated_shipping_surcharge',
    CASE
        WHEN
            is_marketplace = 0
        THEN
            (temp_shipping_amount / 1.1) + (CASE
                WHEN
                    temp_shipping_surcharge = 0
                        AND CEIL(temp_formula_weight) > 7
                THEN
                    CEIL(temp_formula_weight) * jne_rate
                ELSE temp_shipping_surcharge
            END / 1.1)
        ELSE temp_shipping_amount + CASE
            WHEN
                temp_shipping_surcharge = 0
                    AND CEIL(temp_formula_weight) > 7
            THEN
                CEIL(temp_formula_weight) * jne_rate
            ELSE temp_shipping_surcharge
        END
    END 'shipping_fee_to_customer',
    temp_marketplace_commission_fee AS marketplace_commission_fee,
    temp_coupon_money_value AS coupon_money_value,
    temp_cart_rule_discount AS cart_rule_discount,
    coupon_code,
    coupon_type,
    cart_rule_display_names,
    last_status,
    order_date,
    first_shipped_date,
    last_shipped_date,
    delivered_date,
    not_delivered_date,
    closed_date,
    refund_completed_date,
    pickup_provider_type,
    package_number,
    id_package_dispatching,
    invoice_tracking_number,
    invoice_shipment_provider,
    first_tracking_number,
    first_shipment_provider,
    last_tracking_number,
    last_shipment_provider,
    origin,
    city,
    id_district,
    config_length,
    config_width,
    config_height,
    config_weight,
    simple_length,
    simple_width,
    simple_height,
    simple_weight,
    shipping_type,
    delivery_type,
    is_marketplace,
    is_express_shipping,
    fast_delivery,
    temp_retail_cogs AS retail_cogs,
    payment_cost_logic,
    sc_fee_1,
    sc_fee_2,
    sc_fee_3,
    qty,
    temp_formula_weight AS formula_weight,
    CEIL(temp_formula_weight) AS rounded_weight,
    formula_weight_non_bulky AS formula_weight_non_bulky,
    CEIL(formula_weight_non_bulky) AS rounded_weight_non_bulky,
    qty_non_bulky,
    temp_bulky,
    0 AS fk_campaign,
    0 AS campaign,
    0 AS fk_rate_card_scheme,
    0 AS rate_card_scheme,
    0 AS fk_shipment_scheme,
    0 AS shipment_scheme,
    0 AS fk_zone_type,
    0 AS zone_type,
    0 AS shipment_fee_mp_seller_rate,
    0 AS shipment_fee_mp_seller,
    0 AS sel_ins_fee,
    0 AS sel_ins_fee_vat,
    0 AS total_insurance_fee,
    0 AS total_shipment_fee_mp_seller,
    0 AS shipment_cost_rate,
    0 AS shipment_cost_discount,
    0 AS shipment_cost_vat,
    0 AS total_shipment_cost,
    0 AS pickup_cost,
    0 AS pickup_cost_discount,
    0 AS pickup_cost_vat,
    0 AS total_pickup_cost,
    0 AS insurance_rate,
    0 AS insurance_vat,
    0 AS sp_ins_charge,
    0 AS sp_ins_charge_vat,
    0 AS total_insurance_charge,
    0 AS total_delivery_cost
FROM
    (SELECT 
        *,
            SUM(IFNULL(unit_price, 0)) 'temp_unit_price',
            SUM(IFNULL(paid_price, 0)) 'temp_paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'temp_shipping_amount',
            SUM(IFNULL(shipping_surcharge, 0)) 'temp_shipping_surcharge',
            SUM(IFNULL(marketplace_commission_fee, 0)) 'temp_marketplace_commission_fee',
            SUM(IFNULL(coupon_money_value, 0)) 'temp_coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'temp_cart_rule_discount',
            SUM(IFNULL(retail_cogs, 0)) 'temp_retail_cogs',
            SUM(IFNULL(weight, 0)) 'temp_weight',
            SUM(IFNULL(volumetric_weight, 0)) 'temp_volumetric_weight',
            CASE
                WHEN SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)) THEN SUM(IFNULL(weight, 0))
                ELSE SUM(IFNULL(volumetric_weight, 0))
            END 'temp_formula_weight',
            MAX(bulky) 'temp_bulky',
            CASE
                WHEN SUM(IF(bulky = 0, IFNULL(weight, 0), 0)) > SUM(IF(bulky = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(bulky = 0, IFNULL(weight, 0), 0))
                ELSE SUM(IF(bulky = 0, IFNULL(volumetric_weight, 0), 0))
            END 'formula_weight_non_bulky',
            COUNT(bob_id_sales_order_item) 'qty',
            SUM(IF(bulky = 1, 0, 1)) 'qty_non_bulky'
    FROM
        (SELECT 
        *, IF(weight > 7 OR volumetric_weight > 7, 1, 0) 'bulky'
    FROM
        (SELECT 
        ae.*,
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
            IFNULL(rc.shipment_cost_rate, 0) 'jne_rate'
    FROM
        scgl.anondb_extract ae
    LEFT JOIN rate_card rc ON ae.id_district = rc.id_district
        AND ae.origin = rc.origin
        AND rc.fk_rate_card_scheme = 1) ae) ae
    GROUP BY bob_id_sales_order_item) ae;