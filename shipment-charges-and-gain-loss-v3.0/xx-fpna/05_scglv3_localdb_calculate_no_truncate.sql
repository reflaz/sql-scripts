/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Shipping Charges and Gain/Loss Grouping

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO scglv3.anondb_calculate 
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
    IFNULL(unit_price, 0),
    IFNULL(paid_price, 0),
    IFNULL(shipping_amount, 0),
    IFNULL(shipping_surcharge, 0),
    IFNULL(marketplace_commission_fee, 0),
    IFNULL(coupon_money_value, 0),
    IFNULL(cart_rule_discount, 0),
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
    tenor,
    bank,
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
    bob_id_customer,
    fast_delivery,
    IFNULL(retail_cogs, 0),
    IFNULL(order_value, 0),
    IFNULL(shipping_fee, 0),
    IFNULL(shipping_fee_credit, 0),
    IFNULL(seller_cr_db_item, 0),
    zone_type,
    weight_item_seller,
    is_package_weight_seller,
    formula_weight_seller,
    chargeable_weight_seller,
    weight_item_3pl,
    is_package_weight_3pl,
    formula_weight_3pl,
    chargeable_weight_3pl,
    shipment_scheme,
    rate_card_scheme,
    campaign,
    qty,
    rounding_seller,
    rounding_3pl,
    order_flat_rate,
	mdr_rate,
	ipp_rate,
    shipment_fee_mp_seller_rate,
    pickup_cost_rate,
    pickup_cost_discount_rate,
    pickup_cost_vat_rate,
    delivery_cost_vat_rate,
    insurance_rate_sel,
    insurance_vat_rate_sel,
    insurance_rate_3pl,
    insurance_vat_rate_3pl,
    flat_rate,
    shipment_cost_rate,
    shipment_cost_discount_rate,
    unit_price_pct,
    cust_charge_pct,
    weight_seller_pct,
    weight_3pl_pct,
    order_flat,
    mdr,
    ipp,
    shipment_fee_mp_seller_item,
    insurance_seller_item,
    insurance_vat_seller_item,
    shipment_cost_item,
    shipment_cost_discount_item,
    shipment_cost_vat_item,
    pickup_cost_item,
    pickup_cost_discount_item,
    pickup_cost_vat_item,
    insurance_3pl_item,
    insurance_vat_3pl_item,
    total_shipment_fee_mp_seller_item,
    total_delivery_cost_item,
    total_failed_delivery_cost_item
