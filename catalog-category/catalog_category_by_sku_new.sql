SELECT 
    sku.sku, catree.lvl1
FROM
    (SELECT 
        cs.sku, cc.primary_category
    FROM
        bob_live.catalog_simple cs
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    WHERE
        cs.sku IN ()) sku
        LEFT JOIN
    (SELECT 
        MAX(IF(cc2.lvl = 0, cc2.id_catalog_category, NULL)) 'level0_id',
            MAX(IF(cc2.lvl = 0, cc2.name_en, NULL)) 'level0',
            MAX(IF(cc2.lvl = 1, cc2.id_catalog_category, NULL)) 'level1_id',
            MAX(IF(cc2.lvl = 1, cc2.name_en, NULL)) 'level1',
            MAX(IF(cc2.lvl = 2, cc2.id_catalog_category, NULL)) 'level2_id',
            MAX(IF(cc2.lvl = 2, cc2.name_en, NULL)) 'level2',
            MAX(IF(cc2.lvl = 3, cc2.id_catalog_category, NULL)) 'level3_id',
            MAX(IF(cc2.lvl = 3, cc2.name_en, NULL)) 'level3',
            MAX(IF(cc2.lvl = 4, cc2.id_catalog_category, NULL)) 'level4_id',
            MAX(IF(cc2.lvl = 4, cc2.name_en, NULL)) 'level4',
            MAX(IF(cc2.lvl = 5, cc2.id_catalog_category, NULL)) 'level5_id',
            MAX(IF(cc2.lvl = 5, cc2.name_en, NULL)) 'level5',
            MAX(IF(cc2.lvl = 6, cc2.id_catalog_category, NULL)) 'level6_id',
            MAX(IF(cc2.lvl = 6, cc2.name_en, NULL)) 'level6',
            cc1.id_catalog_category 'id_catalog_category',
            cc1.name_en 'category_name',
            MAX(cc2.lvl) 'lvl',
            cc1.status
    FROM
        bob_live.catalog_category cc1
    LEFT JOIN bob_live.catalog_category cc2 ON cc1.lft >= cc2.lft
        AND cc1.rgt <= cc2.rgt
    GROUP BY cc1.id_catalog_category) catree ON sku.primary_category = catree.cc0_id;