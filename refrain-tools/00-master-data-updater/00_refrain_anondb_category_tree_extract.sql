/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Bob Category Tree
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- DO NOT CHANGE THIS EVER!
SET @lvl = 0;

SELECT 
    *
FROM
    (SELECT 
        id_catalog_category,
            regional_key,
            category_name,
            category_status,
            id_level0,
            level0,
            id_level1,
            level1,
            id_level2,
            level2,
            id_level3,
            level3,
            id_level4,
            level4,
            id_level5,
            level5,
            id_level6,
            level6,
            CASE
                WHEN regional_key IS NOT NULL THEN regional_key
                WHEN regional_key_level6 IS NOT NULL THEN regional_key_level6
                WHEN regional_key_level5 IS NOT NULL THEN regional_key_level5
                WHEN regional_key_level4 IS NOT NULL THEN regional_key_level4
                WHEN regional_key_level3 IS NOT NULL THEN regional_key_level3
                WHEN regional_key_level2 IS NOT NULL THEN regional_key_level2
                WHEN regional_key_level1 IS NOT NULL THEN regional_key_level1
                WHEN regional_key_level0 IS NOT NULL THEN regional_key_level0
            END 'resulting_regional_key',
            CASE
                WHEN status_level0 IS NOT NULL AND status_level0 <> 'active' THEN status_level0
                WHEN status_level1 IS NOT NULL AND status_level1 <> 'active' THEN status_level1
                WHEN status_level2 IS NOT NULL AND status_level2 <> 'active' THEN status_level2
                WHEN status_level3 IS NOT NULL AND status_level3 <> 'active' THEN status_level3
                WHEN status_level4 IS NOT NULL AND status_level4 <> 'active' THEN status_level4
                WHEN status_level5 IS NOT NULL AND status_level5 <> 'active' THEN status_level5
                WHEN status_level6 IS NOT NULL AND status_level6 <> 'active' THEN status_level6
                ELSE category_status
            END 'resulting_status'
    FROM
        (SELECT 
        cc0_id 'id_catalog_category',
            cc0_regional_key 'regional_key',
            cc0_name 'category_name',
            cc0_status 'category_status',
            MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'id_level0',
            MIN(IF(catree.lvl = 0, catree.cc1_regional_key, NULL)) 'regional_key_level0',
            MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'level0',
            MIN(IF(catree.lvl = 0, catree.cc1_status, NULL)) 'status_level0',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'id_level1',
            MIN(IF(catree.lvl = 1, catree.cc1_regional_key, NULL)) 'regional_key_level1',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'level1',
            MIN(IF(catree.lvl = 1, catree.cc1_status, NULL)) 'status_level1',
            MIN(IF(catree.lvl = 2, catree.cc1_id, NULL)) 'id_level2',
            MIN(IF(catree.lvl = 2, catree.cc1_regional_key, NULL)) 'regional_key_level2',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'level2',
            MIN(IF(catree.lvl = 2, catree.cc1_status, NULL)) 'status_level2',
            MIN(IF(catree.lvl = 3, catree.cc1_id, NULL)) 'id_level3',
            MIN(IF(catree.lvl = 3, catree.cc1_regional_key, NULL)) 'regional_key_level3',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'level3',
            MIN(IF(catree.lvl = 3, catree.cc1_status, NULL)) 'status_level3',
            MIN(IF(catree.lvl = 4, catree.cc1_id, NULL)) 'id_level4',
            MIN(IF(catree.lvl = 4, catree.cc1_regional_key, NULL)) 'regional_key_level4',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'level4',
            MIN(IF(catree.lvl = 4, catree.cc1_status, NULL)) 'status_level4',
            MIN(IF(catree.lvl = 5, catree.cc1_id, NULL)) 'id_level5',
            MIN(IF(catree.lvl = 5, catree.cc1_regional_key, NULL)) 'regional_key_level5',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'level5',
            MIN(IF(catree.lvl = 5, catree.cc1_status, NULL)) 'status_level5',
            MIN(IF(catree.lvl = 6, catree.cc1_id, NULL)) 'id_level6',
            MIN(IF(catree.lvl = 6, catree.cc1_regional_key, NULL)) 'regional_key_level6',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'level6',
            MIN(IF(catree.lvl = 6, catree.cc1_status, NULL)) 'status_level6'
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.regional_key 'cc0_regional_key',
            cc0.name_en 'cc0_name',
            cc0.status 'cc0_status',
            cc1.id_catalog_category 'cc1_id',
            cc1.regional_key 'cc1_regional_key',
            cc1.name_en 'cc1_name',
            cc1.status 'cc1_status',
            cc1.lft,
            cc1.rgt
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) result