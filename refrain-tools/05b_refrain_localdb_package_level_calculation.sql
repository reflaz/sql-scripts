/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Package Level Calculation

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
Map 3pl charge components to API data and calculate shipping charge components on package-seller level
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_package_level tpl
        LEFT JOIN
    api_data_direct_billing delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type = 'DELIVERY'
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
	map_weight_threshold_seller mwts ON GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mwts.end_date
SET
    tpl.chargeable_weight_seller = COALESCE(delv.rounded_weight, delv.formula_weight, 0),
    tpl.chargeable_weight_seller = CASE
			WHEN tpl.chargeable_weight_seller = 0 THEN 0
			WHEN tpl.chargeable_weight_seller < 1 THEN 1
			WHEN MOD(tpl.chargeable_weight_seller, 1) <= tpl.rounding_seller THEN FLOOR(tpl.chargeable_weight_seller)
			ELSE CEIL(tpl.chargeable_weight_seller)
		END,
	tpl.chargeable_weight_seller = CASE
			WHEN mwts.package_weight_threshold IS NULL THEN tpl.chargeable_weight_seller
			WHEN tpl.chargeable_weight_seller <= mwts.package_weight_threshold THEN tpl.chargeable_weight_seller
			ELSE CASE
				WHEN mwts.package_weight_no_bulky = 1 THEN 0
				WHEN mwts.package_weight_offset = 1 THEN tpl.chargeable_weight_seller - mwts.package_weight_threshold
				WHEN mwts.package_weight_max = 1 THEN mwts.package_weight_threshold
				ELSE 0
			END
		END,
	tpl.seller_flat_charge = 0,
	tpl.seller_charge = IFNULL(tpl.chargeable_weight_seller, 0) * IFNULL(tpl.seller_charge_rate, 0),
    tpl.insurance_seller = 0,
    tpl.insurance_vat_seller = 0,
    tpl.chargeable_weight_3pl = COALESCE(delv.rounded_weight, delv.formula_weight, 0),
    tpl.pickup_cost = 0,
    tpl.pickup_cost_discount = 0,
    tpl.pickup_cost_vat = 0,
    tpl.delivery_cost = IFNULL(delv.amount, 0),
    tpl.delivery_cost_discount = IFNULL(delv.discount, 0),
    tpl.delivery_cost_vat = IFNULL(delv.tax_amount, 0),
    tpl.insurance_3pl = 0,
    tpl.insurance_vat_3pl = 0,
    tpl.total_seller_charge = IFNULL(tpl.seller_flat_charge, 0) + IFNULL(tpl.seller_charge, 0) + IFNULL(tpl.insurance_seller, 0) + IFNULL(tpl.insurance_vat_seller, 0),
    tpl.total_pickup_cost = 0,
    tpl.total_delivery_cost = IFNULL(delv.total_amount, 0),
    tpl.total_failed_delivery_cost = 0
WHERE
	tpl.api_type = 1;

UPDATE tmp_package_level tpl
        LEFT JOIN
    api_data_master_account delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type = 'DELIVERY'
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account fdel ON tpl.id_package_dispatching = fdel.id_package_dispatching
        AND tpl.bob_id_supplier = fdel.bob_id_supplier
        AND fdel.posting_type = 'INCOMING'
        AND fdel.charge_type = 'FAILED DELIVERY'
        AND fdel.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account pckc ON tpl.id_package_dispatching = pckc.id_package_dispatching
        AND tpl.bob_id_supplier = pckc.bob_id_supplier
        AND pckc.posting_type = 'INCOMING'
        AND pckc.charge_type = 'PICKUP'
        AND pckc.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account cod ON tpl.id_package_dispatching = cod.id_package_dispatching
        AND tpl.bob_id_supplier = cod.bob_id_supplier
        AND cod.posting_type = 'INCOMING'
        AND cod.charge_type = 'COD'
        AND cod.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account ins ON tpl.id_package_dispatching = ins.id_package_dispatching
        AND tpl.bob_id_supplier = ins.bob_id_supplier
        AND ins.posting_type = 'INCOMING'
        AND ins.charge_type = 'INSURANCE'
        AND ins.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
	map_weight_threshold_seller mwts ON GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mwts.end_date
