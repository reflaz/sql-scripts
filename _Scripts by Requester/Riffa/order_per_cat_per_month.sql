SET @extractstart = '2016-01-01';
SET @extractend = '2016-09-01';

SELECT 
    *
FROM
    (SELECT 
        primary_category,
            SUM(IF(created_at >= '2016-01-01'
                AND created_at < '2016-02-01', 1, 0)) 'january',
            SUM(IF(created_at >= '2016-02-01'
                AND created_at < '2016-03-01', 1, 0)) 'february',
            SUM(IF(created_at >= '2016-03-01'
                AND created_at < '2016-04-01', 1, 0)) 'march',
            SUM(IF(created_at >= '2016-04-01'
                AND created_at < '2016-05-01', 1, 0)) 'april',
            SUM(IF(created_at >= '2016-05-01'
                AND created_at < '2016-06-01', 1, 0)) 'may',
            SUM(IF(created_at >= '2016-06-01'
                AND created_at < '2016-07-01', 1, 0)) 'june',
            SUM(IF(created_at >= '2016-07-01'
                AND created_at < '2016-08-01', 1, 0)) 'july',
            SUM(IF(created_at >= '2016-08-01'
                AND created_at < '2016-09-01', 1, 0)) 'august'
    FROM
        (SELECT 
        cc.primary_category, reg.name, soish.created_at
    FROM
        (SELECT 
        fk_package
    FROM
        oms_live.oms_package_status_history
    WHERE
        created_at >= @extractstart
            AND created_at < @extractend
            AND fk_package_status = 6
    GROUP BY fk_package) psh
    LEFT JOIN oms_live.oms_package pck ON psh.fk_package = pck.id_package
    LEFT JOIN oms_live.oms_package_item pi ON pck.id_package = pi.fk_package
    LEFT JOIN oms_live.ims_sales_order_item soi ON pi.fk_sales_order_item = soi.id_sales_order_item
    JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    LEFT JOIN oms_live.ims_sales_order so ON soi.fk_sales_order = so.id_sales_order
    LEFT JOIN oms_live.ims_sales_order_address soa ON so.fk_sales_order_address_shipping = soa.id_sales_order_address
    LEFT JOIN oms_live.ims_customer_address_region dst ON soa.fk_customer_address_region = dst.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region cty ON dst.fk_customer_address_region = cty.id_customer_address_region
    LEFT JOIN oms_live.ims_customer_address_region reg ON cty.fk_customer_address_region = reg.id_customer_address_region
    LEFT JOIN bob_live.catalog_simple cs ON soi.sku = cs.sku
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    GROUP BY soi.id_sales_order_item
    HAVING reg.name IS NOT NULL) result
    GROUP BY primary_category) result;