FROM
    (SELECT 
        *,
			cust_charge_pct * order_flat_rate 'order_flat',
            (paid_price + shipping_amount + shipping_surcharge) * mdr_rate 'mdr',
            (paid_price + shipping_amount + shipping_surcharge) * ipp_rate 'ipp',
            weight_seller_pct * shipment_fee_mp_seller 'shipment_fee_mp_seller_item',
            unit_price_pct * insurance_seller 'insurance_seller_item',
            unit_price_pct * insurance_vat_seller 'insurance_vat_seller_item',
            weight_3pl_pct * shipment_cost 'shipment_cost_item',
            weight_3pl_pct * shipment_cost_discount 'shipment_cost_discount_item',
            weight_3pl_pct * shipment_cost_vat 'shipment_cost_vat_item',
            weight_3pl_pct * pickup_cost 'pickup_cost_item',
            weight_3pl_pct * pickup_cost_discount 'pickup_cost_discount_item',
            weight_3pl_pct * pickup_cost_vat 'pickup_cost_vat_item',
            unit_price_pct * insurance_3pl 'insurance_3pl_item',
            unit_price_pct * insurance_vat_3pl 'insurance_vat_3pl_item',
            (weight_seller_pct * shipment_fee_mp_seller) + (unit_price_pct * insurance_seller) + (unit_price_pct * insurance_vat_seller) 'total_shipment_fee_mp_seller_item',
            (weight_3pl_pct * shipment_cost) + (weight_3pl_pct * shipment_cost_discount) + (weight_3pl_pct * shipment_cost_vat) + (weight_3pl_pct * pickup_cost) + (weight_3pl_pct * pickup_cost_discount) + (weight_3pl_pct * pickup_cost_vat) + (unit_price_pct * insurance_3pl) + (unit_price_pct * insurance_vat_3pl) 'total_delivery_cost_item',
            IF(not_delivered_date IS NOT NULL, (weight_3pl_pct * shipment_cost) + (weight_3pl_pct * shipment_cost_discount) + (weight_3pl_pct * shipment_cost_vat), 0) 'total_failed_delivery_cost_item'
    FROM
        (SELECT 
        *,
            unit_price / unit_price_pck 'unit_price_pct',
            (paid_price + shipping_amount + shipping_surcharge) / order_value 'cust_charge_pct',
            IFNULL(CASE
                WHEN is_package_weight_seller = 1 THEN weight_item
                ELSE volumetric_weight_item
            END, 0) 'weight_item_seller',
            IFNULL(CASE
                WHEN is_package_weight_3pl = 1 THEN temp_weight_item
                ELSE temp_volumetric_weight_item
            END, 0) 'weight_item_3pl',
            IFNULL(CASE
                WHEN is_package_weight_seller = 1 THEN weight_item / formula_weight_seller
                ELSE volumetric_weight_item / formula_weight_seller
            END, 0) 'weight_seller_pct',
            IFNULL(CASE
                WHEN is_package_weight_3pl = 1 THEN temp_weight_item / formula_weight_3pl
                ELSE temp_volumetric_weight_item / formula_weight_3pl
            END, 0) 'weight_3pl_pct'
    FROM
        (SELECT 
        ae.*,
            pcm.order_flat_rate,
            pcm.mdr_rate,
            pcm.ipp_rate,
            wt.item_threshold,
            wt.package_threshold,
            CASE
                WHEN GREATEST(temp_weight_item, temp_volumetric_weight_item) = 0 THEN 0
                WHEN
                    (CASE
                        WHEN GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)) = 0 THEN 0
                        WHEN GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)) < 1 THEN 1
                        WHEN MOD(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)), 1) <= IFNULL(ae.rounding_seller, 0) THEN FLOOR(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)))
                        ELSE CEIL(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)))
                    END) <= IFNULL(wt.item_threshold, 0)
                        AND ae.zone_type LIKE '%free%'
                THEN
                    0
                ELSE temp_weight_item
            END 'weight_item',
            CASE
                WHEN GREATEST(temp_weight_item, temp_volumetric_weight_item) = 0 THEN 0
                WHEN
                    (CASE
                        WHEN GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)) = 0 THEN 0
                        WHEN GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)) < 1 THEN 1
                        WHEN MOD(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)), 1) <= IFNULL(ae.rounding_seller, 0) THEN FLOOR(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)))
                        ELSE CEIL(GREATEST(IFNULL(ae.temp_weight_item, 0), IFNULL(ae.temp_volumetric_weight_item, 0)))
                    END) <= IFNULL(wt.item_threshold, 0)
                        AND ae.zone_type LIKE '%free%'
                THEN
                    0
                ELSE temp_volumetric_weight_item
            END 'volumetric_weight_item'
    FROM
        (SELECT 
        ae.*,
            (SELECT 
                    MIN(id_payment_cost_mapping)
                FROM
                    scglv3.payment_cost_mapping pcm
                WHERE
                    IFNULL(ae.payment_method, 1) = IFNULL(pcm.payment_method, ae.payment_method)
                        AND IFNULL(NULLIF(ae.tenor, ''), 1) = IFNULL(pcm.tenor, 1)
                        AND IFNULL(ae.bank, 1) = IFNULL(pcm.bank, 1)
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= pcm.start_date
                        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= pcm.end_date) 'fk_payment_cost_mapping',
            aet.unit_price 'unit_price_pck',
            aet.paid_price 'paid_price_pck',
            aet.shipping_amount 'shipping_amount_pck',
            aet.shipping_surcharge 'shipping_surcharge_pck',
            aet.package_weight,
            aet.volumetric_weight,
            aet.is_package_weight_seller,
            aet.formula_weight_seller,
            aet.chargeable_weight_seller,
            aet.is_package_weight_3pl,
            aet.formula_weight_3pl,
            aet.chargeable_weight_3pl,
            aet.zone_type,
            aet.shipment_scheme,
            aet.rate_card_scheme,
            aet.campaign,
            aet.qty,
            aet.rounding_seller,
            aet.rounding_3pl,
            aet.shipment_fee_mp_seller_rate,
            aet.pickup_cost_rate,
            aet.pickup_cost_discount_rate,
            aet.pickup_cost_vat_rate,
            aet.delivery_cost_vat_rate,
            aet.insurance_rate_tmp,
            aet.insurance_rate_sel,
            aet.insurance_vat_rate_sel,
            aet.insurance_rate_3pl,
            aet.insurance_vat_rate_3pl,
            aet.flat_rate,
            aet.shipment_cost_rate,
            aet.shipment_cost_discount_rate,
            aet.shipment_fee_mp_seller,
            aet.insurance_seller,
            aet.insurance_vat_seller,
            aet.shipment_cost,
            aet.aet.shipment_cost_discount,
            aet.shipment_cost_vat,
            aet.pickup_cost,
            aet.aet.pickup_cost_discount,
            aet.pickup_cost_vat,
            aet.insurance_3pl,
            aet.insurance_vat_3pl,
            aet.total_shipment_fee_mp_seller,
            aet.total_delivery_cost,
            aet.total_failed_delivery_cost,
            ROUND(IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    simple_weight
                ELSE config_weight
            END, 0), 4) 'temp_weight_item',
            ROUND(IFNULL(CASE
                WHEN
                    simple_weight > 0
                        OR (simple_length * simple_width * simple_height) > 0
                THEN
                    (simple_length * simple_width * simple_height) / 6000
                ELSE config_length * config_width * config_height / 6000
            END, 0), 4) 'temp_volumetric_weight_item'
    FROM
        (SELECT 
        *
    FROM
        scglv3.anondb_extract_temp) aet
    LEFT JOIN scglv3.anondb_extract ae ON aet.order_nr = ae.order_nr
        AND aet.bob_id_supplier = ae.bob_id_supplier
        AND IFNULL(aet.id_package_dispatching, 1) = IFNULL(ae.id_package_dispatching, 1)) ae
    LEFT JOIN scglv3.weight_threshold wt ON GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) >= wt.start_date
        AND GREATEST(ae.order_date, IFNULL(ae.first_shipped_date, 1)) <= wt.end_date
    LEFT JOIN scglv3.payment_cost_mapping pcm ON ae.fk_payment_cost_mapping = pcm.id_payment_cost_mapping) ae) ae) ae