SET
	tpl.payment_mdr_cost = cod.total_amount,
	tpl.chargeable_weight_seller = COALESCE(delv.rounded_weight, delv.formula_weight, fdel.rounded_weight, fdel.formula_weight, 0),
	tpl.chargeable_weight_seller = CASE
			WHEN tpl.chargeable_weight_seller = 0 THEN 0
			WHEN tpl.chargeable_weight_seller < 1 THEN 1
			WHEN MOD(tpl.chargeable_weight_seller, 1) <= tpl.rounding_seller THEN FLOOR(tpl.chargeable_weight_seller)
			ELSE CEIL(tpl.chargeable_weight_seller)
		END,
	tpl.chargeable_weight_seller = CASE
			WHEN mwts.package_weight_threshold IS NULL THEN tpl.chargeable_weight_seller
			WHEN tpl.chargeable_weight_seller <= mwts.package_weight_threshold THEN tpl.chargeable_weight_seller
			ELSE CASE
				WHEN mwts.package_weight_no_bulky = 1 THEN 0
				WHEN mwts.package_weight_offset = 1 THEN tpl.chargeable_weight_seller - mwts.package_weight_threshold
				WHEN mwts.package_weight_max = 1 THEN mwts.package_weight_threshold
				ELSE 0
			END
		END,
	tpl.seller_flat_charge = IFNULL(tpl.seller_flat_charge_rate, 0),
	tpl.seller_charge = IFNULL(tpl.chargeable_weight_seller, 0) * IFNULL(tpl.seller_charge_rate, 0),
    tpl.insurance_seller = CASE
			WHEN tpl.insurance_rate_seller = 0 THEN 0
			ELSE IFNULL(ins.amount, 0) * -1
		END,
    tpl.insurance_vat_seller = CASE
			WHEN tpl.insurance_rate_seller = 0 THEN 0
			ELSE IFNULL(ins.tax_amount, 0) * -1
		END,
    tpl.chargeable_weight_3pl = COALESCE(delv.rounded_weight, delv.formula_weight, fdel.rounded_weight, fdel.formula_weight, 0),
    tpl.pickup_cost = IFNULL(pckc.amount, 0),
    tpl.pickup_cost_discount = IFNULL(pckc.discount, 0),
    tpl.pickup_cost_vat = IFNULL(pckc.tax_amount, 0),
    tpl.delivery_cost = COALESCE(delv.amount, fdel.amount, 0),
    tpl.delivery_cost_discount = COALESCE(delv.discount, fdel.discount, 0),
    tpl.delivery_cost_vat = COALESCE(delv.tax_amount, fdel.tax_amount, 0),
    tpl.insurance_3pl = IFNULL(ins.amount, 0),
    tpl.insurance_vat_3pl = IFNULL(ins.tax_amount, 0),
    tpl.total_seller_charge = IFNULL(tpl.seller_flat_charge, 0) + IFNULL(tpl.seller_charge, 0) + IFNULL(tpl.insurance_seller, 0) + IFNULL(tpl.insurance_vat_seller, 0),
    tpl.total_pickup_cost = IFNULL(pckc.total_amount, 0),
    tpl.total_delivery_cost = CASE
			WHEN delv.id_api_master_account IS NOT NULL THEN IFNULL(delv.total_amount, 0) + IFNULL(ins.total_amount, 0)
            WHEN fdel.id_api_master_account IS NOT NULL THEN (IFNULL(fdel.total_amount, 0) / 2) + IFNULL(ins.total_amount, 0)
            ELSE 0
		END,
    tpl.total_failed_delivery_cost = IFNULL(fdel.total_amount, 0) / 2
WHERE
	tpl.api_type = 2;

