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

SELECT 
    'date',
    'api_type',
    'shipment_scheme',
    SUM(CASE
        WHEN charge_type IN ('COD') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'payment_mdr_cost',
    'chargeable_weight_seller',
    'seller_flat_charge',
    'seller_charge',
    'insurance_seller',
    'insurance_vat_seller',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY' , 'FAILED DELIVERY') THEN IFNULL(formula_weight, 0)
        ELSE 0
    END) 'formula_weight_3pl',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY' , 'FAILED DELIVERY') THEN IFNULL(rounded_weight, 0)
        ELSE 0
    END) 'chargeable_weight_3pl',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'pickup_cost',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(discount, 0)
        ELSE 0
    END) 'pickup_cost_discount',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'pickup_cost_vat',
    0 'delivery_flat_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'delivery_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(discount, 0)
        ELSE 0
    END) 'delivery_cost_discount',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'delivery_cost_vat',
    SUM(CASE
        WHEN charge_type IN ('INSURANCE') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'insurance_3pl',
    SUM(CASE
        WHEN charge_type IN ('INSURANCE') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'insurance_vat_3pl',
    0 'total_seller_charge',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_pickup_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_delivery_cost',
    SUM(CASE
        WHEN charge_type IN ('FAILED DELIVERY') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_failed_delivery_cost'
FROM
    api_data_direct_billing
WHERE
    status IN ('COMPLETE' , 'ACTIVE');

SELECT 
    'date',
    'api_type',
    'shipment_scheme',
    SUM(CASE
        WHEN charge_type IN ('COD') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'payment_mdr_cost',
    'chargeable_weight_seller',
    'seller_flat_charge',
    'seller_charge',
    'insurance_seller',
    'insurance_vat_seller',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY' , 'FAILED DELIVERY') THEN IFNULL(formula_weight, 0)
        ELSE 0
    END) 'formula_weight_3pl',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY' , 'FAILED DELIVERY') THEN IFNULL(rounded_weight, 0)
        ELSE 0
    END) 'chargeable_weight_3pl',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'pickup_cost',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(discount, 0)
        ELSE 0
    END) 'pickup_cost_discount',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'pickup_cost_vat',
    0 'delivery_flat_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'delivery_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(discount, 0)
        ELSE 0
    END) 'delivery_cost_discount',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'delivery_cost_vat',
    SUM(CASE
        WHEN charge_type IN ('INSURANCE') THEN IFNULL(amount, 0)
        ELSE 0
    END) 'insurance_3pl',
    SUM(CASE
        WHEN charge_type IN ('INSURANCE') THEN IFNULL(tax_amount, 0)
        ELSE 0
    END) 'insurance_vat_3pl',
    0 'total_seller_charge',
    SUM(CASE
        WHEN charge_type IN ('PICKUP') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_pickup_cost',
    SUM(CASE
        WHEN charge_type IN ('DELIVERY') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_delivery_cost',
    SUM(CASE
        WHEN charge_type IN ('FAILED DELIVERY') THEN IFNULL(total_amount, 0)
        ELSE 0
    END) 'total_failed_delivery_cost'
FROM
    api_data_master_account
WHERE
    status IN ('COMPLETE' , 'ACTIVE');

SELECT 
    CASE
        WHEN order_date < '2017-01-01' THEN 'before'
        WHEN order_date >= '2017-01-01' THEN 'after'
    END 'datef',
    api_type,
    shipment_scheme,
    SUM(IFNULL(payment_mdr_cost, 0)),
    SUM(IFNULL(chargeable_weight_seller, 0)),
    SUM(IFNULL(seller_flat_charge, 0)),
    SUM(IFNULL(seller_charge, 0)),
    SUM(IFNULL(insurance_seller, 0)),
    SUM(IFNULL(insurance_vat_seller, 0)),
    SUM(IFNULL(formula_weight_3pl, 0)),
    SUM(IFNULL(chargeable_weight_3pl, 0)),
    SUM(IFNULL(pickup_cost, 0)),
    SUM(IFNULL(pickup_cost_discount, 0)),
    SUM(IFNULL(pickup_cost_vat, 0)),
    SUM(IFNULL(delivery_flat_cost, 0)),
    SUM(IFNULL(delivery_cost, 0)),
    SUM(IFNULL(delivery_cost_discount, 0)),
    SUM(IFNULL(delivery_cost_vat, 0)),
    SUM(IFNULL(insurance_3pl, 0)),
    SUM(IFNULL(insurance_vat_3pl, 0)),
    SUM(IFNULL(total_seller_charge, 0)),
    SUM(IFNULL(total_pickup_cost, 0)),
    SUM(IFNULL(total_delivery_cost, 0)),
    SUM(IFNULL(total_failed_delivery_cost, 0))
FROM
    tmp_item_level
GROUP BY datef , shipment_scheme , api_type;

SELECT 
    CASE
        WHEN order_date < '2017-01-01' THEN 'before'
        WHEN order_date >= '2017-01-01' THEN 'after'
    END 'datef',
    api_type,
    shipment_scheme,
    SUM(IFNULL(payment_mdr_cost, 0)),
    SUM(IFNULL(chargeable_weight_seller, 0)),
    SUM(IFNULL(seller_flat_charge, 0)),
    SUM(IFNULL(seller_charge, 0)),
    SUM(IFNULL(insurance_seller, 0)),
    SUM(IFNULL(insurance_vat_seller, 0)),
    SUM(IFNULL(formula_weight_3pl, 0)),
    SUM(IFNULL(chargeable_weight_3pl, 0)),
    SUM(IFNULL(pickup_cost, 0)),
    SUM(IFNULL(pickup_cost_discount, 0)),
    SUM(IFNULL(pickup_cost_vat, 0)),
    SUM(IFNULL(delivery_flat_cost, 0)),
    SUM(IFNULL(delivery_cost, 0)),
    SUM(IFNULL(delivery_cost_discount, 0)),
    SUM(IFNULL(delivery_cost_vat, 0)),
    SUM(IFNULL(insurance_3pl, 0)),
    SUM(IFNULL(insurance_vat_3pl, 0)),
    SUM(IFNULL(total_seller_charge, 0)),
    SUM(IFNULL(total_pickup_cost, 0)),
    SUM(IFNULL(total_delivery_cost, 0)),
    SUM(IFNULL(total_failed_delivery_cost, 0))
FROM
    fms_sales_order_item
GROUP BY datef , shipment_scheme , api_type;

SELECT 
    CASE
        WHEN order_date < '2017-01-01' THEN 'before'
        WHEN order_date >= '2017-01-01' THEN 'after'
    END 'datef',
    api_type,
    shipment_scheme,
    SUM(IFNULL(payment_mdr_cost, 0)),
    SUM(IFNULL(chargeable_weight_seller, 0)),
    SUM(IFNULL(seller_flat_charge, 0)),
    SUM(IFNULL(seller_charge, 0)),
    SUM(IFNULL(insurance_seller, 0)),
    SUM(IFNULL(insurance_vat_seller, 0)),
    SUM(IFNULL(formula_weight_3pl, 0)),
    SUM(IFNULL(chargeable_weight_3pl, 0)),
    SUM(IFNULL(pickup_cost, 0)),
    SUM(IFNULL(pickup_cost_discount, 0)),
    SUM(IFNULL(pickup_cost_vat, 0)),
    SUM(IFNULL(delivery_flat_cost, 0)),
    SUM(IFNULL(delivery_cost, 0)),
    SUM(IFNULL(delivery_cost_discount, 0)),
    SUM(IFNULL(delivery_cost_vat, 0)),
    SUM(IFNULL(insurance_3pl, 0)),
    SUM(IFNULL(insurance_vat_3pl, 0)),
    SUM(IFNULL(total_seller_charge, 0)),
    SUM(IFNULL(total_pickup_cost, 0)),
    SUM(IFNULL(total_delivery_cost, 0)),
    SUM(IFNULL(total_failed_delivery_cost, 0))
FROM
    tmp_package_level
GROUP BY datef , shipment_scheme , api_type;