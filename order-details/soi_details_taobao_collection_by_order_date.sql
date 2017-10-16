/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
SOI Details by Order Date
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Change @extractstart and @extractend for a specific weekly/monthly time frame before generating the report
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Change this before running the script
-- The format must be in 'YYYY-MM-DD'
SET @extractstart = '2017-09-01';
SET @extractend = '2017-10-01';-- This MUST be D + 1

SELECT 
    result.*, catree.*
FROM
    (SELECT 
        sup.id_supplier,
            sup.name,
            sup.type,
            sel.tax_class,
            soi.bob_id_sales_order_item,
            soi.unit_price,
            soi.paid_price,
            soi.shipping_amount,
            soi.shipping_surcharge,
            MIN(IF(soish.fk_sales_order_item_status = 67, soish.created_at, NULL)) 'verified_date',
            MIN(IF(soish.fk_sales_order_item_status = 5, soish.created_at, NULL)) 'shipped_date',
            MIN(IF(soish.fk_sales_order_item_status = 27, soish.real_action_date, NULL)) 'delivered_date',
            soi.sku,
            cc.primary_category
    FROM
        oms_live.ims_sales_order so
    LEFT JOIN oms_live.ims_sales_order_item soi ON so.id_sales_order = soi.fk_sales_order
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status IN (5 , 27, 67)
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cc.id_catalog_config = cs.fk_catalog_config
    LEFT JOIN bob_live.supplier sup ON soi.bob_id_supplier = sup.id_supplier
    LEFT JOIN asc_live.seller sel ON sup.id_supplier = sel.src_id
    WHERE
        so.created_at >= @extractstart
            AND so.created_at < @extractend
            AND soi.bob_id_supplier IN (18358 , 74322, 118514, 121939, 127131)
    GROUP BY soi.bob_id_sales_order_item
    HAVING verified_date IS NOT NULL) result
        LEFT JOIN
    (SELECT 
        IFNULL(lvl0_id, '') 'lvl0_id',
            IFNULL(lvl0_reg, '') 'lvl0_reg',
            IFNULL(lvl0, '') 'lvl0',
            IFNULL(lvl1_id, '') 'lvl1_id',
            IFNULL(lvl1_reg, '') 'lvl1_reg',
            IFNULL(lvl1, '') 'lvl1',
            IFNULL(lvl2_id, '') 'lvl2_id',
            IFNULL(lvl2_reg, '') 'lvl2_reg',
            IFNULL(lvl2, '') 'lvl2',
            IFNULL(lvl3_id, '') 'lvl3_id',
            IFNULL(lvl3_reg, '') 'lvl3_reg',
            IFNULL(lvl3, '') 'lvl3',
            IFNULL(lvl4_id, '') 'lvl4_id',
            IFNULL(lvl4_reg, '') 'lvl4_reg',
            IFNULL(lvl4, '') 'lvl4',
            IFNULL(lvl5_id, '') 'lvl5_id',
            IFNULL(lvl5_reg, '') 'lvl5_reg',
            IFNULL(lvl5, '') 'lvl5',
            IFNULL(lvl6_id, '') 'lvl6_id',
            IFNULL(lvl6_reg, '') 'lvl6_reg',
            IFNULL(lvl6, '') 'lvl6',
            cc0_id,
            cc0_regional_key,
            cc0_name
    FROM
        (SELECT 
        MIN(IF(catree.lvl = 0, catree.cc1_id, NULL)) 'lvl0_id',
            MIN(IF(catree.lvl = 0, catree.cc1_regional_key, NULL)) 'lvl0_reg',
            MIN(IF(catree.lvl = 0, catree.cc1_name, NULL)) 'lvl0',
            MIN(IF(catree.lvl = 1, catree.cc1_id, NULL)) 'lvl1_id',
            MIN(IF(catree.lvl = 1, catree.cc1_regional_key, NULL)) 'lvl1_reg',
            MIN(IF(catree.lvl = 1, catree.cc1_name, NULL)) 'lvl1',
            MIN(IF(catree.lvl = 2, catree.cc1_id, NULL)) 'lvl2_id',
            MIN(IF(catree.lvl = 2, catree.cc1_regional_key, NULL)) 'lvl2_reg',
            MIN(IF(catree.lvl = 2, catree.cc1_name, NULL)) 'lvl2',
            MIN(IF(catree.lvl = 3, catree.cc1_id, NULL)) 'lvl3_id',
            MIN(IF(catree.lvl = 3, catree.cc1_regional_key, NULL)) 'lvl3_reg',
            MIN(IF(catree.lvl = 3, catree.cc1_name, NULL)) 'lvl3',
            MIN(IF(catree.lvl = 4, catree.cc1_id, NULL)) 'lvl4_id',
            MIN(IF(catree.lvl = 4, catree.cc1_regional_key, NULL)) 'lvl4_reg',
            MIN(IF(catree.lvl = 4, catree.cc1_name, NULL)) 'lvl4',
            MIN(IF(catree.lvl = 5, catree.cc1_id, NULL)) 'lvl5_id',
            MIN(IF(catree.lvl = 5, catree.cc1_regional_key, NULL)) 'lvl5_reg',
            MIN(IF(catree.lvl = 5, catree.cc1_name, NULL)) 'lvl5',
            MIN(IF(catree.lvl = 6, catree.cc1_id, NULL)) 'lvl6_id',
            MIN(IF(catree.lvl = 6, catree.cc1_regional_key, NULL)) 'lvl6_reg',
            MIN(IF(catree.lvl = 6, catree.cc1_name, NULL)) 'lvl6',
            cc0_id,
            cc0_regional_key,
            cc0_name
    FROM
        (SELECT 
        *, IF(cc1_id = 1, @lvl:=0, @lvl:=@lvl + 1) 'lvl'
    FROM
        (SELECT 
        cc0.id_catalog_category 'cc0_id',
            cc0.regional_key 'cc0_regional_key',
            cc0.name_en 'cc0_name',
            cc1.id_catalog_category 'cc1_id',
            cc1.regional_key 'cc1_regional_key',
            cc1.name_en 'cc1_name',
            cc1.lft,
            cc1.rgt
    FROM
        bob_live.catalog_category cc0
    LEFT JOIN bob_live.catalog_category cc1 ON cc0.lft >= cc1.lft
        AND cc0.rgt <= cc1.rgt
    ORDER BY cc0.id_catalog_category , cc1.lft , cc1.rgt
    LIMIT 1000000000) catree) catree
    GROUP BY catree.cc0_id) result) catree ON result.primary_category = catree.cc0_id