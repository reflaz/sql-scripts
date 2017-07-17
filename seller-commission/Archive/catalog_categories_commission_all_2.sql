SET @tax_class = 'local';


SELECT 
    sel.src_id 'seller_id',
    sel.short_code 'sc_seller_id',
    sel.name 'seller_name',
    sel.tax_class 'tax_class',
    lv0.name_en 'lv0',
    lv1.name_en 'lv1',
    lv2.name_en 'lv2',
    lv3.name_en 'lv3',
    lv4.name_en 'lv4',
    lv5.name_en 'lv5',
    lv6.name_en 'lv6',
    IFNULL(IFNULL(sc16.percentage, sc06.percentage),
            IFNULL(IFNULL(sc15.percentage, sc05.percentage),
                    IFNULL(IFNULL(sc14.percentage, sc04.percentage),
                            IFNULL(IFNULL(sc13.percentage, sc03.percentage),
                                    IFNULL(IFNULL(sc12.percentage, sc02.percentage),
                                            IFNULL(IFNULL(sc11.percentage, sc01.percentage),
                                                    IFNULL(sc10.percentage, sc00.percentage))))))) 'commission'
FROM
    (SELECT 
        *
    FROM
        screport.seller
    WHERE
        tax_class = @tax_class AND verified = 1
            AND account_status = 1) sel
        CROSS JOIN
    screport.catalog_category cc
        LEFT JOIN
    screport.catalog_category lv0 ON cc.lft >= lv0.lft AND cc.rgt <= lv0.rgt
        AND lv0.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 0 , 1)
        LEFT JOIN
    screport.catalog_category lv1 ON cc.lft >= lv1.lft AND cc.rgt <= lv1.rgt
        AND lv1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 1 , 1)
        LEFT JOIN
    screport.catalog_category lv2 ON cc.lft >= lv2.lft AND cc.rgt <= lv2.rgt
        AND lv2.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 2 , 1)
        LEFT JOIN
    screport.catalog_category lv3 ON cc.lft >= lv3.lft AND cc.rgt <= lv3.rgt
        AND lv3.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 3 , 1)
        LEFT JOIN
    screport.catalog_category lv4 ON cc.lft >= lv4.lft AND cc.rgt <= lv4.rgt
        AND lv4.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 4 , 1)
        LEFT JOIN
    screport.catalog_category lv5 ON cc.lft >= lv5.lft AND cc.rgt <= lv5.rgt
        AND lv5.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 5 , 1)
        LEFT JOIN
    screport.catalog_category lv6 ON cc.lft >= lv6.lft AND cc.rgt <= lv6.rgt
        AND lv6.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        ORDER BY lft , rgt
        LIMIT 6 , 1)
        LEFT JOIN
    screport.seller_commission sc00 ON lv0.id_catalog_category = sc00.fk_catalog_category
        AND sc00.tax_class = @tax_class
        AND sc00.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc01 ON lv1.id_catalog_category = sc01.fk_catalog_category
        AND sc01.tax_class = @tax_class
        AND sc01.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc02 ON lv2.id_catalog_category = sc02.fk_catalog_category
        AND sc02.tax_class = @tax_class
        AND sc02.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc03 ON lv3.id_catalog_category = sc03.fk_catalog_category
        AND sc03.tax_class = @tax_class
        AND sc03.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc04 ON lv4.id_catalog_category = sc04.fk_catalog_category
        AND sc04.tax_class = @tax_class
        AND sc04.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc05 ON lv5.id_catalog_category = sc05.fk_catalog_category
        AND sc05.tax_class = @tax_class
        AND sc05.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc06 ON lv6.id_catalog_category = sc06.fk_catalog_category
        AND sc06.tax_class = @tax_class
        AND sc06.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc10 ON lv0.id_catalog_category = sc10.fk_catalog_category
        AND sc10.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc11 ON lv0.id_catalog_category = sc11.fk_catalog_category
        AND sc11.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc12 ON lv0.id_catalog_category = sc12.fk_catalog_category
        AND sc12.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc13 ON lv0.id_catalog_category = sc13.fk_catalog_category
        AND sc13.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc14 ON lv0.id_catalog_category = sc14.fk_catalog_category
        AND sc14.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc15 ON lv0.id_catalog_category = sc15.fk_catalog_category
        AND sc15.fk_seller = sel.id_seller
        LEFT JOIN
    screport.seller_commission sc16 ON lv0.id_catalog_category = sc16.fk_catalog_category
        AND sc16.fk_seller = sel.id_seller
WHERE
    cc.status = 'active'
        AND cc.status = 'active';