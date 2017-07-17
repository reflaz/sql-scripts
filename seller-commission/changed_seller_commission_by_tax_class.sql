/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Seller Commission
 
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

-- Change this before running the script
SET @tax_class = 'local'; -- MUST be filled with local or international

-- DO NOT CHANGE THIS EVER!
SET @lvl = 0;

SELECT 
    src_id 'Seller ID',
    short_code 'SC Seller ID',
    name 'Seller Name',
    IFNULL(lvl0, '') 'Level 0',
    IFNULL(lvl1, '') 'Level 1',
    IFNULL(lvl2, '') 'Level 2',
    IFNULL(lvl3, '') 'Level 3',
    IFNULL(lvl4, '') 'Level 4',
    IFNULL(lvl5, '') 'Level 5',
    IFNULL(lvl6, '') 'Level 6',
    general_commission 'General Commission',
    sc.percentage 'Seller Commission',
    cc0_id 'Lookup Cat. ID',
    cc0_name 'Lookup Cat. Name'
FROM
    (SELECT 
        *
    FROM
        asc_live.seller_commission
    WHERE
        fk_seller IS NOT NULL) sc
        JOIN
    (SELECT 
        cc0_id,
            cc0_name,
            MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 0, catree.percentage, NULL)) 'comm00',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            MIN(IF(catree.lvl = 1, catree.percentage, NULL)) 'comm01',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'lvl2',
            MIN(IF(catree.lvl = 2, catree.percentage, NULL)) 'comm02',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'lvl3',
            MIN(IF(catree.lvl = 3, catree.percentage, NULL)) 'comm03',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'lvl4',
            MIN(IF(catree.lvl = 4, catree.percentage, NULL)) 'comm04',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'lvl5',
            MIN(IF(catree.lvl = 5, catree.percentage, NULL)) 'comm05',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'lvl6',
            MIN(IF(catree.lvl = 6, catree.percentage, NULL)) 'comm06',
            IFNULL(MIN(IF(catree.lvl = 6, catree.percentage, NULL)), IFNULL(MIN(IF(catree.lvl = 5, catree.percentage, NULL)), IFNULL(MIN(IF(catree.lvl = 4, catree.percentage, NULL)), IFNULL(MIN(IF(catree.lvl = 3, catree.percentage, NULL)), IFNULL(MIN(IF(catree.lvl = 2, catree.percentage, NULL)), IFNULL(MIN(IF(catree.lvl = 1, catree.percentage, NULL)), MIN(IF(catree.lvl = 0, catree.percentage, NULL)))))))) 'general_commission'
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
            cc1.rgt,
            sc1.percentage
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    LEFT JOIN asc_live.seller_commission sc1 ON cc1.id_catalog_category = sc1.fk_catalog_category
        AND sc1.fk_seller IS NULL
        AND sc1.tax_class = @tax_class
    WHERE
        cc0.status = 'active'
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000) catree) catree
    GROUP BY cc0_id) catree ON sc.fk_catalog_category = catree.cc0_id
        JOIN
    asc_live.seller sel ON sc.fk_seller = sel.id_seller
        AND sel.tax_class = @tax_class