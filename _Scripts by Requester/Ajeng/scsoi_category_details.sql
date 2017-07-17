SELECT 
    *
FROM
    (SELECT 
        so.order_nr,
            soi.id_sales_order_item 'sc_sales_order_item',
            soi.sku,
            sois.name 'item_status',
            so.created_at 'created_date',
            MIN(IF(soish.status = 'shipped', soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.status = 'delivered', soish.created_at, NULL)) 'delivered_date',
            cc1.name_en 'lv_1',
            cc2.name_en 'lv_2',
            cc3.name_en 'lv_3'
    FROM
        screport.sales_order_item soi
    LEFT JOIN screport.sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN screport.sales_order_item_status sois ON soi.fk_sales_order_item_status = sois.id_sales_order_item_status
    LEFT JOIN screport.sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
    LEFT JOIN screport.catalog_product cp ON soi.sku = cp.sku
    LEFT JOIN screport.catalog_category cc ON cp.primary_category = cc.id_catalog_category
    LEFT JOIN screport.catalog_category cc1 ON cc.lft >= cc1.lft AND cc.rgt <= cc1.rgt
        AND cc1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 1 , 1)
    LEFT JOIN screport.catalog_category cc2 ON cc.lft >= cc2.lft AND cc.rgt <= cc2.rgt
        AND cc2.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 2 , 1)
    LEFT JOIN screport.catalog_category cc3 ON cc.lft >= cc3.lft AND cc.rgt <= cc3.rgt
        AND cc3.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 3 , 1)
    WHERE
        soi.id_sales_order_item IN ('15331756')
    GROUP BY soi.id_sales_order_item) result