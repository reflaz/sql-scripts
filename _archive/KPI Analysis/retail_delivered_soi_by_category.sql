SET @extractstart = '2016-09-01';
SET @extractend = '2016-10-01';

SELECT 
    lvl1,
    SUM(unit_price) 'unit_price',
    SUM(paid_price) 'paid_price',
    SUM(shipping_amount) 'shipping_amount',
    SUM(shipping_surcharge) 'shipping_surcharge',
    SUM(nmv) 'nmv',
    SUM(cogs) 'cogs',
    COUNT(DISTINCT fk_sales_order) 'count_so',
    COUNT(id_sales_order_item) 'count_soi'
FROM
    (SELECT 
        soi.id_sales_order_item,
            soi.fk_sales_order,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            soi.paid_price + soi.shipping_amount + soi.shipping_surcharge 'nmv',
            IFNULL(poi.cost, spd.cost) 'cogs',
            sup.type,
            lvl1
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_dispatching pd ON pck.id_package = pd.fk_package
    LEFT JOIN oms_live.oms_shipment_provider sp ON pd.fk_shipment_provider = sp.id_shipment_provider
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.id_sales_order_item_status_history = (SELECT 
            MAX(id_sales_order_item_status_history)
        FROM
            oms_live.ims_sales_order_item_status_history
        WHERE
            fk_sales_order_item = soi.id_sales_order_item
                AND fk_sales_order_item_status = 27)
    LEFT JOIN oms_live.wms_inventory inv ON soi.id_sales_order_item = inv.sales_order_item_id
    LEFT JOIN oms_live.ims_purchase_order_item poi ON inv.fk_purchase_order_item = poi.id_purchase_order_item
    LEFT JOIN oms_live.ims_supplier_product spd ON soi.sku = spd.sku
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN (SELECT 
        IFNULL(lvl0_id, '') 'lvl0_id',
            IFNULL(lvl0, '') 'lvl0',
            IFNULL(lvl1_id, '') 'lvl1_id',
            IFNULL(lvl1, '') 'lvl1',
            IFNULL(lvl2_id, '') 'lvl2_id',
            IFNULL(lvl2, '') 'lvl2',
            IFNULL(lvl3_id, '') 'lvl3_id',
            IFNULL(lvl3, '') 'lvl3',
            IFNULL(lvl4_id, '') 'lvl4_id',
            IFNULL(lvl4, '') 'lvl4',
            IFNULL(lvl5_id, '') 'lvl5_id',
            IFNULL(lvl5, '') 'lvl5',
            IFNULL(lvl6_id, '') 'lvl6_id',
            IFNULL(lvl6, '') 'lvl6',
            cc0_id,
            cc0_name
    FROM
        (SELECT 
        MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'lvl0_id',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'lvl1_id',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'lvl2',
            MIN(IF(catree.lvl = 2, catree.cc1_id, NULL)) 'lvl2_id',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'lvl3',
            MIN(IF(catree.lvl = 3, catree.cc1_id, NULL)) 'lvl3_id',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'lvl4',
            MIN(IF(catree.lvl = 4, catree.cc1_id, NULL)) 'lvl4_id',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'lvl5',
            MIN(IF(catree.lvl = 5, catree.cc1_id, NULL)) 'lvl5_id',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'lvl6',
            MIN(IF(catree.lvl = 6, catree.cc1_id, NULL)) 'lvl6_id',
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
    WHERE
        cc0.status = 'active'
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) catree ON cc.primary_category = catree.cc0_id
    WHERE
        soish.created_at >= @extractstart
            AND soish.created_at < @extractend
            AND sup.type = 'supplier'
    GROUP BY soi.id_sales_order_item) result
GROUP BY lvl1