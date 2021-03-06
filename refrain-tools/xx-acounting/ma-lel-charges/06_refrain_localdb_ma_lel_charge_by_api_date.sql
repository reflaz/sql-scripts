/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Master Account Charge for Actual Data

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
    fsoi.bob_id_sales_order_item,
    fsoi.sc_id_sales_order_item,
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
    SUM(IFNULL(fsoi.unit_price, 0)) 'unit_price',
    SUM(IFNULL(fsoi.paid_price, 0)) 'paid_price',
    SUM(IFNULL(fsoi.shipping_amount, 0)) 'shipping_amount',
    SUM(IFNULL(fsoi.shipping_surcharge, 0)) 'shipping_surcharge',
    SUM(IFNULL(fsoi.coupon_money_value, 0)) 'coupon_money_value',
    SUM(IFNULL(fsoi.cart_rule_discount, 0)) 'cart_rule_discount',
    SUM(IFNULL(fsoi.retail_cogs, 0)) 'retail_cogs',
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
    fsoi.shipping_type,
    fsoi.delivery_type,
    SUM(IFNULL(fsoi.commission, 0)) 'commission',
    SUM(IFNULL(fsoi.commission_adjustment, 0)) 'commission_adjustment',
    SUM(IFNULL(fsoi.payment_fee, 0)) 'payment_fee',
    SUM(IFNULL(fsoi.payment_fee_adjustment, 0)) 'payment_fee_adjustment',
    SUM(IFNULL(fsoi.auto_shipping_fee, 0)) 'auto_shipping_fee',
    SUM(IFNULL(fsoi.manual_shipping_fee_lzd, 0)) 'manual_shipping_fee_lzd',
    SUM(IFNULL(fsoi.manual_shipping_fee_3p, 0)) 'manual_shipping_fee_3p',
    SUM(IFNULL(fsoi.shipping_fee_adjustment, 0)) 'shipping_fee_adjustment',
    fsoi.package_seller_value,
    SUM(IFNULL(fsoi.payment_flat_cost, 0)) 'payment_flat_cost',
    SUM(IFNULL(fsoi.payment_mdr_cost, 0)) 'payment_mdr_cost',
    SUM(IFNULL(fsoi.payment_ipp_cost, 0)) 'payment_ipp_cost',
    fsoi.fk_api_type,
    fsoi.shipment_scheme,
    fsoi.campaign,
    fsoi.weight weight,
    SUM(IFNULL(fsoi.volumetric_weight, 0)) 'volumetric_weight',
    SUM(IFNULL(fsoi.item_weight_seller, 0)) 'item_weight_seller',
    fsoi.item_weight_flag_seller,
    SUM(IFNULL(fsoi.formula_weight_seller, 0)) 'formula_weight_seller',
    SUM(IFNULL(fsoi.chargeable_weight_seller, 0)) 'chargeable_weight_seller',
    SUM(IFNULL(fsoi.weight_seller_pct, 0)) 'weight_seller_pct',
    SUM(IFNULL(fsoi.seller_flat_charge, 0)) 'seller_flat_charge',
    SUM(IFNULL(fsoi.seller_charge, 0)) 'seller_charge',
    SUM(IFNULL(fsoi.insurance_seller, 0)) 'insurance_seller',
    SUM(IFNULL(fsoi.insurance_vat_seller, 0)) 'insurance_vat_seller',
    fsoi.rate_card_scheme,
    fsoi.item_weight_flag_3pl,
    SUM(IFNULL(fsoi.formula_weight_3pl, 0)) 'formula_weight_3pl',
    SUM(IFNULL(fsoi.chargeable_weight_3pl, 0)) 'chargeable_weight_3pl',
    SUM(IFNULL(fsoi.weight_3pl_pct, 0)) 'weight_3pl_pct',
    SUM(IFNULL(fsoi.pickup_cost, 0)) 'pickup_cost',
    SUM(IFNULL(fsoi.pickup_cost_discount, 0)) 'pickup_cost_discount',
    SUM(IFNULL(fsoi.pickup_cost_vat, 0)) 'pickup_cost_vat',
    SUM(IFNULL(fsoi.delivery_flat_cost, 0)) 'delivery_flat_cost',
    SUM(IFNULL(fsoi.delivery_cost, 0)) 'delivery_cost',
    SUM(IFNULL(fsoi.delivery_cost_discount, 0)) 'delivery_cost_discount',
    SUM(IFNULL(fsoi.delivery_cost_vat, 0)) 'delivery_cost_vat',
    SUM(IFNULL(fsoi.insurance_3pl, 0)) 'insurance_3pl',
    SUM(IFNULL(fsoi.insurance_vat_3pl, 0)) 'insurance_vat_3pl',
    SUM(IFNULL(fsoi.total_customer_charge, 0)) 'total_customer_charge',
    SUM(IFNULL(fsoi.total_seller_charge, 0)) 'total_seller_charge',
    SUM(IFNULL(fsoi.total_pickup_cost, 0)) 'total_pickup_cost',
    SUM(IFNULL(fsoi.total_delivery_cost, 0)) 'total_delivery_cost',
    SUM(IFNULL(fsoi.total_failed_delivery_cost, 0)) 'total_failed_delivery_cost',
    fsoi.created_at,
    fsoi.updated_at,
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
        api_data
    WHERE
        api_date = @api_date
            AND fk_api_type = 10002
    GROUP BY package_number , short_code) adma
        LEFT JOIN
    fms_sales_order_item fsoi ON adma.package_number = fsoi.package_number
        AND adma.short_code = fsoi.short_code
GROUP BY id_package_dispatching , bob_id_supplier;