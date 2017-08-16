/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Master Account Result

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
    SUM(unit_price) 'unit_price',
    SUM(paid_price) 'paid_price',
    SUM(shipping_amount) 'shipping_amount',
    SUM(shipping_surcharge) 'shipping_surcharge',
    SUM(marketplace_commission_fee) 'marketplace_commission_fee',
    SUM(coupon_money_value) 'coupon_money_value',
    SUM(cart_rule_discount) 'cart_rule_discount',
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
    SUM(retail_cogs) 'retail_cogs',
    order_value,
    SUM(shipping_fee) 'shipping_fee',
    SUM(shipping_fee_credit) 'shipping_fee_credit',
    SUM(seller_cr_db_item) 'seller_cr_db_tem',
    zone_type,
    formula_weight_seller_ps,
    chargeable_weight_seller_ps,
    formula_weight_3pl_ps,
    chargeable_weight_3pl_ps,
    shipment_scheme,
    rate_card_scheme,
    campaign,
    CASE
        WHEN
            shipment_scheme LIKE '%GO-JEK%'
                OR shipment_scheme LIKE '%EXPRESS%'
        THEN
            'EXPRESS'
        WHEN
            campaign = 'VIP Seller'
        THEN
            CASE
                WHEN shipment_scheme LIKE '%FBL%' THEN 'VIP FBL'
                ELSE 'VIP NON-FBL'
            END
        WHEN
            shipment_scheme LIKE '%FBL%'
        THEN
            CASE
                WHEN pickup_provider_type = 'LEX' THEN 'FBL LEX'
                ELSE 'FBL NON-LEX'
            END
        WHEN pickup_provider_type = 'LEX' THEN 'MA LEX'
        ELSE 'MA NON-LEX'
    END 'commentary',
    qty_ps 'qty',
    rounding_seller,
    rounding_3pl,
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
    delivery_cost_rate,
    delivery_cost_discount_rate,
    SUM(shipment_fee_mp_seller_item) 'shipment_fee_mp_seller',
    SUM(insurance_seller_item) 'insurance_seller',
    SUM(insurance_vat_seller_item) 'insurance_vat_seller',
    SUM(delivery_cost_item) 'delivery_cost',
    SUM(delivery_cost_discount_item) 'delivery_cost_discount',
    SUM(delivery_cost_vat_item) 'delivery_cost_vat',
    SUM(pickup_cost_item) 'pickup_cost',
    SUM(pickup_cost_discount_item) 'pickup_cost_discount',
    SUM(pickup_cost_vat_item) 'pickup_cost_vat',
    SUM(insurance_3pl_item) 'insurance_3pl',
    SUM(insurance_vat_3pl_item) 'insurance_vat_3pl',
    SUM(total_shipment_fee_mp_seller_item) 'total_shipment_fee_mp_seller',
    SUM(total_delivery_cost_item) 'total_delivery_cost',
    SUM(total_failed_delivery_cost_item) 'total_failed_delivery_cost'
FROM
    anondb_calculate ac
WHERE
    shipment_scheme IN ('GO-JEK' , 'GO-JEK FBL',
        'EXPRESS',
        'EXPRESS FBL',
        'FBL',
        'MASTER ACCOUNT')
        AND is_marketplace = 1
GROUP BY order_nr , bob_id_supplier , id_package_dispatching