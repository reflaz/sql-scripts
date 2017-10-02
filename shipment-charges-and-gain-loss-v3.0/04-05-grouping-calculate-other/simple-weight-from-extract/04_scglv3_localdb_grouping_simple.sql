/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Grouping Using Simple and Config Weight
Source from imported data

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE scglv3;

SET SQL_SAFE_UPDATES = 0;

UPDATE campaign_tracker 
SET 
    end_date = CASE
        WHEN
            end_date < start_date
                OR end_date IS NULL
        THEN
            '9999-12-31 23:59:59'
        ELSE DATE_FORMAT(end_date, '%Y-%m-%d 23:59:59')
    END;

SET SQL_SAFE_UPDATES = 1;

TRUNCATE anondb_extract_temp;

INSERT INTO anondb_extract_temp
SELECT 
    bob_id_sales_order_item,
    order_nr,
    bob_id_supplier,
    unit_price,
    paid_price,
    shipping_amount,
    shipping_surcharge,
    order_date,
    first_shipped_date,
    last_shipped_date,
    delivered_date,
    not_delivered_date,
    closed_date,
    refund_completed_date,
    zone_type,
    id_package_dispatching,
    package_weight,
    volumetric_weight,
    is_package_weight_seller,
    formula_weight_seller,
    chargeable_weight_seller,
    is_package_weight_3pl,
    formula_weight_3pl,
    chargeable_weight_3pl,
    shipment_scheme,
    rate_card_scheme,
    campaign,
    qty,
    rounding_seller,
    rounding_3pl,
    shipment_fee_mp_seller_flat_rate,
    shipment_fee_mp_seller_rate,
    pickup_cost_rate,
    pickup_cost_discount_rate,
    pickup_cost_vat_rate,
    delivery_cost_vat_rate,
    insurance_rate_tmp,
    insurance_rate_sel,
    insurance_vat_rate_sel,
    insurance_rate_3pl,
    insurance_vat_rate_3pl,
    flat_rate,
    delivery_cost_rate,
    delivery_cost_discount_rate,
    shipment_fee_mp_seller,
    insurance_seller,
    insurance_vat_seller,
    delivery_cost,
    delivery_cost_discount,
    delivery_cost_vat,
    pickup_cost,
    pickup_cost_discount,
    pickup_cost_vat,
    insurance_3pl,
    insurance_vat_3pl,
    shipment_fee_mp_seller + insurance_seller + insurance_vat_seller 'total_shipment_fee_mp_seller',
    delivery_cost + delivery_cost_discount + delivery_cost_vat + pickup_cost + pickup_cost_discount + pickup_cost_vat + insurance_3pl + insurance_vat_3pl 'total_delivery_cost',
    IF(not_delivered_date IS NOT NULL,
        delivery_cost + delivery_cost_discount + delivery_cost_vat,
        0) 'total_failed_delivery_cost'
