/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Direct Billing Charge and Gain Loss LocalDB Calculate
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: Just run the script
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/
USE macgl;

SELECT 
    order_nr 'Order Number',
    bob_id_sales_order_item 'Sales Order Item',
    sc_sales_order_item 'SC Sales Order Item',
    payment_method 'Payment Method',
    sku 'SKU',
    primary_category 'Primary Category',
    qty 'Qty',
    qty_non_bulky 'Qty Non Bulky',
    seller_id 'Seller ID',
    sc_seller_id 'SC Seller ID',
    seller_name 'Seller Name',
    seller_type 'Seller Type',
    tax_class 'Tax Class',
    total_unit_price 'Total Unit Price',
    total_paid_price 'Total Paid Price',
    total_shipping_amount 'Total Shipping Amount',
    total_shipping_surcharge 'Total Shipping Surcharge',
    total_commission_fee 'Total Commission Fee',
    total_coupon_money_value 'Total Coupon Money Value',
    total_cart_rule_discount 'Total Cart Rule Discount',
    coupon_code 'Coupon Code',
    coupon_type 'Coupon Type',
    cart_rule_display_names 'Cart Rule Display Names',
    last_status 'Last Status',
    order_date 'Order Date',
    first_shipped_date 'First Shipped Date',
    last_shipped_date 'Last Shipped Date',
    delivered_date 'Delivered Date',
    first_tracking_number 'First Tracking Number',
    first_shipment_provider 'First Shipment Provider',
    last_tracking_number 'Last Tracking Number',
    last_shipment_provider 'Last Shipment Provider',
    origin 'Origin',
    city 'City',
    id_district 'District ID',
    zone 'Zone',
    campaign 'Campaign',
    insurance_waived 'Insurance Waived',
    total_sc_shipping_fee 'Total SC Shipping Fee',
    total_weight 'Total Weight',
    total_volumetric_weight 'Total Volumetric Weight',
    formula_weight 'Formula Weight',
    rounded_weight 'Rounded Weight',
    rounded_weight_non_bulky 'Rounded Weight Non Bulky',
    charge_rate 'Charge Rate',
    charge_to_seller 'Charge to Seller',
    insurance_to_seller 'Seller Insurance Fee',
    total_charge_to_seller 'Total Charge to Seller',
    total_charge_to_customer 'Total Charge to Customer',
    shipment_rate '3PL Rate',
    shipment_discount_rate '3PL Discount Rate',
    charge_from_3pl '3PL Charge',
    shipment_discount '3PL Charge Discount',
    insurance_from_3pl '3PL Insurance Fee',
    total_charge_from_3pl 'Total 3PL Charge',
    total_charge_from_3pl + total_charge_to_customer + total_charge_to_seller 'Shipment Gain Loss',
    CASE
        WHEN seller_type = 'supplier' THEN total_charge_to_customer
        WHEN zone = 'Free Zone' THEN total_shipping_amount
        ELSE 0
    END 'PC1',
    CASE
        WHEN seller_type = 'supplier' THEN total_charge_from_3pl
        ELSE 0
    END 'PC2',
    CASE
        WHEN seller_type = 'supplier' THEN 0
        WHEN zone = 'Free Zone' THEN (shipment_rate - 7000) * rounded_weight_non_bulky * - 1
        ELSE 0
    END 'PC3'
