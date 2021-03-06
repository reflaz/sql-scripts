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
Map shipment scheme
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
		JOIN
    map_shipment_scheme mss ON til.payment_method <> IFNULL(mss.exclude_payment_method, '')
        AND IFNULL(til.tax_class, 'tax_class') = IFNULL(mss.tax_class, IFNULL(til.tax_class, 'tax_class'))
        AND IFNULL(til.is_marketplace, 0) = IFNULL(mss.is_marketplace, IFNULL(til.is_marketplace, 0))
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mss.first_shipment_provider, IFNULL(til.first_shipment_provider, 'first_shipment_provider')), '%')
        AND IFNULL(til.last_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mss.last_shipment_provider, IFNULL(til.last_shipment_provider, 'first_shipment_provider')), '%')
		AND IFNULL(til.first_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
		AND IFNULL(til.last_shipment_provider, 1) NOT LIKE CONCAT('%', IFNULL(mss.exclude_shipment_provider, 'exclude_shipment_provider'), '%')
        AND IFNULL(til.shipping_type, 'shipping_type') = IFNULL(mss.shipping_type, IFNULL(til.shipping_type, 'shipping_type'))
        AND IFNULL(til.delivery_type, 'delivery_type') = IFNULL(mss.delivery_type, IFNULL(til.delivery_type, 'delivery_type'))
        AND IFNULL(til.auto_shipping_fee_credit, 0) < IFNULL(mss.auto_shipping_fee_credit, 1)
        AND IFNULL(til.api_type, 0) = IFNULL(mss.api_type, IFNULL(til.api_type, 0))
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mss.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mss.end_date
SET
	til.shipment_scheme = mss.shipment_scheme;

/*-----------------------------------------------------------------------------------------------------------------------------------
Map default shipping charge components
-----------------------------------------------------------------------------------------------------------------------------------*/

UPDATE tmp_item_level til
		JOIN
	map_default_charges mdc ON til.shipment_scheme = mdc.shipment_scheme
        AND til.is_marketplace = IFNULL(mdc.is_marketplace, til.is_marketplace)
        AND IFNULL(til.first_shipment_provider, 'first_shipment_provider') LIKE CONCAT('%', IFNULL(mdc.first_shipment_provider, IFNULL(til.first_shipment_provider, 'first_shipment_provider')), '%')
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mdc.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mdc.end_date
        JOIN
	map_weight_threshold_seller mwts ON GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) >= mwts.start_date
        AND GREATEST(til.order_date, IFNULL(til.first_shipped_date, '1900-01-01')) <= mwts.end_date
SET
	til.item_weight = CASE
			WHEN til.item_weight <= (mwts.item_weight_threshold + mdc.rounding_seller) THEN til.item_weight
            ELSE CASE
				WHEN mwts.item_weight_no_bulky = 1 THEN 0
                WHEN mwts.item_weight_offset = 1 THEN item_weight - item_weight_threshold
                WHEN mwts.item_weight_max = 1 THEN item_weight_threshold
            END
		END,
	til.rounding_seller = mdc.rounding_seller,
	til.seller_flat_charge_rate = mdc.seller_flat_charge_rate,
	til.seller_charge_rate = mdc.seller_charge_rate,
	til.rate_card_scheme = mdc.rate_card_scheme,
	til.rounding_3pl = mdc.rounding_3pl,
	til.pickup_cost_rate = mdc.pickup_cost_rate,
	til.pickup_cost_discount_rate = mdc.pickup_cost_discount_rate,
	til.pickup_cost_vat_rate = mdc.pickup_cost_vat_rate,
	til.delivery_cost_vat_rate = mdc.delivery_cost_vat_rate;

UPDATE tmp_item_level til
		JOIN
	map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.is_marketplace = 1
        AND mdi.type = 'seller'
        JOIN
	(SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    WHERE
        is_marketplace = 1
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value < pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value
SET
	til.insurance_rate_sel = mdi.insurance_rate,
	til.insurance_vat_rate_sel = mdi.insurance_vat_rate;

UPDATE tmp_item_level til
		JOIN
	map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.type = '3pl'
        JOIN
    (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value < pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value
SET
	til.insurance_rate_3pl = mdi.insurance_rate,
	til.insurance_vat_rate_3pl = mdi.insurance_vat_rate;

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
        AND IFNULL(til.pickup_provider_type, 'pickup_provider_type') = IFNULL(mcam.pickup_provider_type, IFNULL(til.pickup_provider_type, 'pickup_provider_type'))
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
	til.seller_flat_charge_rate = IFNULL(IFNULL(mco.seller_flat_charge_rate, mcam.seller_flat_charge_rate), til.seller_flat_charge_rate),
	til.seller_charge_rate = IFNULL(IFNULL(mco.seller_charge_rate, mcam.seller_charge_rate), til.seller_charge_rate),
	til.insurance_rate_sel = IFNULL(mcam.insurance_rate, til.insurance_rate_sel);

SET SQL_SAFE_UPDATES = 1;