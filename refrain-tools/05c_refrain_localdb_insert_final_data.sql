/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Insert Data to Final Table

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain_live;

SET SQL_SAFE_UPDATES = 0;

/*-----------------------------------------------------------------------------------------------------------------------------------
Starting Transaction
-----------------------------------------------------------------------------------------------------------------------------------*/

START TRANSACTION;

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


/*-----------------------------------------------------------------------------------------------------------------------------------
Commit Transaction
-----------------------------------------------------------------------------------------------------------------------------------*/

COMMIT;

/*-----------------------------------------------------------------------------------------------------------------------------------
Insert Final Data Completed
-----------------------------------------------------------------------------------------------------------------------------------*/

SET SQL_SAFE_UPDATES = 1;