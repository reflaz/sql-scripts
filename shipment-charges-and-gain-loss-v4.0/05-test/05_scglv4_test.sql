USE scglv4;

SELECT 
    shipment_scheme,
    COUNT(*),
    MIN(delivered_date),
    MAX(delivered_date)
FROM
    anondb_extract_item_level
GROUP BY shipment_scheme;

SELECT 
    bob_id_sales_order_item, api_type, shipment_scheme
FROM
    anondb_extract_item_level
WHERE
    shipment_scheme IS NOT NULL;

SELECT 
    aeil.bob_id_sales_order_item,
    aeil.id_package_dispatching,
    aeil.bob_id_supplier,
    aeil.api_type,
    aeil.shipment_scheme,
    CASE
        WHEN adb.id_api_direct_billing IS NOT NULL THEN 'DIRECT BILLING'
        WHEN ama.id_api_master_account IS NOT NULL THEN 'MASTER ACCOUNT'
    END 'shipment_scheme_1',
    CASE
        WHEN aeil.shipment_scheme LIKE '%DIRECT BILLING%' THEN 'DIRECT BILLING'
        WHEN aeil.shipment_scheme LIKE '%MASTER ACCOUNT%' THEN 'MASTER ACCOUNT'
    END 'shipment_scheme_2',
    IFNULL(adb.formula_weight, ama.formula_weight) 'formula_weight',
    IFNULL(adb.rounded_weight, ama.rounded_weight) 'rounded_weight',
    IFNULL(adb.amount, ama.amount) 'amount',
    IFNULL(adb.tax_amount, ama.tax_amount) 'tax_amount',
    IFNULL(adb.total_amount, ama.total_amount) 'total_amount'
FROM
    anondb_extract_item_level aeil
        LEFT JOIN
    api_direct_billing adb ON aeil.id_package_dispatching = adb.id_package_dispatching
        AND aeil.bob_id_supplier = adb.bob_id_supplier
        LEFT JOIN
    api_master_account ama ON aeil.id_package_dispatching = ama.id_package_dispatching
        AND aeil.bob_id_supplier = ama.bob_id_supplier
WHERE
    aeil.api_type <> 0
GROUP BY bob_id_sales_order_item
HAVING shipment_scheme_1 <> shipment_scheme_2;