/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Refrain Tools
Master Account Result

Prepared by		: R Maliangkay
Modified by		: RM
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-10-30';
SET @extractend = '2017-11-06';-- This MUST be D + 1

USE refrain_live;

SELECT 
    *
FROM
    (SELECT 
        bob_id_sales_order_item,
            sc_id_sales_order_item,
            order_nr,
            payment_method,
            sku,
            bob_id_supplier,
            short_code,
            seller_name,
            seller_type,
            tax_class,
            is_marketplace,
            SUM(IFNULL(unit_price, 0)) 'unit_price',
            SUM(IFNULL(paid_price, 0)) 'paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'shipping_amount',
            SUM(IFNULL(shipping_surcharge, 0)) 'shipping_surcharge',
            SUM(IFNULL(coupon_money_value, 0)) 'coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'cart_rule_discount',
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
            first_shipment_provider,
            last_shipment_provider,
            shipping_type,
            delivery_type,
            SUM(IFNULL(commission, 0)) 'commission',
            SUM(IFNULL(payment_fee, 0)) 'payment_fee',
            SUM(IFNULL(auto_shipping_fee, 0)) 'auto_shipping_fee',
            SUM(IFNULL(manual_shipping_fee_lzd, 0)) 'manual_shipping_fee_lzd',
            api_type,
            shipment_scheme,
            campaign,
            CONCAT_WS(' ', shipment_scheme, campaign, CASE
                WHEN first_shipment_provider NOT LIKE '%LEX%' THEN 'NON-LEX'
            END) 'commentary',
            SUM(IFNULL(formula_weight_seller, 0)) 'formula_weight_seller',
            SUM(IFNULL(chargeable_weight_seller, 0)) 'chargeable_weight_seller',
            SUM(IFNULL(weight_seller_pct, 0)) 'weight_seller_pct',
            SUM(IFNULL(seller_flat_charge, 0)) 'seller_flat_charge',
            SUM(IFNULL(seller_charge, 0)) 'seller_charge',
            SUM(IFNULL(insurance_seller, 0)) 'insurance_seller',
            SUM(IFNULL(insurance_vat_seller, 0)) 'insurance_vat_seller',
            SUM(IFNULL(total_seller_charge, 0)) 'total_seller_charge'
    FROM
        fms_sales_order_item
    WHERE
        first_shipped_date >= @extractstart
            AND first_shipped_date < @extractend
            AND shipment_scheme IN ('EXPRESS FBL' , 'EXPRESS MASTER ACCOUNT', 'FBL', 'MASTER ACCOUNT')
            AND is_marketplace = 1
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) result