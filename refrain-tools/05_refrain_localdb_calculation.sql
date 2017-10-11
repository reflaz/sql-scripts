/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Calculation

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain;

SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Map shipment scheme and default shipping charge components
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
    JOIN map_shipment_scheme mss ON til.payment_method <> IFNULL(mss.exclude_payment_method, '')
        AND IFNULL(til.tax_class, 'tax_class') = IFNULL(mss.tax_class, IFNULL(til.tax_class, 'tax_class'))
        AND IFNULL(til.is_marketplace, 0) = COALESCE(mss.is_marketplace, til.is_marketplace, 0)
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', COALESCE(mss.first_shipment_provider, til.first_shipment_provider, 'first_shipment_provider'), '%')
        AND IFNULL(til.last_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', COALESCE(mss.last_shipment_provider, til.last_shipment_provider, 'first_shipment_provider'), '%')
        AND IFNULL(til.first_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(til.last_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(til.shipping_type, 'shipping_type') = COALESCE(mss.shipping_type, til.shipping_type, 'shipping_type')
        AND IFNULL(til.delivery_type, 'delivery_type') = COALESCE(mss.delivery_type, til.delivery_type, 'delivery_type')
        AND IFNULL(til.auto_shipping_fee_credit, 0) < IFNULL(mss.auto_shipping_fee_credit, 1)
        AND IFNULL(til.api_type, 0) = IFNULL(mss.api_type, IFNULL(til.api_type, 0))
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mss.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mss.end_date
    JOIN map_default_charges mdc ON mss.shipment_scheme = mdc.shipment_scheme
        AND til.is_marketplace = IFNULL(mdc.is_marketplace, til.is_marketplace)
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', COALESCE(mdc.first_shipment_provider, til.first_shipment_provider, 'first_shipment_provider'), '%')
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mdc.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mdc.end_date
    JOIN map_weight_threshold_seller mwts ON GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mwts.end_date
    JOIN (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
    LEFT JOIN map_default_insurance mdisel ON mdc.rate_card_scheme = mdisel.rate_card_scheme
        AND mdisel.type = 'seller'
        AND til.is_marketplace = mdisel.is_marketplace
        AND pckval.package_value > mdisel.min_package_value
        AND pckval.package_value <= IFNULL(mdisel.max_package_value, pckval.package_value)
    LEFT JOIN map_default_insurance mdi3pl ON mdc.rate_card_scheme = mdi3pl.rate_card_scheme
        AND mdi3pl.type = '3pl'
        AND pckval.package_value > mdi3pl.min_package_value
        AND pckval.package_value <= IFNULL(mdi3pl.max_package_value, pckval.package_value)
SET
	til.shipment_scheme = mss.shipment_scheme,
    til.item_weight_seller = CASE
			WHEN mwts.item_weight_threshold IS NULL THEN til.item_weight_seller
			WHEN til.item_weight_seller <= mwts.item_weight_threshold THEN til.item_weight_seller
            ELSE CASE
				WHEN mwts.item_weight_no_bulky = 1 THEN 0
                WHEN mwts.item_weight_offset = 1 THEN item_weight_seller - item_weight_threshold
                WHEN mwts.item_weight_max = 1 THEN item_weight_threshold
                ELSE 0
            END
		END,
	til.item_weight_seller_flag = CASE
			WHEN mwts.item_weight_threshold IS NOT NULL THEN 3
            ELSE 0
		END,
	til.rounding_seller = IFNULL(mdc.rounding_seller, 0),
	til.seller_flat_charge_rate = IFNULL(mdc.seller_flat_charge_rate, 0),
	til.seller_charge_rate = IFNULL(mdc.seller_charge_rate, 0),
    til.insurance_rate_sel = IFNULL(mdisel.insurance_rate, 0),
	til.insurance_vat_rate_sel = IFNULL(mdisel.insurance_vat_rate, 0),
	til.rate_card_scheme = IFNULL(mdc.rate_card_scheme, 0),
	til.rounding_3pl = IFNULL(mdc.rounding_3pl, 0),
	til.pickup_cost_rate = IFNULL(mdc.pickup_cost_rate, 0),
	til.pickup_cost_discount_rate = IFNULL(mdc.pickup_cost_discount_rate, 0),
	til.pickup_cost_vat_rate = IFNULL(mdc.pickup_cost_vat_rate, 0),
	til.delivery_cost_vat_rate = IFNULL(mdc.delivery_cost_vat_rate, 0),
    til.insurance_rate_3pl = IFNULL(mdi3pl.insurance_rate, 0),
	til.insurance_vat_rate_3pl = IFNULL(mdi3pl.insurance_vat_rate, 0);

/*-----------------------------------------------------------------------------------------------------------------------------------
Map seller campaign and override seller charge components
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
		JOIN
	map_campaign_tracker mct ON til.bob_id_supplier = mct.bob_id_supplier
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mct.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mct.end_date
        JOIN
	map_campaign mcam ON mct.fk_campaign = mcam.id_campaign
        AND IFNULL(til.pickup_provider_type, 'pickup_provider_type') = COALESCE(mcam.pickup_provider_type, til.pickup_provider_type, 'pickup_provider_type')
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mcam.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mcam.end_date
        JOIN
	map_campaign_access mca ON mcam.id_campaign = mca.fk_campaign
        AND til.shipment_scheme = mca.shipment_scheme
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mca.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mca.end_date
        LEFT JOIN
	map_campaign_override mco ON mcam.id_campaign = mco.fk_campaign
        AND til.shipment_scheme = mco.shipment_scheme
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mco.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mco.end_date
SET
	til.campaign = mcam.campaign,
	til.seller_flat_charge_rate = COALESCE(mco.seller_flat_charge_rate, mcam.seller_flat_charge_rate, til.seller_flat_charge_rate, 0),
	til.seller_charge_rate = COALESCE(mco.seller_charge_rate, mcam.seller_charge_rate, til.seller_charge_rate, 0),
	til.insurance_rate_sel = COALESCE(mcam.insurance_rate, til.insurance_rate_sel, 0);

/*-----------------------------------------------------------------------------------------------------------------------------------
Group data by order number, supplier ID, and dispatching ID
-----------------------------------------------------------------------------------------------------------------------------------*/

TRUNCATE tmp_package_level;

INSERT INTO tmp_package_level
SELECT 
    bob_id_sales_order_item,
    order_nr,
    payment_method,
    bob_id_supplier,
    seller_type,
    tax_class,
    is_marketplace,
    order_value,
    payment_value,
    unit_price_tmp 'unit_price',
    paid_price_tmp 'paid_price',
    shipping_amount_tmp 'shipping_amount',
    shipping_surcharge_tmp 'shipping_surcharge',
    order_date,
    finance_verified_date,
    first_shipped_date,
    last_shipped_date,
    delivered_date,
    failed_delivery_date,
    origin,
    id_district,
    pickup_provider_type,
    id_package_dispatching,
    first_shipment_provider,
    last_shipment_provider,
    shipping_type,
    delivery_type,
    auto_shipping_fee_credit 'auto_shipping_fee_credit',
    manual_shipping_fee_tmp 'manual_shipping_fee',
    api_type,
    shipment_scheme,
    campaign,
    weight_tmp 'weight',
    volumetric_weight_tmp 'volumetric_weight',
    item_weight_seller_tmp 'item_weight_seller',
    item_weight_seller_flag_tmp 'item_weight_seller_flag',
    rounding_seller,
    formula_weight_seller_tmp 'formula_weight_seller',
    formula_weight_seller_tmp 'chargeable_weight_seller',
    seller_flat_charge_rate,
    seller_charge_rate,
    insurance_rate_sel,
    insurance_vat_rate_sel,
    weight_seller_pct,
    seller_flat_charge,
    seller_charge,
    insurance_seller,
    insurance_vat_seller,
    rate_card_scheme,
    rounding_3pl,
    formula_weight_3pl_tmp 'formula_weight_3pl',
    formula_weight_3pl_tmp 'chargeable_weight_3pl',
    pickup_cost_rate,
    pickup_cost_discount_rate,
    pickup_cost_vat_rate,
    delivery_flat_cost_rate,
    delivery_cost_rate,
    delivery_cost_discount_rate,
    delivery_cost_vat_rate,
    insurance_rate_3pl,
    insurance_vat_rate_3pl,
    weight_3pl_pct,
    pickup_cost,
    pickup_cost_discount,
    pickup_cost_vat,
    delivery_flat_cost,
    delivery_cost,
    delivery_cost_discount,
    delivery_cost_vat,
    insurance_3pl,
    insurance_vat_3pl,
    total_customer_charge,
    total_seller_charge,
    total_pickup_cost,
    total_delivery_cost,
    total_failed_delivery_cost
FROM
    (SELECT 
        *,
            SUM(IFNULL(unit_price, 0)) 'unit_price_tmp',
            SUM(IFNULL(paid_price, 0)) 'paid_price_tmp',
            SUM(IFNULL(shipping_amount, 0)) 'shipping_amount_tmp',
            SUM(IFNULL(shipping_surcharge, 0)) 'shipping_surcharge_tmp',
            SUM(IFNULL(auto_shipping_fee_credit, 0)) 'auto_shipping_fee_credit_tmp',
            SUM(IFNULL(manual_shipping_fee, 0)) 'manual_shipping_fee_tmp',
            SUM(IFNULL(weight, 0)) 'weight_tmp',
            SUM(IFNULL(volumetric_weight, 0)) 'volumetric_weight_tmp',
            SUM(IFNULL(item_weight_seller, 0)) 'item_weight_seller_tmp',
            CASE
                WHEN item_weight_seller_flag = 3 THEN SUM(IFNULL(item_weight_seller, 0))
                ELSE GREATEST(SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0)))
            END 'formula_weight_seller_tmp',
            CASE
                WHEN item_weight_seller_flag = 3 THEN 3
                WHEN SUM(IFNULL(volumetric_weight, 0)) > SUM(IFNULL(weight, 0)) THEN 2
                ELSE 1
            END 'item_weight_seller_flag_tmp',
            GREATEST(SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0))) 'formula_weight_3pl_tmp'
    FROM
        tmp_item_level til
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) tpl;

