SET @lvl = 0;
SET @tax_class = 'local';

SELECT 
    sel.id_seller,
    sel.short_code,
    sel.name,
    result.*,
    sc00.percentage 'cc00_global',
    sc00.percentage 'cc00_seller',
    sc01.percentage 'cc01_global',
    sc01.percentage 'cc01_seller'
FROM
    (SELECT 
        *
    FROM
        screport.seller
    WHERE
        id_seller IN (507 , 2372)) sel
        CROSS JOIN
    (SELECT 
        cc00.id_catalog_category 'cc00_id',
            cc00.name_en 'cc00_name',
            cc01.id_catalog_category 'cc01_id',
            cc01.name_en 'cc01_name',
            IF(cc01.id_catalog_category = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        screport.catalog_category cc00
    LEFT JOIN screport.catalog_category cc01 ON cc00.lft >= cc01.lft
        AND cc00.rgt <= cc01.rgt
    WHERE
        cc00.status = 'active'
            AND cc00.visible = 1) result
        LEFT JOIN
    screport.seller_commission sc00 ON result.cc00_id = sc00.fk_catalog_category
        AND sc00.fk_seller IS NULL
        AND sc00.tax_class = @tax_class
        LEFT JOIN
    screport.seller_commission sc01 ON result.cc01_id = sc01.fk_catalog_category
        AND sc01.fk_seller IS NULL
        AND sc01.tax_class = @tax_class
        LEFT JOIN
    screport.seller_commission sc10 ON result.cc00_id = sc10.fk_catalog_category
        AND sc00.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc11 ON result.cc01_id = sc11.fk_catalog_category
        AND sc01.fk_seller = sel.id_seller