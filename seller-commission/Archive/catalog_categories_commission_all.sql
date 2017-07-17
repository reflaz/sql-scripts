SET @lvl = 0;
SET @tax_class = 'international';

SELECT 
    *
FROM
    (SELECT 
        lvl1,
            IF(lvl2 <> lvl1, lvl2, '') 'lvl2',
            IF(lvl3 <> lvl2, lvl3, '') 'lvl3',
            IF(lvl4 <> lvl3, lvl4, '') 'lvl4',
            IF(lvl5 <> lvl4, lvl5, '') 'lvl5',
            IF(lvl6 <> lvl5, lvl6, '') 'lvl6',
            IF(lvl7 <> lvl6, lvl7, '') 'lvl7',
            IF(lvl7_v = 0, 'false', 'true') 'visible',
            IF(IF(lvl7_v = 0, lvl7_v, IF(lvl6_v = 0, lvl6_v, IF(lvl5_v = 0, lvl5_v, IF(lvl4_v = 0, lvl4_v, IF(lvl3_v = 0, lvl3_v, IF(lvl2_v = 0, lvl2_v, lvl1_v)))))) = 0, 'false', 'true') 'resulting_visible',
            IFNULL(lvl7_p, '') 'general_commission',
            IFNULL(lvl7_p, IFNULL(lvl6_p, IFNULL(lvl5_p, IFNULL(lvl4_p, IFNULL(lvl3_p, IFNULL(lvl2_p, IFNULL(lvl1_p, lvl0_p))))))) 'resulting_commission'
    FROM
        (SELECT 
        IFNULL(MIN(IF(lvl = 0, cc1_name, NULL)), cc0_name) 'lvl0',
            IFNULL(MIN(IF(lvl = 0, cc1_percentage, NULL)), cc1_percentage) 'lvl0_p',
            IFNULL(MIN(IF(lvl = 1, cc1_name, NULL)), cc0_name) 'lvl1',
            IFNULL(MIN(IF(lvl = 1, cc1_visible, NULL)), cc0_visible) 'lvl1_v',
            IFNULL(MIN(IF(lvl = 1, cc1_percentage, NULL)), cc0_percentage) 'lvl1_p',
            IFNULL(MIN(IF(lvl = 2, cc1_name, NULL)), cc0_name) 'lvl2',
            IFNULL(MIN(IF(lvl = 2, cc1_visible, NULL)), cc0_visible) 'lvl2_v',
            IFNULL(MIN(IF(lvl = 2, cc1_percentage, NULL)), cc0_percentage) 'lvl2_p',
            IFNULL(MIN(IF(lvl = 3, cc1_name, NULL)), cc0_name) 'lvl3',
            IFNULL(MIN(IF(lvl = 3, cc1_visible, NULL)), cc0_visible) 'lvl3_v',
            IFNULL(MIN(IF(lvl = 3, cc1_percentage, NULL)), cc0_percentage) 'lvl3_p',
            IFNULL(MIN(IF(lvl = 4, cc1_name, NULL)), cc0_name) 'lvl4',
            IFNULL(MIN(IF(lvl = 4, cc1_visible, NULL)), cc0_visible) 'lvl4_v',
            IFNULL(MIN(IF(lvl = 4, cc1_percentage, NULL)), cc0_percentage) 'lvl4_p',
            IFNULL(MIN(IF(lvl = 5, cc1_name, NULL)), cc0_name) 'lvl5',
            IFNULL(MIN(IF(lvl = 5, cc1_visible, NULL)), cc0_visible) 'lvl5_v',
            IFNULL(MIN(IF(lvl = 5, cc1_percentage, NULL)), cc0_percentage) 'lvl5_p',
            IFNULL(MIN(IF(lvl = 6, cc1_name, NULL)), cc0_name) 'lvl6',
            IFNULL(MIN(IF(lvl = 6, cc1_visible, NULL)), cc0_visible) 'lvl6_v',
            IFNULL(MIN(IF(lvl = 6, cc1_percentage, NULL)), cc0_percentage) 'lvl6_p',
            IFNULL(MIN(IF(lvl = 7, cc1_name, NULL)), cc0_name) 'lvl7',
            IFNULL(MIN(IF(lvl = 7, cc1_visible, NULL)), cc0_visible) 'lvl7_v',
            IFNULL(MIN(IF(lvl = 7, cc1_percentage, NULL)), cc0_percentage) 'lvl7_p'
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.lft 'cc0_lft',
            cc0.rgt 'cc0_rgt',
            cc0.name_en 'cc0_name',
            cc0.visible 'cc0_visible',
            sc0.percentage 'cc0_percentage',
            cc1.id_catalog_category 'cc1_id',
            cc1.lft 'cc1_lft',
            cc1.rgt 'cc1_rgt',
            cc1.name_en 'cc1_name',
            cc1.visible 'cc1_visible',
            sc1.percentage 'cc1_percentage'
    FROM
        screport.catalog_category cc0
    LEFT JOIN screport.catalog_category cc1 ON cc0.lft > cc1.lft AND cc0.rgt < cc1.rgt
    LEFT JOIN screport.seller_commission sc0 ON cc0.id_catalog_category = sc0.fk_catalog_category
        AND sc0.fk_seller IS NULL
        AND sc0.tax_class = @tax_class
    LEFT JOIN screport.seller_commission sc1 ON cc1.id_catalog_category = sc1.fk_catalog_category
        AND sc1.fk_seller IS NULL
        AND sc1.tax_class = @tax_class
    WHERE
        cc0.id_catalog_category <> 1
            AND cc0.status = 'active'
            AND cc1.status = 'active'
    ORDER BY cc0.lft , cc0.rgt , cc1.lft , cc1.rgt) result) result
    GROUP BY cc0_id) result) result