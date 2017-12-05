/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
API Statistics for Irregularities

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

SET @api_date = '20171111-20171120';

USE refrain_live;

SELECT 
    til.bob_id_sales_order_item,
    til.sc_id_sales_order_item,
    til.order_nr,
    til.payment_method,
    til.tenor,
    til.bank,
    til.sku,
    til.primary_category,
    til.bob_id_supplier,
    til.short_code,
    til.seller_name,
    til.seller_type,
    til.tax_class,
    til.is_marketplace,
    til.order_value,
    til.payment_value,
    SUM(IFNULL(til.unit_price, 0)) 'unit_price',
    SUM(IFNULL(til.paid_price, 0)) 'paid_price',
    SUM(IFNULL(til.shipping_amount, 0)) 'shipping_amount',
    SUM(IFNULL(til.shipping_surcharge, 0)) 'shipping_surcharge',
    SUM(IFNULL(til.coupon_money_value, 0)) 'coupon_money_value',
    SUM(IFNULL(til.cart_rule_discount, 0)) 'cart_rule_discount',
    SUM(IFNULL(til.retail_cogs, 0)) 'retail_cogs',
    til.coupon_type,
    til.last_status,
    til.order_date,
    til.finance_verified_date,
    til.first_shipped_date,
    til.last_shipped_date,
    til.delivered_date,
    til.failed_delivery_date,
    til.origin,
    til.id_district,
    til.bob_id_customer,
    til.pickup_provider_type,
    til.id_package_dispatching,
    til.package_number,
    til.first_tracking_number,
    til.first_shipment_provider,
    til.last_tracking_number,
    til.last_shipment_provider,
    til.shipping_type,
    til.delivery_type,
    SUM(IFNULL(til.commission, 0)) 'commission',
    SUM(IFNULL(til.commission_adjustment, 0)) 'commission_adjustment',
    SUM(IFNULL(til.payment_fee, 0)) 'payment_fee',
    SUM(IFNULL(til.payment_fee_adjustment, 0)) 'payment_fee_adjustment',
    SUM(IFNULL(til.auto_shipping_fee, 0)) 'auto_shipping_fee',
    SUM(IFNULL(til.manual_shipping_fee_lzd, 0)) 'manual_shipping_fee_lzd',
    SUM(IFNULL(til.manual_shipping_fee_3p, 0)) 'manual_shipping_fee_3p',
    SUM(IFNULL(til.shipping_fee_adjustment, 0)) 'shipping_fee_adjustment',
    til.package_seller_value,
    SUM(IFNULL(til.payment_flat_cost, 0)) 'payment_flat_cost',
    SUM(IFNULL(til.payment_mdr_cost, 0)) 'payment_mdr_cost',
    SUM(IFNULL(til.payment_ipp_cost, 0)) 'payment_ipp_cost',
    til.api_type,
    til.shipment_scheme,
    til.campaign,
    til.weight weight,
    SUM(IFNULL(til.volumetric_weight, 0)) 'volumetric_weight',
    SUM(IFNULL(til.item_weight_seller, 0)) 'item_weight_seller',
    til.item_weight_flag_seller,
    SUM(IFNULL(til.formula_weight_seller, 0)) 'formula_weight_seller',
    SUM(IFNULL(til.chargeable_weight_seller, 0)) 'chargeable_weight_seller',
    SUM(IFNULL(til.weight_seller_pct, 0)) 'weight_seller_pct',
    SUM(IFNULL(til.seller_flat_charge, 0)) 'seller_flat_charge',
    SUM(IFNULL(til.seller_charge, 0)) 'seller_charge',
    SUM(IFNULL(til.insurance_seller, 0)) 'insurance_seller',
    SUM(IFNULL(til.insurance_vat_seller, 0)) 'insurance_vat_seller',
    til.rate_card_scheme,
    til.item_weight_flag_3pl,
    SUM(IFNULL(til.formula_weight_3pl, 0)) 'formula_weight_3pl',
    SUM(IFNULL(til.chargeable_weight_3pl, 0)) 'chargeable_weight_3pl',
    SUM(IFNULL(til.weight_3pl_pct, 0)) 'weight_3pl_pct',
    SUM(IFNULL(til.pickup_cost, 0)) 'pickup_cost',
    SUM(IFNULL(til.pickup_cost_discount, 0)) 'pickup_cost_discount',
    SUM(IFNULL(til.pickup_cost_vat, 0)) 'pickup_cost_vat',
    SUM(IFNULL(til.delivery_flat_cost, 0)) 'delivery_flat_cost',
    SUM(IFNULL(til.delivery_cost, 0)) 'delivery_cost',
    SUM(IFNULL(til.delivery_cost_discount, 0)) 'delivery_cost_discount',
    SUM(IFNULL(til.delivery_cost_vat, 0)) 'delivery_cost_vat',
    SUM(IFNULL(til.insurance_3pl, 0)) 'insurance_3pl',
    SUM(IFNULL(til.insurance_vat_3pl, 0)) 'insurance_vat_3pl',
    SUM(IFNULL(til.total_customer_charge, 0)) 'total_customer_charge',
    SUM(IFNULL(til.total_seller_charge, 0)) 'total_seller_charge',
    SUM(IFNULL(til.total_pickup_cost, 0)) 'total_pickup_cost',
    SUM(IFNULL(til.total_delivery_cost, 0)) 'total_delivery_cost',
    SUM(IFNULL(til.total_failed_delivery_cost, 0)) 'total_failed_delivery_cost',
    til.created_at,
    til.updated_at,
    adma.delivery_amount,
    adma.delivery_discount,
    adma.delivery_tax_amount,
    adma.delivery_total_amount,
    adma.delivery_status,
    adma.failed_delivery_amount,
    adma.failed_delivery_discount,
    adma.failed_delivery_tax_amount,
    adma.failed_delivery_total_amount,
    adma.failed_delivery_status,
    adma.pickup_amount,
    adma.pickup_discount,
    adma.pickup_tax_amount,
    adma.pickup_total_amount,
    adma.pickup_status,
    adma.cod_amount,
    adma.cod_discount,
    adma.cod_tax_amount,
    adma.cod_total_amount,
    adma.cod_status,
    adma.insurance_amount,
    adma.insurance_discount,
    adma.insurance_tax_amount,
    adma.insurance_total_amount,
    adma.insurance_status