ON DUPLICATE KEY UPDATE
	-- bob_id_sales_order_item = ae.bob_id_sales_order_item,
	-- sc_sales_order_item = ae.sc_sales_order_item,
	-- order_nr = ae.order_nr,
	-- payment_method = ae.payment_method,
	-- sku = ae.sku,
	-- primary_category = ae.primary_category,
	-- bob_id_supplier = ae.bob_id_supplier,
	-- short_code = ae.short_code,
	-- seller_name = ae.seller_name,
	-- seller_type = ae.seller_type,
	-- tax_class = ae.tax_class,
	unit_price = ae.unit_price,
	paid_price = ae.paid_price,
	shipping_amount = ae.shipping_amount,
	shipping_surcharge = ae.shipping_surcharge,
	-- marketplace_commission_fee = ae.marketplace_commission_fee,
	-- coupon_money_value = ae.coupon_money_value,
	-- cart_rule_discount = ae.cart_rule_discount,
	-- coupon_code = ae.coupon_code,
	-- coupon_type = ae.coupon_type,
	-- cart_rule_display_names = ae.cart_rule_display_names,
	last_status = ae.last_status,
	-- order_date = ae.order_date,
	first_shipped_date = ae.first_shipped_date,
	last_shipped_date = ae.last_shipped_date,
	delivered_date = ae.delivered_date,
	not_delivered_date = ae.not_delivered_date,
	closed_date = ae.closed_date,
	refund_completed_date = ae.refund_completed_date,
	-- pickup_provider_type = ae.pickup_provider_type,
	package_number = ae.package_number,
	id_package_dispatching = ae.id_package_dispatching,
	-- tenor = ae.tenor,
	-- bank = ae.bank,
	first_tracking_number = ae.first_tracking_number,
	first_shipment_provider = ae.first_shipment_provider,
	last_tracking_number = ae.last_tracking_number,
	last_shipment_provider = ae.last_shipment_provider,
	-- origin = ae.origin,
	-- city = ae.city,
	-- id_district = ae.id_district,
	config_length = ae.config_length,
	config_width = ae.config_width,
	config_height = ae.config_height,
	config_weight = ae.config_weight,
	simple_length = ae.simple_length,
	simple_width = ae.simple_width,
	simple_height = ae.simple_height,
	simple_weight = ae.simple_weight,
	-- shipping_type = ae.shipping_type,
	-- delivery_type = ae.delivery_type,
	-- is_marketplace = ae.is_marketplace,
	-- bob_id_customer = ae.bob_id_customer,
	-- fast_delivery = ae.fast_delivery,
	retail_cogs = ae.retail_cogs,
	order_value = ae.order_value,
	shipping_fee = ae.shipping_fee,
	shipping_fee_credit = ae.shipping_fee_credit,
	seller_cr_db_item = ae.seller_cr_db_item,
	zone_type = ae.zone_type,
	weight_item_seller = ae.weight_item_seller,
	is_package_weight_seller = ae.is_package_weight_seller,
	formula_weight_seller = ae.formula_weight_seller,
	chargeable_weight_seller = ae.chargeable_weight_seller,
	weight_item_3pl = ae.weight_item_3pl,
	is_package_weight_3pl = ae.is_package_weight_3pl,
	formula_weight_3pl = ae.formula_weight_3pl,
	chargeable_weight_3pl = ae.chargeable_weight_3pl,
	shipment_scheme = ae.shipment_scheme,
	rate_card_scheme = ae.rate_card_scheme,
	campaign = ae.campaign,
	qty = ae.qty,
	rounding_seller = ae.rounding_seller,
	rounding_3pl = ae.rounding_3pl,
    order_flat_rate = ae.order_flat_rate,
	mdr_rate = ae.mdr_rate,
	ipp_rate = ae.ipp_rate,
	shipment_fee_mp_seller_rate = ae.shipment_fee_mp_seller_rate,
	pickup_cost_rate = ae.pickup_cost_rate,
	pickup_cost_discount_rate = ae.pickup_cost_discount_rate,
	pickup_cost_vat_rate = ae.pickup_cost_vat_rate,
	delivery_cost_vat_rate = ae.delivery_cost_vat_rate,
	insurance_rate_sel = ae.insurance_rate_sel,
	insurance_vat_rate_sel = ae.insurance_vat_rate_sel,
	insurance_rate_3pl = ae.insurance_rate_3pl,
	insurance_vat_rate_3pl = ae.insurance_vat_rate_3pl,
	flat_rate = ae.flat_rate,
	shipment_cost_rate = ae.shipment_cost_rate,
	shipment_cost_discount_rate = ae.shipment_cost_discount_rate,
	unit_price_pct = ae.unit_price_pct,
	cust_charge_pct = ae.cust_charge_pct,
	weight_seller_pct = ae.weight_seller_pct,
	weight_3pl_pct = ae.weight_3pl_pct,
    order_flat = ae.order_flat,
    mdr = ae.mdr,
    ipp = ae.ipp, 
	shipment_fee_mp_seller_item = ae.shipment_fee_mp_seller_item,
	insurance_seller_item = ae.insurance_seller_item,
	insurance_vat_seller_item = ae.insurance_vat_seller_item,
	shipment_cost_item = ae.shipment_cost_item,
	shipment_cost_discount_item = ae.shipment_cost_discount_item,
	shipment_cost_vat_item = ae.shipment_cost_vat_item,
	pickup_cost_item = ae.pickup_cost_item, 
	pickup_cost_discount_item = ae.pickup_cost_discount_item,
	pickup_cost_vat_item = ae.pickup_cost_vat_item,
	insurance_3pl_item = ae.insurance_3pl_item,
	insurance_vat_3pl_item = ae.insurance_vat_3pl_item,
	total_shipment_fee_mp_seller_item = ae.total_shipment_fee_mp_seller_item,
	total_delivery_cost_item = ae.total_delivery_cost_item,
	total_failed_delivery_cost_item = ae.total_failed_delivery_cost_item;