/*-----------------------------------------------------------------------------------------------------------------------------------
Map 3pl charge components to API data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_package_level tpl
        JOIN
    api_data_direct_billing delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type IN ('DELIVERY')
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
SET
    tpl.chargeable_weight_3pl = COALESCE(delv.rounded_weight, delv.formula_weight, 0),
    tpl.delivery_cost = IFNULL(delv.amount, 0),
    tpl.delivery_cost_vat = IFNULL(delv.tax_amount, 0),
    tpl.total_delivery_cost = IFNULL(delv.total_amount, 0),
    tpl.total_failed_delivery_cost = 0,
    tpl.pickup_cost = 0,
    tpl.pickup_cost_vat = 0,
    tpl.total_pickup_cost = 0,
    tpl.insurance_3pl = 0,
    tpl.insurance_vat_3pl = 0
WHERE
	tpl.api_type = 1;

UPDATE tmp_package_level tpl
        LEFT JOIN
    api_data_master_account delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type IN ('DELIVERY')
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account fdel ON tpl.id_package_dispatching = fdel.id_package_dispatching
        AND tpl.bob_id_supplier = fdel.bob_id_supplier
        AND fdel.posting_type = 'INCOMING'
        AND fdel.charge_type IN ('FAILED DELIVERY')
        AND fdel.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account pckc ON tpl.id_package_dispatching = pckc.id_package_dispatching
        AND tpl.bob_id_supplier = pckc.bob_id_supplier
        AND pckc.posting_type = 'INCOMING'
        AND pckc.charge_type IN ('PICKUP')
        AND pckc.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account ins ON tpl.id_package_dispatching = ins.id_package_dispatching
        AND tpl.bob_id_supplier = ins.bob_id_supplier
        AND ins.posting_type = 'INCOMING'
        AND ins.charge_type IN ('INSURANCE')
        AND ins.status IN ('COMPLETE' , 'ACTIVE')
SET
    tpl.chargeable_weight_3pl = COALESCE(delv.rounded_weight, delv.formula_weight, fdel.rounded_weight, fdel.formula_weight),
    tpl.delivery_cost = COALESCE(delv.amount, fdel.amount, 0),
    tpl.delivery_cost_vat = COALESCE(delv.tax_amount, fdel.tax_amount, 0),
    tpl.total_delivery_cost = IFNULL(delv.total_amount, 0) + IFNULL(ins.total_amount, 0),
    tpl.total_failed_delivery_cost = IFNULL(fdel.total_amount, 0),
    tpl.pickup_cost = IFNULL(pckc.amount, 0),
    tpl.pickup_cost_vat = IFNULL(pckc.tax_amount, 0),
    tpl.total_pickup_cost = IFNULL(pckc.total_amount, 0),
    tpl.insurance_3pl = IFNULL(ins.amount, 0),
    tpl.insurance_vat_3pl = IFNULL(ins.tax_amount, 0)
WHERE
	tpl.api_type = 2;

SET SQL_SAFE_UPDATES = 1;