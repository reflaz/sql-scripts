/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Bob Category Tree by SKU
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @tax_class accordingly
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- DO NOT CHANGE THIS EVER!
SET @lvl = 0;

SELECT 
    sku.sku,
    catree.lvl1
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
        IFNULL(lvl0_id, '') 'lvl0_id',
            IFNULL(lvl0, '') 'lvl0',
            IFNULL(lvl1_id, '') 'lvl1_id',
            IFNULL(lvl1, '') 'lvl1',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'lvl0_id',
            MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'lvl1_id',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.name_en 'cc0_name',
            cc1.id_catalog_category 'cc1_id',
            cc1.name_en 'cc1_name',
            cc1.lft,
            cc1.rgt
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) catree ON sku.primary_category = catree.cc0_id;