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


SELECT 
    SUM(qty - 1) 'total_qty'
FROM
    (SELECT 
        ae.bob_id_sales_order_item,
            ae.unit_price,
            rcc.shipment_cost_rate,
            ae.package_number,
            ae.order_nr,
            rcc.rounding 'weight_threshold',
            ae.weight,
            ae.volumetric_weight,
            rcc.flat_rate 'basket_size_threshold',
            zt.zone_type,
            shipping_amount 'shipping_amount_old',
            IFNULL((SELECT 
                    CASE
                            WHEN
                                SUM(dd.unit_price) < rcc.flat_rate
                                    AND zt.id_zone_type = 4
                            THEN
                                5000
                            WHEN SUM(dd.unit_price) < rcc.flat_rate THEN rcc.shipment_cost_rate
                            ELSE 0
                        END
                FROM
                    scgl.anondb_extract dd
                WHERE
                    dd.order_nr = ae.order_nr) / (SELECT 
                    COUNT(dd.bob_id_sales_order_item)
                FROM
                    scgl.anondb_extract dd
                WHERE
                    dd.order_nr = ae.order_nr), 0) * qty 'shipping_amount_new',
            ae.shipping_surcharge 'shipping_surcharge_old',
            IFNULL(CASE
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
                                                WHEN
                                                    CASE
                                                        WHEN formula_weight = 0 THEN 0
                                                        WHEN formula_weight < 1 THEN 1
                                                        WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                        ELSE CEIL(formula_weight)
                                                    END <= rcc.rounding
                                                THEN
                                                    0
                                                ELSE CASE
                                                    WHEN formula_weight = 0 THEN 0
                                                    WHEN formula_weight < 1 THEN 1
                                                    WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                    ELSE CEIL(formula_weight)
                                                END - rcc.rounding
                                            END
                                        ELSE CASE
                                            WHEN
                                                CASE
                                                    WHEN formula_weight = 0 THEN 0
                                                    WHEN formula_weight < 1 THEN 1
                                                    WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                    ELSE CEIL(formula_weight)
                                                END <= 7
                                            THEN
                                                0
                                            ELSE CASE
                                                WHEN formula_weight = 0 THEN 0
                                                WHEN formula_weight < 1 THEN 1
                                                WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                ELSE CEIL(formula_weight)
                                            END
                                        END
                                    END
                                ELSE CASE
                                    WHEN formula_weight = 0 THEN 0
                                    WHEN formula_weight < 1 THEN 1
                                    WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                    ELSE CEIL(formula_weight)
                                END
                            END
                    END
                END * rcc.shipment_cost_rate
            END, 0) 'shipping_surcharge_new',
            ae.sc_sales_order_item,
            ae.payment_method,
            ae.sku,
            ae.primary_category,
            ae.bob_id_supplier,
            ae.short_code,
            ae.seller_name,
            ae.seller_type,
            ae.tax_class,
            ae.paid_price,
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
            CASE
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
                                            WHEN
                                                CASE
                                                    WHEN formula_weight = 0 THEN 0
                                                    WHEN formula_weight < 1 THEN 1
                                                    WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                    ELSE CEIL(formula_weight)
                                                END <= rcc.rounding
                                            THEN
                                                0
                                            ELSE CASE
                                                WHEN formula_weight = 0 THEN 0
                                                WHEN formula_weight < 1 THEN 1
                                                WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                ELSE CEIL(formula_weight)
                                            END - rcc.rounding
                                        END
                                    ELSE CASE
                                        WHEN
                                            CASE
                                                WHEN formula_weight = 0 THEN 0
                                                WHEN formula_weight < 1 THEN 1
                                                WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                                ELSE CEIL(formula_weight)
                                            END <= 7
                                        THEN
                                            0
                                        ELSE CASE
                                            WHEN formula_weight = 0 THEN 0
                                            WHEN formula_weight < 1 THEN 1
                                            WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                            ELSE CEIL(formula_weight)
                                        END
                                    END
                                END
                            ELSE CASE
                                WHEN formula_weight = 0 THEN 0
                                WHEN formula_weight < 1 THEN 1
                                WHEN MOD(formula_weight, 1) <= 0.3 THEN FLOOR(formula_weight)
                                ELSE CEIL(formula_weight)
                            END
                        END
                END
            END 'customer_weight',
            ae.fk_shipment_scheme,
            ae.active,
            bulky,
            free,
            qty,
            temp_formula_weight,
            chargeable_weight,
            chargeable_qty,
            zt.id_zone_type,
            formula_weight
    FROM
        (SELECT 
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
            SUM(IFNULL(unit_price, 0)) 'unit_price',
            SUM(IFNULL(paid_price, 0)) 'paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'shipping_amount',
            SUM(IFNULL(shipping_surcharge, 0)) 'shipping_surcharge',
            SUM(IFNULL(marketplace_commission_fee, 0)) 'marketplace_commission_fee',
            SUM(IFNULL(coupon_money_value, 0)) 'coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'cart_rule_discount',
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
            SUM(IFNULL(retail_cogs, 0)) 'retail_cogs',
            payment_cost_logic,
            SUM(IFNULL(sc_fee_1, 0)) 'sc_fee_1',
            SUM(IFNULL(sc_fee_2, 0)) 'sc_fee_2',
            SUM(IFNULL(sc_fee_3, 0)) 'sc_fee_3',
            SUM(weight) 'weight',
            SUM(volumetric_weight) 'volumetric_weight',
            GREATEST(SUM(weight), SUM(volumetric_weight)) 'formula_weight',
            COUNT(bob_id_sales_order_item) 'qty',
            fk_shipment_scheme,
            active,
            MAX(bulky) 'bulky',
            free,
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
            CASE
                WHEN
                    first_shipped_date >= '2017-01-01'
                        OR order_date >= '2017-01-01'
                THEN
                    COUNT(bob_id_sales_order_item)
                ELSE SUM(IF(bulky = 1 OR free = 1, 0, 1))
            END 'chargeable_qty'
    FROM
        (SELECT 
        *,
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
                WHEN delivery_type IN ('express' , 'nextday', 'sameday') THEN 7
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
            END 'active',
            CASE
                WHEN
                    first_shipment_provider = 'Acommerce'
                        AND last_shipment_provider = 'Acommerce'
                        AND GREATEST(IFNULL(CASE
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
                    END, 0)) > 7.3
                THEN
                    1
                WHEN
                    payment_method <> 'CashOnDelivery'
                        AND first_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                        AND last_shipment_provider IN ('JNE' , 'FIRST LOGISTICS', 'Seller Fleet')
                        AND GREATEST(IFNULL(CASE
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
                    END, 0)) > 7.3
                THEN
                    1
                WHEN
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
                    END, 0)) > 7
                THEN
                    1
                ELSE 0
            END 'bulky',
            IF(GREATEST(IFNULL(CASE
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
            END, 0)) <= 0.17, 1, 0) 'free'
    FROM
        scgl.anondb_extract
	) ae
    -- LIMIT 150000) ae
    GROUP BY order_nr , id_package_dispatching) ae
    LEFT JOIN scgl.rate_card_customer rcc ON ae.id_district = rcc.id_district
        AND ae.origin = rcc.origin
        AND ae.formula_weight <= rcc.weight_break
        AND ae.active = rcc.active
    LEFT JOIN scgl.free_zone fz ON rcc.id_district = fz.id_district
        AND rcc.active = fz.active
    LEFT JOIN scgl.zone_type zt ON fz.fk_zone_type = zt.id_zone_type
    HAVING id_zone_type IN (3 , 4) AND qty > 1
        AND (formula_weight / qty) <= 2) ae