SET @lvl = 0;
SET @tax_class = 'local';

SELECT 
    cc.name_en 'catalog_category',
    IFNULL(lv1.name_en, '') 'lv1',
    IFNULL(lv2.name_en, '') 'lv2',
    IFNULL(lv3.name_en, '') 'lv3',
    IFNULL(lv4.name_en, '') 'lv4',
    IFNULL(lv5.name_en, '') 'lv5',
    IFNULL(sc5.percentage,
            IFNULL(sc4.percentage,
                    IFNULL(sc3.percentage,
                            IFNULL(sc2.percentage, sc1.percentage)))) 'commission'
FROM
    (SELECT 
        *
    FROM
        screport.catalog_category
    WHERE
        status = 'active' AND visible = 1
            AND id_catalog_category > 1) cc
        LEFT JOIN
    screport.catalog_category lv1 ON cc.lft >= lv1.lft AND cc.rgt <= lv1.rgt
        AND lv1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        LIMIT 1 , 1)
        LEFT JOIN
    screport.catalog_category lv2 ON cc.lft >= lv2.lft AND cc.rgt <= lv2.rgt
        AND lv2.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        LIMIT 2 , 1)
        LEFT JOIN
    screport.catalog_category lv3 ON cc.lft >= lv3.lft AND cc.rgt <= lv3.rgt
        AND lv3.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        LIMIT 3 , 1)
        LEFT JOIN
    screport.catalog_category lv4 ON cc.lft >= lv4.lft AND cc.rgt <= lv4.rgt
        AND lv4.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        LIMIT 4 , 1)
        LEFT JOIN
    screport.catalog_category lv5 ON cc.lft >= lv5.lft AND cc.rgt <= lv5.rgt
        AND lv5.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cc.lft AND rgt >= cc.rgt
        LIMIT 5 , 1)
        LEFT JOIN
    screport.seller_commission sc1 ON lv1.id_catalog_category = sc1.fk_catalog_category
        AND sc1.tax_class = @tax_class
        AND sc1.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc2 ON lv2.id_catalog_category = sc2.fk_catalog_category
        AND sc2.tax_class = @tax_class
        AND sc2.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc3 ON lv3.id_catalog_category = sc3.fk_catalog_category
        AND sc3.tax_class = @tax_class
        AND sc3.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc4 ON lv4.id_catalog_category = sc4.fk_catalog_category
        AND sc4.tax_class = @tax_class
        AND sc4.fk_seller IS NULL
        LEFT JOIN
    screport.seller_commission sc5 ON lv5.id_catalog_category = sc5.fk_catalog_category
        AND sc5.tax_class = @tax_class
        AND sc5.fk_seller IS NULL