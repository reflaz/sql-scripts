/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Import Raw Data from Local Database by Package Number

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

USE refrain;

TRUNCATE tmp_item_level;

INSERT INTO tmp_item_level
SELECT 
    fsoi.bob_id_sales_order_item,
    fsoi.sc_id_sales_order_item,
    fsoi.oms_id_sales_order_item,
    fsoi.order_nr,
    fsoi.payment_method,
    fsoi.tenor,
    fsoi.bank,
    fsoi.sku,
    fsoi.primary_category,
    fsoi.bob_id_supplier,
    fsoi.short_code,
    fsoi.seller_name,
    fsoi.seller_type,
    fsoi.tax_class,
    fsoi.is_marketplace,
    fsoi.order_value,
    fsoi.payment_value,
    fsoi.unit_price,
    fsoi.paid_price,
    fsoi.shipping_amount,
    fsoi.shipping_surcharge,
    fsoi.coupon_money_value,
    fsoi.cart_rule_discount,
    fsoi.retail_cogs,
    fsoi.coupon_type,
    fsoi.last_status,
    fsoi.order_date,
    fsoi.finance_verified_date,
    fsoi.first_shipped_date,
    fsoi.last_shipped_date,
    fsoi.delivered_date,
    fsoi.failed_delivery_date,
    fsoi.origin,
    fsoi.id_district,
    fsoi.bob_id_customer,
    fsoi.pickup_provider_type,
    fsoi.id_package_dispatching,
    fsoi.package_number,
    fsoi.first_tracking_number,
    fsoi.first_shipment_provider,
    fsoi.last_tracking_number,
    fsoi.last_shipment_provider,
    NULL AS 'config_length',
    NULL AS 'config_width',
    NULL AS 'config_height',
    NULL AS 'config_weight',
    NULL AS 'simple_length',
    NULL AS 'simple_width',
    NULL AS 'simple_height',
    NULL AS 'simple_weight',
    fsoi.shipping_type,
    fsoi.delivery_type,
    fsoi.commission,
    fsoi.commission_adjustment,
    fsoi.payment_fee,
    fsoi.payment_fee_adjustment,
    fsoi.auto_shipping_fee,
    fsoi.manual_shipping_fee_lzd,
    fsoi.manual_shipping_fee_3p,
    fsoi.shipping_fee_adjustment,
    fsoi.package_seller_value,
    NULL AS 'payment_flat_cost_rate',
    NULL AS 'payment_mdr_cost_rate',
    NULL AS 'payment_ipp_cost_rate',
    NULL AS 'payment_flat_cost',
    NULL AS 'payment_mdr_cost',
    NULL AS 'payment_ipp_cost',
    fsoi.api_type,
    fsoi.shipment_scheme,
    fsoi.campaign,
    fsoi.weight,
    fsoi.volumetric_weight,
    fsoi.item_weight_seller,
    fsoi.item_weight_flag_seller,
    NULL AS 'rounding_seller',
    fsoi.formula_weight_seller,
    fsoi.chargeable_weight_seller,
    NULL AS 'seller_flat_charge_rate',
    NULL AS 'seller_charge_rate',
    NULL AS 'insurance_rate_seller',
    NULL AS 'insurance_vat_rate_seller',
    fsoi.weight_seller_pct,
    fsoi.seller_flat_charge,
    fsoi.seller_charge,
    fsoi.insurance_seller,
    fsoi.insurance_vat_seller,
    fsoi.rate_card_scheme,
    fsoi.item_weight_flag_3pl,
    NULL AS 'rounding_3pl',
    fsoi.formula_weight_3pl,
    fsoi.chargeable_weight_3pl,
    NULL AS 'pickup_cost_rate',
    NULL AS 'pickup_cost_discount_rate',
    NULL AS 'pickup_cost_vat_rate',
    NULL AS 'delivery_flat_cost_rate',
    NULL AS 'delivery_cost_rate',
    NULL AS 'delivery_cost_discount_rate',
    NULL AS 'delivery_cost_vat_rate',
    NULL AS 'insurance_rate_3pl',
    NULL AS 'insurance_vat_rate_3pl',
    fsoi.weight_3pl_pct,
    fsoi.pickup_cost,
    fsoi.pickup_cost_discount,
    fsoi.pickup_cost_vat,
    fsoi.delivery_flat_cost,
    fsoi.delivery_cost,
    fsoi.delivery_cost_discount,
    fsoi.delivery_cost_vat,
    fsoi.insurance_3pl,
    fsoi.insurance_vat_3pl,
    fsoi.total_customer_charge,
    fsoi.total_seller_charge,
    fsoi.total_pickup_cost,
    fsoi.total_delivery_cost,
    fsoi.total_failed_delivery_cost,
    fsoi.created_at,
    fsoi.updated_at
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        addb.package_number 'missing_package_number_reference'
    FROM
        api_data_direct_billing addb
    LEFT JOIN fms_sales_order_item til ON addb.package_number = til.package_number
    WHERE
        addb.package_number IN ()
            AND til.bob_id_sales_order_item IS NOT NULL UNION ALL SELECT 
        adma.package_number 'missing_package_number_reference'
    FROM
        api_data_master_account adma
    LEFT JOIN fms_sales_order_item til ON adma.package_number = til.package_number
    WHERE
        adma.package_number IN ()
            AND til.bob_id_sales_order_item IS NOT NULL) mpn
    GROUP BY missing_package_number_reference) mpn
        LEFT JOIN
    fms_sales_order_item fsoi ON mpn.missing_package_number_reference = fsoi.package_number;