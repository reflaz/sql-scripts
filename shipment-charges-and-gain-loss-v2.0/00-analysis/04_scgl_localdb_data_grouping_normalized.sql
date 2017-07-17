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
    temp_shipping_surcharge_old AS shipping_surcharge_old,
    temp_shipping_surcharge AS shipping_surcharge,
    shipping_fee_to_customer,
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
    shipping_fee,
    shipping_fee_credit,
    seller_cr_db_item,
    qty,
    temp_formula_weight AS formula_weight,
    CASE
        WHEN
            fk_shipment_scheme = 1 -- OR order_date >= '2017-04-01' OR first_shipped_date >= '2017-04-01' OR delivered_date >= '2017-04-01' OR not_delivered_date >= '2017-04-01'
        THEN
            CASE
                WHEN temp_formula_weight = 0 THEN 0
                WHEN temp_formula_weight < 1 THEN 1
                WHEN MOD(temp_formula_weight, 1) <= 0.3 THEN FLOOR(temp_formula_weight)
                ELSE CEIL(temp_formula_weight)
            END
        ELSE CEIL(temp_formula_weight)
    END 'rounded_weight',
    chargeable_weight AS chargeable_weight,
    CASE
        WHEN
            fk_shipment_scheme = 1 OR order_date >= '2017-04-01' OR first_shipped_date >= '2017-04-01' OR delivered_date >= '2017-04-01' OR not_delivered_date >= '2017-04-01'
        THEN
            CASE
                WHEN chargeable_weight = 0 THEN 0
                WHEN chargeable_weight < 1 THEN 1
                WHEN MOD(chargeable_weight, 1) <= 0.3 THEN FLOOR(chargeable_weight)
                ELSE CEIL(chargeable_weight)
            END
        ELSE CEIL(chargeable_weight)
    END 'rounded_chargeable_weight',
    chargeable_qty,
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
    0 AS total_delivery_cost,
    active