FROM
    (SELECT 
        *,
            shipment_fee_mp_seller_flat_rate + (shipment_fee_mp_seller_rate * chargeable_weight_seller) 'shipment_fee_mp_seller',
            unit_price * insurance_rate_sel 'insurance_seller',
            unit_price * insurance_rate_sel * insurance_vat_rate_sel 'insurance_vat_seller',
            -(flat_rate + (delivery_cost_rate * chargeable_weight_3pl)) 'delivery_cost',
            (flat_rate + (delivery_cost_rate * chargeable_weight_3pl)) * delivery_cost_discount_rate 'delivery_cost_discount',
            -(flat_rate + (delivery_cost_rate * chargeable_weight_3pl)) * (1 - delivery_cost_discount_rate) * delivery_cost_vat_rate 'delivery_cost_vat',
            - pickup_cost_rate * chargeable_weight_3pl 'pickup_cost',
            pickup_cost_rate * chargeable_weight_3pl * pickup_cost_discount_rate 'pickup_cost_discount',
            - pickup_cost_rate * chargeable_weight_3pl * (1 - pickup_cost_discount_rate) * pickup_cost_vat_rate 'pickup_cost_vat',
            - unit_price * insurance_rate_3pl 'insurance_3pl',
            - unit_price * insurance_rate_3pl * insurance_vat_rate_3pl 'insurance_vat_3pl'
    FROM
        (SELECT 
        ae.*,
            IFNULL(ae.insurance_rate_tmp, IFNULL(ins_sel.insurance_rate, 0)) 'insurance_rate_sel',
            IFNULL(ins_sel.insurance_vat_rate, 0) 'insurance_vat_rate_sel',
            IFNULL(ins_3pl.insurance_rate, 0) 'insurance_rate_3pl',
            IFNULL(ins_3pl.insurance_vat_rate, 0) 'insurance_vat_rate_3pl',
            IFNULL(scfr3pl.flat_rate, 0) 'flat_rate',
            IFNULL(scfr3pl.delivery_cost_rate, 0) 'delivery_cost_rate',
            IFNULL(scfr3pl.delivery_cost_discount_rate, 0) 'delivery_cost_discount_rate'
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
            SUM(IFNULL(ae.unit_price, 0)) 'unit_price',
            SUM(IFNULL(ae.paid_price, 0)) 'paid_price',
            SUM(IFNULL(ae.shipping_amount, 0)) / IF(is_marketplace = 0, 1.1, 1) 'shipping_amount',
            SUM(IFNULL(ae.shipping_surcharge, 0)) / IF(is_marketplace = 0, 1.1, 1) 'shipping_surcharge',
            SUM(IFNULL(ae.marketplace_commission_fee, 0)) 'marketplace_commission_fee',
            SUM(IFNULL(ae.coupon_money_value, 0)) 'coupon_money_value',
            SUM(IFNULL(ae.cart_rule_discount, 0)) 'cart_rule_discount',
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
            ae.order_value,
            ae.bank,
            ae.tenor,
            ae.first_tracking_number,
            ae.first_shipment_provider,
            ae.last_tracking_number,
            ae.last_shipment_provider,
            ae.origin,
            ae.city,
            ae.id_district,
            ae.zone_type,
            SUM(IFNULL(ae.weight_3pl, 0)) 'package_weight',
            SUM(IFNULL(ae.volumetric_weight_3pl, 0)) 'volumetric_weight',
            IF(SUM(IFNULL(ae.weight, 0)) > SUM(IFNULL(ae.volumetric_weight, 0)), 1, 0) 'is_package_weight_seller',
            GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))) 'formula_weight_seller',
            LEAST(CASE
                WHEN GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))) = 0 THEN 0
                WHEN GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))) < 1 THEN 1
                WHEN MOD(GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))), 1) <= IFNULL(ae.rounding_seller, 0) THEN FLOOR(GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))))
                ELSE CEIL(GREATEST(SUM(IFNULL(ae.weight, 0)), SUM(IFNULL(ae.volumetric_weight, 0))))
            END, IFNULL(wt.package_threshold, 0)) 'chargeable_weight_seller',
            IF(SUM(IFNULL(ae.weight_3pl, 0)) > SUM(IFNULL(ae.volumetric_weight_3pl, 0)), 1, 0) 'is_package_weight_3pl',
            GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))) 'formula_weight_3pl',
            CASE
                WHEN GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))) = 0 THEN 0
                WHEN GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))) < 1 THEN 1
                WHEN MOD(GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))), 1) <= IFNULL(ae.rounding_3pl, 0) THEN FLOOR(GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))))
                ELSE CEIL(GREATEST(SUM(IFNULL(ae.weight_3pl, 0)), SUM(IFNULL(ae.volumetric_weight_3pl, 0))))
            END 'chargeable_weight_3pl',
            ae.shipping_type,
            ae.delivery_type,
            ae.is_marketplace,
            ae.bob_id_customer,
            ae.fast_delivery,
            SUM(IFNULL(ae.retail_cogs, 0)) 'retail_cogs',
            SUM(IFNULL(ae.shipping_fee, 0)) 'shipping_fee',
            SUM(IFNULL(ae.shipping_fee_credit, 0)) 'shipping_fee_credit',
            SUM(IFNULL(ae.seller_cr_db_item, 0)) 'seller_cr_db_item',
            ae.shipment_scheme,
            ae.rate_card_scheme,
            ae.campaign,
            COUNT(DISTINCT bob_id_sales_order_item) 'qty',
            IFNULL(ae.rounding_3pl, 0) 'rounding_3pl',
            IFNULL(ae.rounding_seller, 0) 'rounding_seller',
            IFNULL(CASE
                WHEN css.id_campaign_shipment_scheme IS NOT NULL THEN css.shipment_fee_mp_seller_flat_rate
                WHEN ae.fk_campaign IS NOT NULL THEN ae.cam_shipment_fee_mp_seller_flat_rate
                ELSE ae.shipment_fee_mp_seller_flat_rate
            END, 0) 'shipment_fee_mp_seller_flat_rate',
            IFNULL(CASE
                WHEN css.id_campaign_shipment_scheme IS NOT NULL THEN css.shipment_fee_mp_seller_rate
                WHEN ae.fk_campaign IS NOT NULL THEN ae.cam_shipment_fee_mp_seller_rate
                ELSE ae.shipment_fee_mp_seller_rate
            END, 0) 'shipment_fee_mp_seller_rate',
            IFNULL(ae.pickup_cost_rate, 0) 'pickup_cost_rate',
            IFNULL(ae.pickup_cost_discount_rate, 0) 'pickup_cost_discount_rate',
            IFNULL(ae.pickup_cost_vat_rate, 0) 'pickup_cost_vat_rate',
            IFNULL(ae.delivery_cost_vat_rate, 0) 'delivery_cost_vat_rate',
            ae.cam_insurance_rate 'insurance_rate_tmp'
    FROM
        (SELECT 
        ae.*,
        cam.campaign,
        MIN(cam.shipment_fee_mp_seller_flat_rate) 'cam_shipment_fee_mp_seller_flat_rate',
        MIN(cam.shipment_fee_mp_seller_rate) 'cam_shipment_fee_mp_seller_rate',
        MIN(cam.insurance_rate) 'cam_insurance_rate'
    FROM
        (SELECT 
        ae.*,
            cs.rounding_3pl,
            cs.rounding_seller,
            cs.rate_card_scheme,
            cs.shipment_fee_mp_seller_flat_rate,
            cs.shipment_fee_mp_seller_rate,
            cs.pickup_cost_rate,
            cs.pickup_cost_discount_rate,
            cs.pickup_cost_vat_rate,
            cs.delivery_cost_vat_rate,
            CASE
                WHEN GREATEST(weight_3pl, volumetric_weight_3pl) = 0 THEN 0
                WHEN
                    (CASE
                        WHEN GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)) = 0 THEN 0
                        WHEN GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)) < 1 THEN 1
                        WHEN MOD(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)), 1) <= IFNULL(cs.rounding_seller, 0) THEN FLOOR(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)))
                        ELSE CEIL(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)))
                    END) <= IFNULL(wt.item_threshold, 0)
                THEN
                    weight_3pl
                ELSE 0
            END 'weight',
            CASE
                WHEN GREATEST(weight_3pl, volumetric_weight_3pl) = 0 THEN 0
                WHEN
                    (CASE
                        WHEN GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)) = 0 THEN 0
                        WHEN GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)) < 1 THEN 1
                        WHEN MOD(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)), 1) <= IFNULL(cs.rounding_seller, 0) THEN FLOOR(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)))
                        ELSE CEIL(GREATEST(IFNULL(ae.weight_3pl, 0), IFNULL(ae.volumetric_weight_3pl, 0)))
                    END) <= IFNULL(wt.item_threshold, 0)
                THEN
                    volumetric_weight_3pl
                ELSE 0
            END 'volumetric_weight',
            zm.zone_type
    FROM
        (SELECT 
        ae.*,
            (SELECT 
                    MIN(cs.id_charges_scheme)
                FROM
                    charges_scheme cs
                WHERE
                    ae.shipment_scheme = cs.shipment_scheme
                        AND ae.is_marketplace = IFNULL(cs.is_marketplace, ae.is_marketplace)
                        AND IFNULL(ae.pickup_provider_type, 1) = IFNULL(cs.pickup_provider_type, IFNULL(ae.pickup_provider_type, 1))
                        AND IFNULL(ae.first_shipment_provider, 1) LIKE CONCAT('%', IFNULL(cs.first_shipment_provider, IFNULL(ae.first_shipment_provider, 1)), '%')
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= cs.start_date
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= cs.end_date) 'fk_charges_scheme',
            CASE
                WHEN
                    is_marketplace = 0
                        OR shipment_scheme IN ('DIGITAL' , 'CROSS BORDER', 'RETAIL', 'DIRECT BILLING')
                THEN
                    NULL
                ELSE (SELECT 
                        MIN(ct.fk_campaign)
                    FROM
                        campaign_tracker ct
                    LEFT JOIN campaign_mapping cm ON ct.fk_campaign = cm.fk_campaign
                    WHERE
                        ae.bob_id_supplier = ct.bob_id_supplier
                            AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= ct.start_date
                            AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= ct.end_date
                            AND cm.shipment_scheme = ae.shipment_scheme
                            AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= cm.start_date
                            AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= cm.end_date)
            END 'fk_campaign'
    FROM
        (SELECT 
        ae.*, ss.shipment_scheme
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
            ae.shipping_surcharge,
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
            ae.tenor,
            ae.bank,
            ae.first_tracking_number,
            ae.first_shipment_provider,
            ae.last_tracking_number,
            ae.last_shipment_provider,
            CASE
				WHEN ae.origin IN ('Cross Border','DKI Jakarta','East Java','North Sumatera') THEN ae.origin
                ELSE 'DKI Jakarta'
            END 'origin',
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
            ae.bob_id_customer,
            ae.fast_delivery,
            ae.retail_cogs,
            ae.order_value,
            ae.shipping_fee,
            ae.shipping_fee_credit,
            ae.seller_cr_db_item,
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0) 'weight_3pl',
            IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0) 'volumetric_weight_3pl',
            (SELECT 
                    MIN(id_shipment_scheme)
                FROM
                    shipment_scheme ss
                WHERE
                    IFNULL(ae.tax_class, 1) = IFNULL(ss.tax_class, IFNULL(ae.tax_class, 1))
                        AND IFNULL(ae.delivery_type, 1) = IFNULL(ss.delivery_type, IFNULL(ae.delivery_type, 1))
                        AND IFNULL(ae.first_shipment_provider, 1) LIKE CONCAT('%', IFNULL(ss.first_shipment_provider, IFNULL(ae.first_shipment_provider, 1)), '%')
                        AND IFNULL(ae.last_shipment_provider, 1) LIKE CONCAT('%', IFNULL(ss.last_shipment_provider, IFNULL(ae.last_shipment_provider, 1)), '%')
                        AND ae.is_marketplace = IFNULL(ss.is_marketplace, ae.is_marketplace)
                        AND IFNULL(ae.shipping_type, 1) = IFNULL(ss.shipping_type, IFNULL(ae.shipping_type, 1))
                        AND ae.payment_method <> IFNULL(ss.exclude_payment_method, 0)
                        AND IFNULL(ae.first_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(ss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
                        AND IFNULL(ae.last_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(ss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
                        AND IFNULL(ae.shipping_fee_credit, 0) > IFNULL(ss.shipping_fee_credit, - 9999999999)
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= ss.start_date
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= ss.end_date) 'fk_shipment_scheme'
    FROM
        anondb_extract ae) ae
    LEFT JOIN shipment_scheme ss ON ae.fk_shipment_scheme = ss.id_shipment_scheme) ae) ae
    LEFT JOIN charges_scheme cs ON ae.fk_charges_scheme = cs.id_charges_scheme
    LEFT JOIN weight_threshold wt ON GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= wt.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= wt.end_date
    LEFT JOIN zone_mapping zm ON ae.id_district = zm.id_district
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= zm.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= zm.end_date) ae
    LEFT JOIN campaign cam ON ae.fk_campaign = cam.id_campaign
        AND IFNULL(ae.pickup_provider_type, 1) = IFNULL(cam.pickup_provider_type, IFNULL(ae.pickup_provider_type, 1))
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= cam.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= cam.end_date
    GROUP BY bob_id_sales_order_item) ae
    LEFT JOIN campaign_shipment_scheme css ON ae.fk_campaign = css.fk_campaign
        AND ae.shipment_scheme = css.shipment_scheme
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= css.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= css.end_date
    LEFT JOIN weight_threshold wt ON GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= wt.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= wt.end_date
    GROUP BY ae.id_package_dispatching , ae.order_nr , ae.bob_id_supplier) ae
    LEFT JOIN insurance_scheme ins_sel ON ae.shipment_scheme = ins_sel.shipment_scheme
        AND ins_sel.type = 'seller'
        AND IFNULL(ae.is_marketplace, 99) = IFNULL(ins_sel.is_marketplace, IFNULL(ae.is_marketplace, 99))
        AND ae.unit_price > ins_sel.min_unit_price
        AND ae.unit_price <= IFNULL(ins_sel.max_unit_price, ae.unit_price)
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= ins_sel.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= ins_sel.end_date
    LEFT JOIN insurance_scheme ins_3pl ON ae.shipment_scheme = ins_3pl.shipment_scheme
        AND ins_3pl.type = '3pl'
        AND IFNULL(ae.is_marketplace, 99) = IFNULL(ins_3pl.is_marketplace, IFNULL(ae.is_marketplace, 99))
        AND ae.unit_price > ins_3pl.min_unit_price
        AND ae.unit_price <= IFNULL(ins_3pl.max_unit_price, ae.unit_price)
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= ins_3pl.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= ins_3pl.end_date
    LEFT JOIN shipping_fee_rate_card_3pl scfr3pl ON ae.id_district = scfr3pl.id_district
        AND ae.origin = scfr3pl.origin
        AND ae.rate_card_scheme = scfr3pl.rate_card_scheme
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= scfr3pl.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= scfr3pl.end_date
        AND ae.chargeable_weight_3pl > scfr3pl.min_weight
        AND ae.chargeable_weight_3pl <= scfr3pl.max_weight) ae) ae;