/*-----------------------------------------------------------------------------------------------------------------------------------
Calculate shipping charge for Non-API data on package-seller data
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_package_level tpl
    LEFT JOIN map_origin_mapping mom ON IFNULL(tpl.origin, 'origin') = COALESCE(mom.origin, tpl.origin, 'origin')
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mom.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mom.end_date
    LEFT JOIN map_rate_card_3pl mrc3 ON tpl.id_district = mrc3.id_district
        AND mom.origin_mapping = mrc3.origin
        AND tpl.rate_card_scheme = mrc3.rate_card_scheme
        AND tpl.chargeable_weight_3pl > mrc3.min_weight
        AND tpl.chargeable_weight_3pl <= mrc3.max_weight
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mrc3.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mrc3.end_date
    LEFT JOIN map_weight_threshold_seller mwts ON GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(tpl.order_date, IFNULL(tpl.first_shipped_date, '1900-01-01')) <= mwts.end_date
SET
	tpl.chargeable_weight_seller = CASE
			WHEN mwts.package_weight_threshold IS NULL THEN tpl.chargeable_weight_seller
			WHEN tpl.chargeable_weight_seller <= mwts.package_weight_threshold THEN tpl.chargeable_weight_seller
			ELSE CASE
				WHEN mwts.package_weight_no_bulky = 1 THEN 0
				WHEN mwts.package_weight_offset = 1 THEN tpl.chargeable_weight_seller - mwts.package_weight_threshold
				WHEN mwts.package_weight_max = 1 THEN mwts.package_weight_threshold
				ELSE 0
			END
		END,
	tpl.seller_flat_charge = IFNULL(tpl.seller_flat_charge_rate, 0),
	tpl.seller_charge = IFNULL(tpl.chargeable_weight_seller, 0) * IFNULL(tpl.seller_charge_rate, 0),
	tpl.delivery_flat_cost_rate = IFNULL(mrc3.delivery_flat_cost_rate, 0),
	tpl.delivery_cost_rate = IFNULL(mrc3.delivery_cost_rate, 0),
	tpl.delivery_cost_discount_rate = IFNULL(mrc3.delivery_cost_discount_rate, 0),
	tpl.pickup_cost = - IFNULL(tpl.chargeable_weight_3pl, 0) * IFNULL(tpl.pickup_cost_rate, 0),
    tpl.pickup_cost_discount = IFNULL(tpl.chargeable_weight_3pl, 0) * IFNULL(tpl.pickup_cost_rate, 0) * IFNULL(tpl.pickup_cost_discount_rate, 0),
    tpl.pickup_cost_vat = (IFNULL(tpl.pickup_cost, 0) + IFNULL(tpl.pickup_cost_discount, 0)) * IFNULL(tpl.pickup_cost_vat_rate, 0),
    tpl.delivery_flat_cost = IFNULL(mrc3.delivery_flat_cost_rate, 0),
	tpl.delivery_cost = - IFNULL(tpl.chargeable_weight_3pl, 0) * IFNULL(mrc3.delivery_cost_rate, 0),
	tpl.delivery_cost_discount = IFNULL(tpl.chargeable_weight_3pl, 0) * IFNULL(mrc3.delivery_cost_rate, 0) * IFNULL(mrc3.delivery_cost_discount_rate, 0),
	tpl.delivery_cost_vat = (IFNULL(tpl.delivery_cost, 0) + IFNULL(tpl.delivery_cost_discount, 0)) * IFNULL(tpl.delivery_cost_vat_rate, 0),
    tpl.total_seller_charge = CASE
			WHEN tpl.manual_shipping_fee_lzd > 0 THEN tpl.manual_shipping_fee_lzd
			ELSE IFNULL(tpl.seller_flat_charge, 0) + IFNULL(tpl.seller_charge, 0) + IFNULL(tpl.insurance_seller, 0) + IFNULL(tpl.insurance_vat_seller, 0)
		END,
	tpl.total_pickup_cost = IFNULL(tpl.pickup_cost, 0) + IFNULL(tpl.pickup_cost_discount, 0) + IFNULL(tpl.pickup_cost_vat, 0),
	tpl.total_delivery_cost = IFNULL(tpl.delivery_flat_cost, 0) + IFNULL(tpl.delivery_cost, 0) + IFNULL(tpl.delivery_cost_discount, 0) + IFNULL(tpl.delivery_cost_vat, 0) + IFNULL(tpl.insurance_3pl, 0) + IFNULL(tpl.insurance_vat_3pl, 0),
	tpl.total_failed_delivery_cost = CASE
			WHEN tpl.failed_delivery_date IS NOT NULL THEN IFNULL(tpl.delivery_cost, 0) + IFNULL(tpl.delivery_cost_discount, 0) + IFNULL(tpl.delivery_cost_vat, 0)
            ELSE 0
		END
WHERE
	tpl.api_type = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Calculate shipping charges on item level
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
		LEFT JOIN
	tmp_package_level tpl ON til.order_nr = tpl.order_nr
        AND til.bob_id_supplier = tpl.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(tpl.id_package_dispatching, 1)
SET
	til.package_seller_value = tpl.package_seller_value,
    til.payment_mdr_cost = ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0) * IFNULL(tpl.payment_mdr_cost, 0), 4),
	til.item_weight_flag_seller = tpl.item_weight_flag_seller,
	til.weight_seller_pct = CASE
			WHEN tpl.formula_weight_3pl = 0 OR tpl.formula_weight_3pl IS NULL THEN ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0), 4)
			WHEN tpl.item_weight_flag_3pl = 1 THEN ROUND(IFNULL(til.weight, 0) / IFNULL(tpl.weight, 0), 4)
			WHEN tpl.item_weight_flag_3pl = 2 THEN ROUND(IFNULL(til.volumetric_weight, 0) / IFNULL(tpl.volumetric_weight, 0), 4)
            ELSE 0
		END,
	til.formula_weight_seller = CASE
			WHEN tpl.item_weight_flag_seller = 1 THEN IFNULL(til.weight, 0)
			WHEN tpl.item_weight_flag_seller = 2 THEN IFNULL(til.volumetric_weight, 0)
			WHEN tpl.item_weight_flag_seller = 3 THEN IFNULL(til.item_weight_seller, 0)
            ELSE 0
		END,
	til.chargeable_weight_seller = ROUND(IFNULL(til.weight_seller_pct, 0) * IFNULL(tpl.chargeable_weight_seller, 0), 4),
    til.seller_flat_charge = ROUND(IFNULL(til.weight_seller_pct, 0) * IFNULL(tpl.seller_flat_charge, 0), 4),
    til.seller_charge = ROUND(IFNULL(til.weight_seller_pct, 0) * IFNULL(tpl.seller_charge, 0), 4),
    til.insurance_seller = ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0) * IFNULL(tpl.insurance_seller, 0), 4),
    til.insurance_vat_seller = ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0) * IFNULL(tpl.insurance_vat_seller, 0), 4),
    til.weight_3pl_pct = CASE
			WHEN tpl.formula_weight_3pl = 0 OR tpl.formula_weight_3pl IS NULL THEN ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0), 4)
			WHEN tpl.item_weight_flag_3pl = 1 THEN ROUND(IFNULL(til.weight, 0) / IFNULL(tpl.weight, 0), 4)
			WHEN tpl.item_weight_flag_3pl = 2 THEN ROUND(IFNULL(til.volumetric_weight, 0) / IFNULL(tpl.volumetric_weight, 0), 4)
            ELSE 0
		END,
	til.formula_weight_3pl = CASE
			WHEN tpl.item_weight_flag_3pl = 1 THEN IFNULL(til.weight, 0)
			WHEN tpl.item_weight_flag_3pl = 2 THEN IFNULL(til.volumetric_weight, 0)
            ELSE 0
		END,
	til.chargeable_weight_3pl = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.chargeable_weight_3pl, 0), 4),
    til.pickup_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.pickup_cost, 0), 4),
    til.pickup_cost_discount = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.pickup_cost_discount, 0), 4),
    til.pickup_cost_vat = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.pickup_cost_vat, 0), 4),
    til.delivery_flat_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.delivery_flat_cost, 0), 4),
    til.delivery_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.delivery_cost, 0), 4),
    til.delivery_cost_discount = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.delivery_cost_discount, 0), 4),
    til.delivery_cost_vat = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.delivery_cost_vat, 0), 4),
    til.insurance_3pl = ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0) * IFNULL(tpl.insurance_3pl, 0), 4),
    til.insurance_vat_3pl = ROUND(IFNULL(til.unit_price, 0) / IFNULL(tpl.package_seller_value, 0) * IFNULL(tpl.insurance_vat_3pl, 0), 4),
    til.total_seller_charge = ROUND(IFNULL(til.weight_seller_pct, 0) * IFNULL(tpl.total_seller_charge, 0), 4),
    til.total_pickup_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.total_pickup_cost, 0), 4),
    til.total_delivery_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.total_delivery_cost, 0), 4),
    til.total_failed_delivery_cost = ROUND(IFNULL(til.weight_3pl_pct, 0) * IFNULL(tpl.total_failed_delivery_cost, 0), 4);

/*-----------------------------------------------------------------------------------------------------------------------------------
Insert/Update Sales Order Item Table
-----------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO fms_sales_order_item
SELECT 
    *
FROM
    (SELECT 
        bob_id_sales_order_item,
		sc_id_sales_order_item,
        oms_id_sales_order_item,
		order_nr,
		payment_method,
		tenor,
		bank,
		sku,
		primary_category,
		bob_id_supplier,
		short_code,
		seller_name,
		seller_type,
		tax_class,
		is_marketplace,
		order_value,
		payment_value,
		unit_price,
		paid_price,
		shipping_amount,
		shipping_surcharge,
		coupon_money_value,
		cart_rule_discount,
		retail_cogs,
		coupon_type,
		last_status,
		order_date,
		finance_verified_date,
		first_shipped_date,
		last_shipped_date,
		delivered_date,
		failed_delivery_date,
		origin,
		id_district,
		bob_id_customer,
		pickup_provider_type,
		id_package_dispatching,
		package_number,
		first_tracking_number,
		first_shipment_provider,
		last_tracking_number,
		last_shipment_provider,
		shipping_type,
		delivery_type,
		commission,
		commission_adjustment,
		payment_fee,
		payment_fee_adjustment,
		auto_shipping_fee,
		manual_shipping_fee_lzd,
		manual_shipping_fee_3p,
		shipping_fee_adjustment,
		package_seller_value,
		payment_flat_cost,
		payment_mdr_cost,
		payment_ipp_cost,
		api_type,
		shipment_scheme,
		campaign,
		weight,
		volumetric_weight,
		item_weight_seller,
		item_weight_flag_seller,
		formula_weight_seller,
		chargeable_weight_seller,
		weight_seller_pct,
		seller_flat_charge,
		seller_charge,
		insurance_seller,
		insurance_vat_seller,
		rate_card_scheme,
		item_weight_flag_3pl,
		formula_weight_3pl,
		chargeable_weight_3pl,
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
		total_failed_delivery_cost,
		created_at,
		updated_at
    FROM
        tmp_item_level) til
ON DUPLICATE KEY UPDATE
	bob_id_sales_order_item = til.bob_id_sales_order_item,
	sc_id_sales_order_item = til.sc_id_sales_order_item,
    oms_id_sales_order_item = til.oms_id_sales_order_item,
	order_nr = til.order_nr,
	payment_method = til.payment_method,
	tenor = til.tenor,
	bank = til.bank,
	sku = til.sku,
	primary_category = til.primary_category,
	bob_id_supplier = til.bob_id_supplier,
	short_code = til.short_code,
	seller_name = til.seller_name,
	seller_type = til.seller_type,
	tax_class = til.tax_class,
	is_marketplace = til.is_marketplace,
	order_value = til.order_value,
	payment_value = til.payment_value,
	unit_price = til.unit_price,
	paid_price = til.paid_price,
	shipping_amount = til.shipping_amount,
	shipping_surcharge = til.shipping_surcharge,
	coupon_money_value = til.coupon_money_value,
	cart_rule_discount = til.cart_rule_discount,
	retail_cogs = til.retail_cogs,
	coupon_type = til.coupon_type,
	last_status = til.last_status,
	order_date = til.order_date,
	finance_verified_date = til.finance_verified_date,
	first_shipped_date = til.first_shipped_date,
	last_shipped_date = til.last_shipped_date,
	delivered_date = til.delivered_date,
	failed_delivery_date = til.failed_delivery_date,
	origin = til.origin,
	id_district = til.id_district,
	bob_id_customer = til.bob_id_customer,
	pickup_provider_type = til.pickup_provider_type,
	id_package_dispatching = til.id_package_dispatching,
	package_number = til.package_number,
	first_tracking_number = til.first_tracking_number,
	first_shipment_provider = til.first_shipment_provider,
	last_tracking_number = til.last_tracking_number,
	last_shipment_provider = til.last_shipment_provider,
	shipping_type = til.shipping_type,
	delivery_type = til.delivery_type,
	commission = til.commission,
	commission_adjustment = til.commission_adjustment,
	payment_fee = til.payment_fee,
	payment_fee_adjustment = til.payment_fee_adjustment,
	auto_shipping_fee = til.auto_shipping_fee,
	manual_shipping_fee_lzd = til.manual_shipping_fee_lzd,
	manual_shipping_fee_3p = til.manual_shipping_fee_3p,
	shipping_fee_adjustment = til.shipping_fee_adjustment,
	package_seller_value = til.package_seller_value,
	payment_flat_cost = til.payment_flat_cost,
	payment_mdr_cost = til.payment_mdr_cost,
	payment_ipp_cost = til.payment_ipp_cost,
	api_type = til.api_type,
	shipment_scheme = til.shipment_scheme,
	campaign = til.campaign,
	weight = til.weight,
	volumetric_weight = til.volumetric_weight,
	item_weight_seller = til.item_weight_seller,
	item_weight_flag_seller = til.item_weight_flag_seller,
	formula_weight_seller = til.formula_weight_seller,
	chargeable_weight_seller = til.chargeable_weight_seller,
	weight_seller_pct = til.weight_seller_pct,
	seller_flat_charge = til.seller_flat_charge,
	seller_charge = til.seller_charge,
	insurance_seller = til.insurance_seller,
	insurance_vat_seller = til.insurance_vat_seller,
	rate_card_scheme = til.rate_card_scheme,
	item_weight_flag_3pl = til.item_weight_flag_3pl,
	formula_weight_3pl = til.formula_weight_3pl,
	chargeable_weight_3pl = til.chargeable_weight_3pl,
	weight_3pl_pct = til.weight_3pl_pct,
	pickup_cost = til.pickup_cost,
	pickup_cost_discount = til.pickup_cost_discount,
	pickup_cost_vat = til.pickup_cost_vat,
	delivery_flat_cost = til.delivery_flat_cost,
	delivery_cost = til.delivery_cost,
	delivery_cost_discount = til.delivery_cost_discount,
	delivery_cost_vat = til.delivery_cost_vat,
	insurance_3pl = til.insurance_3pl,
	insurance_vat_3pl = til.insurance_vat_3pl,
	total_customer_charge = til.total_customer_charge,
	total_seller_charge = til.total_seller_charge,
	total_pickup_cost = til.total_pickup_cost,
	total_delivery_cost = til.total_delivery_cost,
	total_failed_delivery_cost = til.total_failed_delivery_cost,
	created_at = til.created_at,
	updated_at = til.updated_at
	;

/*-----------------------------------------------------------------------------------------------------------------------------------
Update API Data Status from COMPLETE to ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE api_data_direct_billing
SET
	status = 'ACTIVE'
WHERE
	status IN ('COMPLETE', 'INCOMPLETE', 'NO_DFD_DATE');

UPDATE api_data_master_account
SET
	status = 'ACTIVE'
WHERE
	status IN ('COMPLETE', 'INCOMPLETE', 'NO_DFD_DATE');

SET SQL_SAFE_UPDATES = 1;