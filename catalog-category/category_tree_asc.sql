SELECT 
    *
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
            
            cat.category_id 'id_cat',
            cat.category_name 'cat'
    FROM
        asc_live.std_categories cat
    LEFT JOIN asc_live.std_categories p1 ON cat.parent_id = p1.category_id
    LEFT JOIN asc_live.std_categories p2 ON p1.parent_id = p2.category_id
    LEFT JOIN asc_live.std_categories p3 ON p2.parent_id = p3.category_id
    LEFT JOIN asc_live.std_categories p4 ON p3.parent_id = p4.category_id
    LEFT JOIN asc_live.std_categories p5 ON p4.parent_id = p5.category_id
    LEFT JOIN asc_live.std_categories p6 ON p5.parent_id = p6.category_id) result;