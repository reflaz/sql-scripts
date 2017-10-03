USE refrain;

SELECT 
    shipment_scheme,
    COUNT(*),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    tmp_item_level
GROUP BY shipment_scheme;

SELECT 
    bob_id_sales_order_item, api_type, shipment_scheme
FROM
    tmp_item_level
WHERE
    shipment_scheme IS NOT NULL;

SELECT 
    til.bob_id_sales_order_item,
    til.id_package_dispatching,
    til.bob_id_supplier,
    til.api_type,
    til.shipment_scheme,
    CASE
        WHEN addb.id_api_direct_billing IS NOT NULL THEN 'DIRECT BILLING'
        WHEN adma.id_api_master_account IS NOT NULL THEN 'MASTER ACCOUNT'
    END 'shipment_scheme_1',
    CASE
        WHEN til.shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DIRECT BILLING'
        WHEN til.shipment_scheme LIKE '%MASTER ACCOUNT%' THEN 'MASTER ACCOUNT'
    END 'shipment_scheme_2',
    IFNULL(addb.formula_weight, adma.formula_weight) 'formula_weight',
    IFNULL(addb.rounded_weight, adma.rounded_weight) 'rounded_weight',
    IFNULL(addb.amount, adma.amount) 'amount',
    IFNULL(addb.tax_amount, adma.tax_amount) 'tax_amount',
    IFNULL(addb.total_amount, adma.total_amount) 'total_amount'
FROM
    tmp_item_level til
        LEFT JOIN
    api_data_direct_billing addb ON til.id_package_dispatching = addb.id_package_dispatching
        AND til.bob_id_supplier = addb.bob_id_supplier
        LEFT JOIN
    api_data_master_account adma ON til.id_package_dispatching = adma.id_package_dispatching
        AND til.bob_id_supplier = adma.bob_id_supplier
WHERE
    til.api_type <> 0
GROUP BY bob_id_sales_order_item
HAVING shipment_scheme_1 <> shipment_scheme_2;