FROM
    (SELECT 
        *,
            SUM(IFNULL(unit_price, 0)) 'temp_unit_price',
            SUM(IFNULL(paid_price, 0)) 'temp_paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'temp_shipping_amount',
            SUM(IFNULL(shipping_surcharge_old, 0)) 'temp_shipping_surcharge_old',
            SUM(IFNULL(shipping_surcharge, 0)) 'temp_shipping_surcharge',
            SUM(CASE
                WHEN is_marketplace = 0 THEN (IFNULL(shipping_amount,0) / 1.1) + (IFNULL(shipping_surcharge,0) / 1.1)
                ELSE IFNULL(shipping_amount,0) + IFNULL(shipping_surcharge,0)
            END) 'shipping_fee_to_customer',
            SUM(IFNULL(marketplace_commission_fee, 0)) 'temp_marketplace_commission_fee',
            SUM(IFNULL(coupon_money_value, 0)) 'temp_coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'temp_cart_rule_discount',
            SUM(IFNULL(retail_cogs, 0)) 'temp_retail_cogs',
            SUM(IFNULL(weight, 0)) 'temp_weight',
            SUM(IFNULL(volumetric_weight, 0)) 'temp_volumetric_weight',
            CASE
                WHEN
                    fk_shipment_scheme = 1
                THEN
                    CASE
                        WHEN
                            first_shipped_date >= '2017-01-01'
                                OR order_date >= '2017-01-01'
                        THEN
                            CASE
                                WHEN SUM(IF(free = 0, IFNULL(weight, 0), 0)) > SUM(IF(free = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(free = 0, IFNULL(weight, 0), 0))
                                ELSE SUM(IF(free = 0, IFNULL(volumetric_weight, 0), 0))
                            END
                        WHEN SUM(IF(bulky = 0 AND free = 0, IFNULL(weight, 0), 0)) > SUM(IF(bulky = 0 AND free = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(bulky = 0 AND free = 0, IFNULL(weight, 0), 0))
                        ELSE SUM(IF(bulky = 0 AND free = 0, IFNULL(volumetric_weight, 0), 0))
                    END
                ELSE CASE
                    WHEN SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)) THEN SUM(IFNULL(weight, 0))
                    ELSE SUM(IFNULL(volumetric_weight, 0))
                END
            END 'temp_formula_weight',
            MAX(bulky) 'temp_bulky',
            CASE
                WHEN
                    fk_shipment_scheme = 1
                THEN
                    CASE
                        WHEN
                            first_shipped_date >= '2017-01-01'
                                OR order_date >= '2017-01-01'
                        THEN
                            LEAST(CASE
                                WHEN SUM(IF(free = 0, IFNULL(weight, 0), 0)) > SUM(IF(free = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(free = 0, IFNULL(weight, 0), 0))
                                ELSE SUM(IF(free = 0, IFNULL(volumetric_weight, 0), 0))
                            END, 2)
                        WHEN SUM(IF(bulky = 0 AND free = 0, IFNULL(weight, 0), 0)) > SUM(IF(bulky = 0 AND free = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(bulky = 0 AND free = 0, IFNULL(weight, 0), 0))
                        ELSE SUM(IF(bulky = 0 AND free = 0, IFNULL(volumetric_weight, 0), 0))
                    END
                ELSE CASE
                    WHEN
                        first_shipped_date >= '2017-01-01'
                            OR order_date >= '2017-01-01'
                    THEN
                        LEAST(CASE
                            WHEN SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)) THEN SUM(IFNULL(weight, 0))
                            ELSE SUM(IFNULL(volumetric_weight, 0))
                        END, 2)
                    WHEN SUM(IF(bulky = 0, IFNULL(weight, 0), 0)) > SUM(IF(bulky = 0, IFNULL(volumetric_weight, 0), 0)) THEN SUM(IF(bulky = 0, IFNULL(weight, 0), 0))
                    ELSE SUM(IF(bulky = 0, IFNULL(volumetric_weight, 0), 0))
                END
            END 'chargeable_weight',
            COUNT(bob_id_sales_order_item) 'qty',
            CASE
                WHEN
                    first_shipped_date >= '2017-01-01'
                        OR order_date >= '2017-01-01'
                THEN
                    COUNT(bob_id_sales_order_item)
                ELSE SUM(IF(bulky = 1 OR free = 1, 0, 1))
            END 'chargeable_qty',
            SUM(IFNULL(sc_fee_1, 0)) 'shipping_fee',
            SUM(IFNULL(sc_fee_2, 0)) 'shipping_fee_credit',
            SUM(IFNULL(sc_fee_3, 0)) 'seller_cr_db_item'
    FROM
        (SELECT 
        ae.bob_id_sales_order_item,
            ae.sc_sales_order_item,
            ae.order_nr,
            ae.payment_method,
            ae.sku,
            ae.primary_category,
            ae.bob_id_supplier,
            ae.short_code,
            ae.seller_name,
            ae.seller_type,
            ae.tax_class,
            ae.unit_price,
            ae.paid_price,
            ae.shipping_amount,
            ae.shipping_surcharge 'shipping_surcharge_old',
            CASE
                WHEN fk_shipment_scheme NOT IN (1 , 2, 3, 4) THEN ae.shipping_surcharge
                ELSE CASE
                    WHEN formula_weight <= 0.17 THEN 0
                    ELSE CASE
                        WHEN
                            fk_shipment_scheme IN (1 , 2, 3, 4)
                        THEN
                            CASE
                                WHEN
                                    ae.active = 0 AND fk_shipment_scheme = 1
                                        AND formula_weight > 7.3
                                THEN
                                    0
                                WHEN
                                    zt.zone_type LIKE '%free%'
                                THEN
                                    CASE
                                        WHEN
                                            ae.active = 1
                                        THEN
                                            CASE
                                                WHEN CEIL(formula_weight) <= 2 THEN 0
                                                ELSE CEIL(formula_weight) - 2
                                            END
                                        ELSE CASE
                                            WHEN CEIL(formula_weight) <= 7 THEN 0
                                            ELSE CEIL(formula_weight)
                                        END
                                    END
                                ELSE CEIL(formula_weight)
                            END
                    END
                END * MIN(rcc.shipment_cost_rate)
            END 'shipping_surcharge',
            ae.marketplace_commission_fee,
            ae.coupon_money_value,
            ae.cart_rule_discount,
            ae.coupon_code,
            ae.coupon_type,
            ae.cart_rule_display_names,
            ae.last_status,
            ae.order_date,
            ae.first_shipped_date,
            ae.last_shipped_date,
            ae.delivered_date,
            ae.not_delivered_date,
            ae.closed_date,
            ae.refund_completed_date,
            ae.pickup_provider_type,
            ae.package_number,
            ae.id_package_dispatching,
            ae.invoice_tracking_number,
            ae.invoice_shipment_provider,
            ae.first_tracking_number,
            ae.first_shipment_provider,
            ae.last_tracking_number,
            ae.last_shipment_provider,
            ae.origin,
            ae.city,
            ae.id_district,
            ae.config_length,
            ae.config_width,
            ae.config_height,
            ae.config_weight,
            ae.simple_length,
            ae.simple_width,
            ae.simple_height,
            ae.simple_weight,
            ae.shipping_type,
            ae.delivery_type,
            ae.is_marketplace,
            ae.is_express_shipping,
            ae.fast_delivery,
            ae.retail_cogs,
            ae.payment_cost_logic,
            ae.sc_fee_1,
            ae.sc_fee_2,
            ae.sc_fee_3,
            ae.weight,
            ae.volumetric_weight,
            ae.fk_shipment_scheme,
            ae.active,
            CASE
				WHEN fk_shipment_scheme = 1 AND formula_weight > 7.3 THEN 1
                WHEN fk_shipment_scheme <> 1 AND formula_weight > 7 THEN 1
                ELSE 0
            END 'bulky',
            IF(formula_weight <= 0.17, 1, 0) 'free'
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
            END, 0)) 'formula_weight',
            CASE
                WHEN tax_class = 'international' THEN 5
                WHEN delivery_type = 'digital' THEN 0
                WHEN
                    first_shipment_provider = 'Digital Delivery'
                        OR last_shipment_provider = 'Digital Delivery'
                THEN
                    0
                WHEN
                    delivery_type IN ('express' , 'nextday', 'sameday')
                THEN
                    7
                WHEN is_marketplace = 0 THEN 3
                WHEN shipping_type = 'warehouse' THEN 4
                WHEN
                    first_shipment_provider = 'Acommerce'
                        AND last_shipment_provider = 'Acommerce'
                THEN
                    1
                WHEN
                    payment_method <> 'CashOnDelivery'
                        AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                        AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                THEN
                    1
                ELSE 2
            END 'fk_shipment_scheme',
            CASE
                WHEN
                    first_shipped_date >= '2017-01-01'
                        OR order_date >= '2017-01-01'
                THEN
                    1
                ELSE 0
            END 'active'
    FROM
        scgl.anondb_extract ae) ae
    LEFT JOIN scgl.rate_card_customer rcc ON ae.id_district = rcc.id_district
        AND ae.origin = rcc.origin
        AND ae.formula_weight <= rcc.weight_break
        AND ae.active = rcc.active
    LEFT JOIN scgl.free_zone fz ON rcc.id_district = fz.id_district
        AND rcc.active = fz.active
    LEFT JOIN scgl.zone_type zt ON fz.fk_zone_type = zt.id_zone_type
    GROUP BY bob_id_sales_order_item) ae
    GROUP BY order_nr , id_package_dispatching , bob_id_supplier) ae;