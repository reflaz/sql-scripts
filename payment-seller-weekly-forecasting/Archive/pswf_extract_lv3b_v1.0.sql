SET @end_period = DATE_FORMAT(IF(DAY(NOW()) > 15, DATE_ADD(NOW(), INTERVAL 1 MONTH), NOW()), '%Y-%m-01');
SET @period_1 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 1 MONTH), '%Y-%m-01');

SELECT '01' AS 'period', @period_1 
UNION ALL SELECT 'end_period' AS 'period', @end_period;


SELECT 
    lv3, SUM(unit_price) 'unit_price'
FROM
    (SELECT 
        soi.bob_id_sales_order_item,
            soish.created_at,
            soi.unit_price,
            SUBSTRING_INDEX(GROUP_CONCAT(lv2.name_en
                ORDER BY lv2.lft , lv2.rgt
                SEPARATOR ';'), ';', 3) 'lv3'
    FROM
        (SELECT 
        *
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @period_1
            AND created_at < @end_period
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package_item pi ON psh.fk_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MIN(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.catalog_category ccat ON cc.primary_category = ccat.id_catalog_category
    LEFT JOIN bob_live.catalog_category lv2 ON ccat.lft >= lv2.lft
        AND ccat.rgt <= lv2.rgt
        AND lv2.id_catalog_category <> 1
    WHERE
        soish.created_at >= @period_1
            AND soish.created_at < @end_period
            AND soi.fk_sales_order_item_status = 27
    GROUP BY bob_id_sales_order_item) result
GROUP BY lv3