FROM
    (SELECT 
        oms.*,
            total_shipping_fee 'total_charge_to_customer',
            charge_rate * rounded_weight_non_bulky 'charge_to_seller',
            ins_seller * (1 + ins_seller_vat_rate) 'insurance_to_seller',
            (charge_rate * rounded_weight_non_bulky) + (ins_seller * (1 + ins_seller_vat_rate)) 'total_charge_to_seller',
            shipment_rate * rounded_weight * - 1 'charge_from_3pl',
            shipment_rate * rounded_weight * shipment_discount_rate 'shipment_discount',
            ins_3pl * (1 + ins_3pl_vat_rate) * - 1 'insurance_from_3pl',
            ((shipment_rate * rounded_weight * (1 - shipment_discount_rate)) + (ins_3pl * (1 + ins_3pl_vat_rate))) * - 1 'total_charge_from_3pl'
    FROM
        (SELECT 
        oms.*,
            CASE
                WHEN oms.formula_weight_non_bulky = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.formula_weight_non_bulky < 1, 1, IF(MOD(oms.formula_weight_non_bulky, 1) <= 0.3, FLOOR(oms.formula_weight_non_bulky), CEIL(oms.formula_weight_non_bulky)))
                ELSE CEIL(oms.formula_weight_non_bulky)
            END 'rounded_weight_non_bulky',
            CASE
                WHEN oms.formula_weight = 0 THEN 0
                WHEN oms.last_shipment_provider LIKE '%JNE%' THEN IF(oms.formula_weight < 1, 1, IF(MOD(oms.formula_weight, 1) <= 0.3, FLOOR(oms.formula_weight), CEIL(oms.formula_weight)))
                ELSE CEIL(oms.formula_weight)
            END 'rounded_weight',
            IF(fz.id_district IS NOT NULL, 'Free Zone', 'Paid Zone') 'zone',
            NULL 'campaign',
            IF(iw.seller_id IS NOT NULL
                AND (oms.first_shipment_provider LIKE '%LEX%'
                OR oms.first_shipment_provider LIKE '%FBL%')
                AND oms.first_shipped_date >= iw.start_date
                AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
                AND oms.total_unit_price < 1000000, 'Yes', 'No') 'insurance_waived',
            0 'ins_seller',
            0 'ins_seller_vat_rate',
            CASE
                WHEN oms.seller_type = 'merchant' THEN 0
                WHEN
                    oms.last_shipment_provider LIKE '%LEX%'
                THEN
                    CASE
                        WHEN
                            oms.total_unit_price <= 1000000
                        THEN
                            CASE
                                WHEN
                                    oms.first_shipped_date >= iw.start_date
                                        AND oms.first_shipped_date <= IFNULL(IF(iw.end_date < iw.start_date, NULL, iw.end_date), NOW())
                                THEN
                                    0
                                ELSE 2500
                            END
                        ELSE oms.total_unit_price * 0.0025
                    END
                ELSE CASE
                    WHEN (oms.total_paid_price + oms.total_shipping_fee) <= 1000000 THEN 2500
                    ELSE (oms.total_paid_price + oms.total_shipping_fee) * 0.0025
                END
            END 'ins_3pl',
            0 'ins_3pl_vat_rate',
            CASE
                WHEN oms.seller_type = 'supplier' THEN 0
                ELSE 7000
            END 'charge_rate',
            IFNULL(jr.rate, 0) 'shipment_rate',
            CASE
                WHEN oms.seller_type = 'merchant' THEN 0
                WHEN
                    oms.last_shipment_provider LIKE '%JNE%'
                THEN
                    CASE
                        WHEN oms.origin = 'DKI Jakarta' THEN 0.25
                        WHEN oms.origin = 'East Java' THEN 0.15
                        WHEN oms.origin = 'North Sumatra' THEN 0.15
                        ELSE 0
                    END
                WHEN oms.last_shipment_provider LIKE '%LEX%' THEN 0.2
                WHEN oms.last_shipment_provider LIKE '%TIKI%' THEN 0.2
                ELSE 0
            END 'shipment_discount_rate'
    FROM
        (SELECT 
        *,
            COUNT(bob_id_sales_order_item) 'qty',
            SUM(IF(item_rounded_weight > 7, 0, 1)) 'qty_non_bulky',
            SUM(IFNULL(unit_price, 0)) 'total_unit_price',
            SUM(IFNULL(paid_price, 0)) 'total_paid_price',
            SUM(IFNULL(shipping_amount, 0)) 'total_shipping_amount',
            SUM(IFNULL(shipping_surcharge, 0)) 'total_shipping_surcharge',
            SUM(IFNULL(shipping_amount, 0)) + SUM(IFNULL(shipping_surcharge, 0)) 'total_shipping_fee',
            SUM(IFNULL(commission_fee, 0)) 'total_commission_fee',
            SUM(IFNULL(coupon_money_value, 0)) 'total_coupon_money_value',
            SUM(IFNULL(cart_rule_discount, 0)) 'total_cart_rule_discount',
            SUM(IFNULL(sc_shipping_fee, 0)) 'total_sc_shipping_fee',
            SUM(IFNULL(weight, 0)) 'total_weight',
            SUM(IFNULL(volumetric_weight, 0)) 'total_volumetric_weight',
            IF(SUM(IFNULL(weight, 0)) > SUM(IFNULL(volumetric_weight, 0)), SUM(IFNULL(weight, 0)), SUM(IFNULL(volumetric_weight, 0))) 'formula_weight',
            IF(SUM(IF(item_rounded_weight > 7, 0, IFNULL(weight, 0))) > SUM(IF(item_rounded_weight > 7, 0, IFNULL(volumetric_weight, 0))), SUM(IF(item_rounded_weight > 7, 0, IFNULL(weight, 0))), SUM(IF(item_rounded_weight > 7, 0, IFNULL(volumetric_weight, 0)))) 'formula_weight_non_bulky'
    FROM
        oms
    GROUP BY id_package_dispatching , order_nr , seller_id) oms
    LEFT JOIN free_zone fz ON oms.id_district = fz.id_district
    LEFT JOIN insurance_waive iw ON oms.sc_seller_id = iw.seller_id
    LEFT JOIN jne_rate jr ON IF(oms.origin = '', 'DKI Jakarta', oms.origin) = jr.origin
        AND oms.id_district = jr.id_district
    LEFT JOIN vip_seller vs ON oms.sc_seller_id = vs.seller_id) oms) result;