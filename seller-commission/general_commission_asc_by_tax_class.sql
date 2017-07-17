SET @tax_class = 'local';

SELECT 
    id_lvl0,
    lvl0,
    id_lvl1,
    lvl1,
    id_lvl2,
    lvl2,
    id_lvl3,
    lvl3,
    id_lvl4,
    lvl4,
    id_lvl5,
    lvl5,
    id_lvl6,
    lvl6,
    id_cat,
    cat,
    CASE
		WHEN lvl6_com IS NOT NULL THEN lvl6_com
        WHEN lvl5_com IS NOT NULL THEN lvl5_com
        WHEN lvl4_com IS NOT NULL THEN lvl4_com
        WHEN lvl3_com IS NOT NULL THEN lvl3_com
        WHEN lvl2_com IS NOT NULL THEN lvl2_com
        WHEN lvl1_com IS NOT NULL THEN lvl1_com
        ELSE lvl0_com
    END 'percentage'
FROM
    (SELECT 
        CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN cat.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN p1.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p2.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p3.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p4.category_id
                WHEN p6.category_id IS NULL THEN p5.category_id
                ELSE p6.category_id
            END 'id_lvl0',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN cat.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN p1.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p2.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p3.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p4.category_name
                WHEN p6.category_id IS NULL THEN p5.category_name
                ELSE p6.category_name
            END 'lvl0',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN catsc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN p1sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p2sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p3sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p4sc.percentage
                WHEN p6.category_id IS NULL THEN p5sc.percentage
                ELSE p6sc.percentage
            END 'lvl0_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN cat.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p1.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p2.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p3.category_id
                WHEN p6.category_id IS NULL THEN p4.category_id
                ELSE p5.category_id
            END 'id_lvl1',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN cat.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p1.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p2.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p3.category_name
                WHEN p6.category_id IS NULL THEN p4.category_name
                ELSE p5.category_name
            END 'lvl1',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN catsc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN p1sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p2sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p3sc.percentage
                WHEN p6.category_id IS NULL THEN p4sc.percentage
                ELSE p5sc.percentage
            END 'lvl1_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN cat.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p1.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p2.category_id
                WHEN p6.category_id IS NULL THEN p3.category_id
                ELSE p4.category_id
            END 'id_lvl2',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN cat.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p1.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p2.category_name
                WHEN p6.category_id IS NULL THEN p3.category_name
                ELSE p4.category_name
            END 'lvl2',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN catsc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN p1sc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p2sc.percentage
                WHEN p6.category_id IS NULL THEN p3sc.percentage
                ELSE p4sc.percentage
            END 'lvl2_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN cat.category_id
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p1.category_id
                WHEN p6.category_id IS NULL THEN p2.category_id
                ELSE p3.category_id
            END 'id_lvl3',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN cat.category_name
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p1.category_name
                WHEN p6.category_id IS NULL THEN p2.category_name
                ELSE p3.category_name
            END 'lvl3',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN catsc.percentage
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN p1sc.percentage
                WHEN p6.category_id IS NULL THEN p2sc.percentage
                ELSE p3sc.percentage
            END 'lvl3_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN cat.category_id
                WHEN p6.category_id IS NULL THEN p1.category_id
                ELSE p2.category_id
            END 'id_lvl4',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN cat.category_name
                WHEN p6.category_id IS NULL THEN p1.category_name
                ELSE p2.category_name
            END 'lvl4',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN catsc.percentage
                WHEN p6.category_id IS NULL THEN p1sc.percentage
                ELSE p2sc.percentage
            END 'lvl4_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN cat.category_id
                ELSE p1.category_id
            END 'id_lvl5',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN cat.category_name
                ELSE p1.category_name
            END 'lvl5',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN catsc.percentage
                ELSE p1sc.percentage
            END 'lvl5_com',
            
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN NULL
                ELSE cat.category_id
            END 'id_lvl6',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN NULL
                ELSE cat.category_name
            END 'lvl6',
            CASE
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL AND p1.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL AND p2.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL AND p3.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL AND p4.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL AND p5.category_id IS NULL THEN NULL
                WHEN p6.category_id IS NULL THEN NULL
                ELSE catsc.percentage
            END 'lvl6_com',
            
            cat.category_id 'id_cat',
            cat.category_name 'cat'
    FROM
        asc_live.std_categories cat
    LEFT JOIN asc_live.std_categories p1 ON cat.parent_id = p1.category_id
    LEFT JOIN asc_live.std_categories p2 ON p1.parent_id = p2.category_id
    LEFT JOIN asc_live.std_categories p3 ON p2.parent_id = p3.category_id
    LEFT JOIN asc_live.std_categories p4 ON p3.parent_id = p4.category_id
    LEFT JOIN asc_live.std_categories p5 ON p4.parent_id = p5.category_id
    LEFT JOIN asc_live.std_categories p6 ON p5.parent_id = p6.category_id
    LEFT JOIN asc_live.seller_commission catsc ON cat.category_id = catsc.fk_catalog_category
		AND catsc.fk_seller IS NULL
        AND catsc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p1sc ON p1.category_id = p1sc.fk_catalog_category
		AND p1sc.fk_seller IS NULL
        AND p1sc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p2sc ON p2.category_id = p2sc.fk_catalog_category
		AND p2sc.fk_seller IS NULL
        AND p2sc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p3sc ON p3.category_id = p3sc.fk_catalog_category
		AND p3sc.fk_seller IS NULL
        AND p3sc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p4sc ON p4.category_id = p4sc.fk_catalog_category
		AND p4sc.fk_seller IS NULL
        AND p4sc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p5sc ON p5.category_id = p5sc.fk_catalog_category
		AND p5sc.fk_seller IS NULL
        AND p5sc.tax_class = @tax_class
    LEFT JOIN asc_live.seller_commission p6sc ON p6.category_id = p6sc.fk_catalog_category
		AND p6sc.fk_seller IS NULL
        AND p6sc.tax_class = @tax_class
    ) result;