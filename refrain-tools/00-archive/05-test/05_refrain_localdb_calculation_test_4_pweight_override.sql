USE refrain;

SELECT 
    api_type, COUNT(*)
FROM
    tmp_package_level
GROUP BY api_type;

SELECT 
    tpl.bob_id_sales_order_item,
    tpl.order_nr,
    tpl.bob_id_supplier,
    tpl.id_package_dispatching,
    tpl.api_type,
    tpl.formula_weight_seller,
    tpl.formula_weight_3pl,
    delv.posting_type,
    delv.charge_type,
    delv.bob_id_supplier,
    delv.id_package_dispatching,
    delv.formula_weight 'formula_weight',
    IFNULL(delv.rounded_weight, delv.formula_weight) 'rounded_weight',
    delv.amount 'delivery_cost',
    delv.tax_amount 'delivery_cost_vat',
    delv.total_amount 'total_delivery_cost',
    delv.status
FROM
    tmp_package_level tpl
        JOIN
    api_data_direct_billing delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type IN ('DELIVERY')
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
WHERE
    tpl.api_type = 1
GROUP BY tpl.order_nr , tpl.bob_id_supplier , tpl.id_package_dispatching;

SELECT 
    tpl.bob_id_sales_order_item,
    tpl.order_nr,
    tpl.bob_id_supplier,
    tpl.id_package_dispatching,
    tpl.api_type,
    tpl.formula_weight_seller,
    tpl.formula_weight_3pl,
    delv.bob_id_supplier,
    delv.id_package_dispatching,
    delv.posting_type,
    delv.charge_type,
    delv.formula_weight 'formula_weight',
    IFNULL(delv.rounded_weight, delv.formula_weight) 'rounded_weight',
    delv.amount 'delivery_cost',
    delv.tax_amount 'delivery_cost_vat',
    delv.total_amount 'total_delivery_cost',
    delv.status,
    fdel.posting_type,
    fdel.charge_type,
    fdel.formula_weight 'formula_weight',
    IFNULL(delv.rounded_weight, delv.formula_weight) 'rounded_weight',
    fdel.amount 'failed_delivery_cost',
    fdel.tax_amount 'failed_delivery_cost_vat',
    fdel.total_amount 'failed_total_delivery_cost',
    fdel.status,
    pckc.posting_type,
    pckc.charge_type,
    pckc.amount 'pickup_cost',
    pckc.tax_amount 'pickup_cost_vat',
    pckc.total_amount 'total_pickup_cost',
    pckc.status,
    ins.posting_type,
    ins.charge_type,
    ins.amount 'insurance_cost',
    ins.tax_amount 'insurance_cost_vat',
    ins.total_amount 'total_insurance_cost',
    ins.status
FROM
    tmp_package_level tpl
        LEFT JOIN
    api_data_master_account delv ON tpl.id_package_dispatching = delv.id_package_dispatching
        AND tpl.bob_id_supplier = delv.bob_id_supplier
        AND delv.posting_type = 'INCOMING'
        AND delv.charge_type IN ('DELIVERY')
        AND delv.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account fdel ON tpl.id_package_dispatching = fdel.id_package_dispatching
        AND tpl.bob_id_supplier = fdel.bob_id_supplier
        AND fdel.posting_type = 'INCOMING'
        AND fdel.charge_type IN ('FAILED DELIVERY')
        AND fdel.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account pckc ON tpl.id_package_dispatching = pckc.id_package_dispatching
        AND tpl.bob_id_supplier = pckc.bob_id_supplier
        AND pckc.posting_type = 'INCOMING'
        AND pckc.charge_type IN ('PICKUP')
        AND pckc.status IN ('COMPLETE' , 'ACTIVE')
        LEFT JOIN
    api_data_master_account ins ON tpl.id_package_dispatching = ins.id_package_dispatching
        AND tpl.bob_id_supplier = ins.bob_id_supplier
        AND ins.posting_type = 'INCOMING'
        AND ins.charge_type IN ('INSURANCE')
        AND ins.status IN ('COMPLETE' , 'ACTIVE')
WHERE
    tpl.api_type = 2
GROUP BY tpl.order_nr , tpl.bob_id_supplier , tpl.id_package_dispatching;