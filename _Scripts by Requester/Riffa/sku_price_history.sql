SELECT 
    *
FROM
    (SELECT 
        sel.short_code,
            sel.name 'seller_name',
            soi.sku,
            soi.name 'item_name',
            MIN(IF(so.created_at >= '2016-08-01'
                AND so.created_at < '2016-09-01', unit_price, NULL)) 'min_unit_price_aug',
            MAX(IF(so.created_at >= '2016-08-01'
                AND so.created_at < '2016-09-01', unit_price, NULL)) 'max_unit_price_aug',
            AVG(IF(so.created_at >= '2016-08-01'
                AND so.created_at < '2016-09-01', unit_price, NULL)) 'avg_unit_price_aug',
            SUM(IF(so.created_at >= '2016-08-01'
                AND so.created_at < '2016-09-01' IS NOT NULL, 1, 0)) 'soi_count_aug',
            SUM(IF(so.created_at >= '2016-08-01'
                AND so.created_at < '2016-09-01'
                AND soish.id_sales_order_item_status_history IS NOT NULL, 1, 0)) 'soi_count_aug_ship',
            MIN(IF(so.created_at >= '2016-09-01'
                AND so.created_at < '2016-10-01', unit_price, NULL)) 'min_unit_price_sep',
            MAX(IF(so.created_at >= '2016-09-01'
                AND so.created_at < '2016-10-01', unit_price, NULL)) 'max_unit_price_sep',
            AVG(IF(so.created_at >= '2016-09-01'
                AND so.created_at < '2016-10-01', unit_price, NULL)) 'avg_unit_price_sep',
            SUM(IF(so.created_at >= '2016-09-01'
                AND so.created_at < '2016-10-01', 1, 0)) 'soi_count_sep',
            SUM(IF(so.created_at >= '2016-09-01'
                AND so.created_at < '2016-10-01'
                AND soish.id_sales_order_item_status_history IS NOT NULL, 1, 0)) 'soi_count_sep_ship'
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 5)
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN screport.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        so.created_at >= '2016-08-01'
            AND so.created_at < '2016-10-01'
            AND soi.bob_id_supplier IN ('1244' , '6698', '9088', '15098', '19014', '20020', '21995', '23516', '29585', '34830', '52213')
    GROUP BY soi.bob_id_supplier , soi.sku) result;