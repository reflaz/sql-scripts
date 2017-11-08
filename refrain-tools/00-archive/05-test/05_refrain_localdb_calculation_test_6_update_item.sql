USE refrain;

SELECT 
    COUNT(*)
FROM
    tmp_item_level;

SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.order_nr,
            til.bob_id_supplier,
            til.id_package_dispatching,
            CASE
                WHEN tpl.item_weight_flag_seller = 1 THEN til.weight / tpl.weight
                WHEN tpl.item_weight_flag_seller = 2 THEN til.volumetric_weight / tpl.volumetric_weight
                WHEN tpl.item_weight_flag_seller = 3 THEN til.item_weight_seller / tpl.item_weight_seller
            END 'weight_seller_pct',
            CASE
                WHEN tpl.item_weight_flag_3pl = 1 THEN til.weight / tpl.weight
                WHEN tpl.item_weight_flag_3pl = 2 THEN til.volumetric_weight / tpl.volumetric_weight
            END 'weight_3pl_pct',
            til.unit_price / tpl.package_seller_value 'package_value_pct'
    FROM
        tmp_item_level til
    LEFT JOIN tmp_package_level tpl ON til.order_nr = tpl.order_nr
        AND til.bob_id_supplier = tpl.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(tpl.id_package_dispatching, 1)
    WHERE
        til.order_date < '2017-01-01') bef;
SELECT 
    *
FROM
    (SELECT 
        til.bob_id_sales_order_item,
            til.order_nr,
            til.bob_id_supplier,
            til.id_package_dispatching,
            CASE
                WHEN tpl.item_weight_flag_seller = 1 THEN til.weight / tpl.weight
                WHEN tpl.item_weight_flag_seller = 2 THEN til.volumetric_weight / tpl.volumetric_weight
                WHEN tpl.item_weight_flag_seller = 3 THEN til.item_weight_seller / tpl.item_weight_seller
            END 'weight_seller_pct',
            CASE
                WHEN tpl.item_weight_flag_3pl = 1 THEN til.weight / tpl.weight
                WHEN tpl.item_weight_flag_3pl = 2 THEN til.volumetric_weight / tpl.volumetric_weight
            END 'weight_3pl_pct',
            til.unit_price / tpl.package_seller_value 'package_value_pct'
    FROM
        tmp_item_level til
    LEFT JOIN tmp_package_level tpl ON til.order_nr = tpl.order_nr
        AND til.bob_id_supplier = tpl.bob_id_supplier
        AND IFNULL(til.id_package_dispatching, 1) = IFNULL(tpl.id_package_dispatching, 1)
    WHERE
        til.order_date >= '2017-01-01') aft