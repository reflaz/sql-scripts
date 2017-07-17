SET @lvl = 0;
SET @tax_class = 'local';

SELECT 
    result.*,
    sc00.percentage 'cc00_general',
    sc01.percentage 'cc01_general'
FROM
    (SELECT 
        *, IF(cc01_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc00.id_catalog_category 'cc00_id',
            cc00.name_en 'cc00_name',
            cc01.id_catalog_category 'cc01_id',
            cc01.name_en 'cc01_name',
            cc00.lft 'cc00_lft',
            cc00.rgt 'cc00_rgt',
            cc01.lft 'cc01_lft',
            cc01.rgt 'cc01_rgt'
    FROM
        screport.catalog_category cc00
    LEFT JOIN screport.catalog_category cc01 ON cc00.lft >= cc01.lft
        AND cc00.rgt <= cc01.rgt
    WHERE
        cc00.status = 'active'
            AND cc00.visible = 1
    ORDER BY cc00.lft , cc00.rgt , cc01.lft , cc00.rgt) result) result
        LEFT JOIN
    screport.seller_commission sc00 ON result.cc00_id = sc00.fk_catalog_category
        AND sc00.fk_seller IS NULL
        AND sc00.tax_class = @tax_class
        LEFT JOIN
    screport.seller_commission sc01 ON result.cc01_id = sc01.fk_catalog_category
        AND sc01.fk_seller IS NULL
        AND sc01.tax_class = @tax_class