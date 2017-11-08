USE refrain;

SELECT 
    *
FROM
    (SELECT 
        til.order_nr,
            til.bob_id_supplier,
            til.bob_id_sales_order_item,
            til.id_package_dispatching,
            til.shipment_scheme,
            til.rate_card_scheme,
            pckval.package_value,
            mdi.insurance_rate,
            mdi.insurance_vat_rate
    FROM
        tmp_item_level til
    JOIN map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.is_marketplace = 1
        AND mdi.type = 'seller'
    JOIN (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    WHERE
        is_marketplace = 1
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value < pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value) result;

SELECT 
    *
FROM
    (SELECT 
        til.order_nr,
            til.bob_id_supplier,
            til.bob_id_sales_order_item,
            til.id_package_dispatching,
            til.shipment_scheme,
            til.rate_card_scheme,
            pckval.package_value,
            mdi.insurance_rate,
            mdi.insurance_vat_rate
    FROM
        tmp_item_level til
    JOIN map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.type = '3pl'
    JOIN (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value < pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value) result;

SET SQL_SAFE_UPDATES = 0;

UPDATE tmp_item_level til
    JOIN map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.is_marketplace = 1
        AND mdi.type = 'seller'
    JOIN (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    WHERE
        is_marketplace = 1
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value <= pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value
SET
	til.insurance_rate_sel = mdi.insurance_rate,
	til.insurance_vat_rate_sel = mdi.insurance_vat_rate;

UPDATE tmp_item_level til
    JOIN map_default_insurance mdi ON til.rate_card_scheme = mdi.rate_card_scheme
        AND mdi.type = '3pl'
    JOIN (SELECT 
        order_nr,
            bob_id_supplier,
            id_package_dispatching,
            SUM(IFNULL(unit_price, 0)) 'package_value'
    FROM
        tmp_item_level
    GROUP BY order_nr , bob_id_supplier , id_package_dispatching) pckval ON til.order_nr = pckval.order_nr
        AND til.bob_id_supplier = pckval.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(pckval.id_package_dispatching, 1)
        AND mdi.min_package_value <= pckval.package_value
        AND IFNULL(mdi.max_package_value, pckval.package_value) >= pckval.package_value
SET
	til.insurance_rate_3pl = mdi.insurance_rate,
	til.insurance_vat_rate_3pl = mdi.insurance_vat_rate;

SET SQL_SAFE_UPDATES = 1;