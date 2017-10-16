USE refrain;

SELECT 
    api_type,
    shipment_scheme,
    SUM(IFNULL(chargeable_weight_seller, 0)),
    SUM(IFNULL(seller_flat_charge, 0)),
    SUM(IFNULL(seller_charge, 0)),
    SUM(IFNULL(insurance_seller, 0)),
    SUM(IFNULL(insurance_vat_seller, 0)),
    SUM(IFNULL(pickup_cost, 0)),
    SUM(IFNULL(pickup_cost_discount, 0)),
    SUM(IFNULL(pickup_cost_vat, 0)),
    SUM(IFNULL(delivery_flat_cost, 0)),
    SUM(IFNULL(delivery_cost, 0)),
    SUM(IFNULL(delivery_cost_discount, 0)),
    SUM(IFNULL(delivery_cost_vat, 0)),
    SUM(IFNULL(insurance_3pl, 0)),
    SUM(IFNULL(insurance_vat_3pl, 0)),
    SUM(IFNULL(total_customer_charge, 0)),
    SUM(IFNULL(total_seller_charge, 0)),
    SUM(IFNULL(total_pickup_cost, 0)),
    SUM(IFNULL(total_delivery_cost, 0)),
    SUM(IFNULL(total_failed_delivery_cost, 0))
FROM
    tmp_item_level
-- WHERE
--    order_date >= '2017-01-01'
GROUP BY shipment_scheme , api_type;

SELECT 
    api_type,
    shipment_scheme,
    SUM(IFNULL(chargeable_weight_seller, 0)),
    SUM(IFNULL(seller_flat_charge, 0)),
    SUM(IFNULL(seller_charge, 0)),
    SUM(IFNULL(insurance_seller, 0)),
    SUM(IFNULL(insurance_vat_seller, 0)),
    SUM(IFNULL(pickup_cost, 0)),
    SUM(IFNULL(pickup_cost_discount, 0)),
    SUM(IFNULL(pickup_cost_vat, 0)),
    SUM(IFNULL(delivery_flat_cost, 0)),
    SUM(IFNULL(delivery_cost, 0)),
    SUM(IFNULL(delivery_cost_discount, 0)),
    SUM(IFNULL(delivery_cost_vat, 0)),
    SUM(IFNULL(insurance_3pl, 0)),
    SUM(IFNULL(insurance_vat_3pl, 0)),
    SUM(IFNULL(total_customer_charge, 0)),
    SUM(IFNULL(total_seller_charge, 0)),
    SUM(IFNULL(total_pickup_cost, 0)),
    SUM(IFNULL(total_delivery_cost, 0)),
    SUM(IFNULL(total_failed_delivery_cost, 0))
FROM
    tmp_package_level
-- WHERE
--    order_date >= '2017-01-01'
GROUP BY shipment_scheme , api_type;