FROM
    (SELECT 
        package_number,
            short_code,
            SUM(IF(charge_type = 'DELIVERY', amount, 0)) 'delivery_amount',
            SUM(IF(charge_type = 'DELIVERY', discount, 0)) 'delivery_discount',
            SUM(IF(charge_type = 'DELIVERY', tax_amount, 0)) 'delivery_tax_amount',
            SUM(IF(charge_type = 'DELIVERY', total_amount, 0)) 'delivery_total_amount',
            MAX(IF(charge_type = 'DELIVERY', status, '')) 'delivery_status',
            SUM(IF(charge_type = 'FAILED DELIVERY', amount, 0)) 'failed_delivery_amount',
            SUM(IF(charge_type = 'FAILED DELIVERY', discount, 0)) 'failed_delivery_discount',
            SUM(IF(charge_type = 'FAILED DELIVERY', tax_amount, 0)) 'failed_delivery_tax_amount',
            SUM(IF(charge_type = 'FAILED DELIVERY', total_amount, 0)) 'failed_delivery_total_amount',
            MAX(IF(charge_type = 'FAILED DELIVERY', status, '')) 'failed_delivery_status',
            SUM(IF(charge_type = 'PICKUP', amount, 0)) 'pickup_amount',
            SUM(IF(charge_type = 'PICKUP', discount, 0)) 'pickup_discount',
            SUM(IF(charge_type = 'PICKUP', tax_amount, 0)) 'pickup_tax_amount',
            SUM(IF(charge_type = 'PICKUP', total_amount, 0)) 'pickup_total_amount',
            MAX(IF(charge_type = 'PICKUP', status, '')) 'pickup_status',
            SUM(IF(charge_type = 'COD', amount, 0)) 'cod_amount',
            SUM(IF(charge_type = 'COD', discount, 0)) 'cod_discount',
            SUM(IF(charge_type = 'COD', tax_amount, 0)) 'cod_tax_amount',
            SUM(IF(charge_type = 'COD', total_amount, 0)) 'cod_total_amount',
            MAX(IF(charge_type = 'COD', status, '')) 'cod_status',
            SUM(IF(charge_type = 'INSURANCE', amount, 0)) 'insurance_amount',
            SUM(IF(charge_type = 'INSURANCE', discount, 0)) 'insurance_discount',
            SUM(IF(charge_type = 'INSURANCE', tax_amount, 0)) 'insurance_tax_amount',
            SUM(IF(charge_type = 'INSURANCE', total_amount, 0)) 'insurance_total_amount',
            MAX(IF(charge_type = 'INSURANCE', status, '')) 'insurance_status'
    FROM
        api_data_master_account
    WHERE
        api_date = @api_date
    GROUP BY package_number , short_code) adma
        LEFT JOIN
    tmp_item_level til ON adma.package_number = til.package_number
        AND adma.short_code = til.short_code
GROUP BY id_package_dispatching , bob_id_supplier;