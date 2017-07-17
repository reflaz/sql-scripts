/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Loan Application Data by Seller Center ID
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Insert formatted parameters
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

-- Insert parameter here
SET @scsellerid = 'ID119SH,ID10RZ2,ID109EK,ID10753';

-- DO NOT CHANGE THESE EVER!!

SET @end_period = DATE_FORMAT(IF(DAY(NOW()) > 15, DATE_ADD(NOW(), INTERVAL 1 MONTH), NOW()), '%Y-%m-01');
SET @period_1 = DATE_FORMAT(DATE_SUB(@end_period, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_2 = DATE_FORMAT(DATE_SUB(@period_1, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_3 = DATE_FORMAT(DATE_SUB(@period_2, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_4 = DATE_FORMAT(DATE_SUB(@period_3, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_5 = DATE_FORMAT(DATE_SUB(@period_4, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_6 = DATE_FORMAT(DATE_SUB(@period_5, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_7 = DATE_FORMAT(DATE_SUB(@period_6, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_8 = DATE_FORMAT(DATE_SUB(@period_7, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_9 = DATE_FORMAT(DATE_SUB(@period_8, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_10 = DATE_FORMAT(DATE_SUB(@period_9, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_11 = DATE_FORMAT(DATE_SUB(@period_10, INTERVAL 1 MONTH), '%Y-%m-01');
SET @period_12 = DATE_FORMAT(DATE_SUB(@period_11, INTERVAL 1 MONTH), '%Y-%m-01');

SELECT '12' AS 'period', DATE_FORMAT(@period_12, '%M %Y') 'month', @period_12 AS 'beginning_date'
UNION ALL SELECT '11' AS 'period', DATE_FORMAT(@period_11, '%M %Y'), @period_11
UNION ALL SELECT '10' AS 'period', DATE_FORMAT(@period_10, '%M %Y'), @period_10
UNION ALL SELECT '09' AS 'period', DATE_FORMAT(@period_9, '%M %Y'), @period_9 
UNION ALL SELECT '08' AS 'period', DATE_FORMAT(@period_8, '%M %Y'), @period_8 
UNION ALL SELECT '07' AS 'period', DATE_FORMAT(@period_7, '%M %Y'), @period_7 
UNION ALL SELECT '06' AS 'period', DATE_FORMAT(@period_6, '%M %Y'), @period_6 
UNION ALL SELECT '05' AS 'period', DATE_FORMAT(@period_5, '%M %Y'), @period_5 
UNION ALL SELECT '04' AS 'period', DATE_FORMAT(@period_4, '%M %Y'), @period_4 
UNION ALL SELECT '03' AS 'period', DATE_FORMAT(@period_3, '%M %Y'), @period_3 
UNION ALL SELECT '02' AS 'period', DATE_FORMAT(@period_2, '%M %Y'), @period_2 
UNION ALL SELECT '01' AS 'period', DATE_FORMAT(@period_1, '%M %Y'), @period_1 
UNION ALL SELECT 'end_period' AS 'period', DATE_FORMAT(@end_period, '%M  %Y'), @end_period;

SELECT 
    *
FROM
    (SELECT 
        result.*,
            SUM(IF(ts.end_date >= @period_12
                AND ts.end_date < @period_11, ts.payout, 0)) 'payout_12',
            SUM(IF(ts.end_date >= @period_11
                AND ts.end_date < @period_10, ts.payout, 0)) 'payout_11',
            SUM(IF(ts.end_date >= @period_10
                AND ts.end_date < @period_9, ts.payout, 0)) 'payout_10',
            SUM(IF(ts.end_date >= @period_9
                AND ts.end_date < @period_8, ts.payout, 0)) 'payout_09',
            SUM(IF(ts.end_date >= @period_8
                AND ts.end_date < @period_7, ts.payout, 0)) 'payout_08',
            SUM(IF(ts.end_date >= @period_7
                AND ts.end_date < @period_6, ts.payout, 0)) 'payout_07',
            SUM(IF(ts.end_date >= @period_6
                AND ts.end_date < @period_5, ts.payout, 0)) 'payout_06',
            SUM(IF(ts.end_date >= @period_5
                AND ts.end_date < @period_4, ts.payout, 0)) 'payout_05',
            SUM(IF(ts.end_date >= @period_4
                AND ts.end_date < @period_3, ts.payout, 0)) 'payout_04',
            SUM(IF(ts.end_date >= @period_3
                AND ts.end_date < @period_2, ts.payout, 0)) 'payout_03',
            SUM(IF(ts.end_date >= @period_2
                AND ts.end_date < @period_1, ts.payout, 0)) 'payout_02',
            SUM(IF(ts.end_date >= @period_1
                AND ts.end_date < @end_period, ts.payout, 0)) 'payout_01'
    FROM
        (SELECT 
        result.src_id 'bob_id_seller',
            result.id_seller,
            result.shop_name,
            result.root_categories,
            result.phone_number,
            result.address,
            result.email_address,
            result.seller_center_id,
            MIN(soi.created_at) 'joined_date',
            result.active_sku,
            COUNT(IF(soish.created_at >= @period_12
                AND soish.created_at < @period_11, soi.id_sales_order_item, NULL)) 'item_count_12',
            COUNT(IF(soish.created_at >= @period_11
                AND soish.created_at < @period_10, soi.id_sales_order_item, NULL)) 'item_count_11',
            COUNT(IF(soish.created_at >= @period_10
                AND soish.created_at < @period_9, soi.id_sales_order_item, NULL)) 'item_count_10',
            COUNT(IF(soish.created_at >= @period_9
                AND soish.created_at < @period_8, soi.id_sales_order_item, NULL)) 'item_count_09',
            COUNT(IF(soish.created_at >= @period_8
                AND soish.created_at < @period_7, soi.id_sales_order_item, NULL)) 'item_count_08',
            COUNT(IF(soish.created_at >= @period_7
                AND soish.created_at < @period_6, soi.id_sales_order_item, NULL)) 'item_count_07',
            COUNT(IF(soish.created_at >= @period_6
                AND soish.created_at < @period_5, soi.id_sales_order_item, NULL)) 'item_count_06',
            COUNT(IF(soish.created_at >= @period_5
                AND soish.created_at < @period_4, soi.id_sales_order_item, NULL)) 'item_count_05',
            COUNT(IF(soish.created_at >= @period_4
                AND soish.created_at < @period_3, soi.id_sales_order_item, NULL)) 'item_count_04',
            COUNT(IF(soish.created_at >= @period_3
                AND soish.created_at < @period_2, soi.id_sales_order_item, NULL)) 'item_count_03',
            COUNT(IF(soish.created_at >= @period_2
                AND soish.created_at < @period_1, soi.id_sales_order_item, NULL)) 'item_count_02',
            COUNT(IF(soish.created_at >= @period_1
                AND soish.created_at < @end_period, soi.id_sales_order_item, NULL)) 'item_count_01',
            COUNT(DISTINCT IF(soish.created_at >= @period_12
                AND soish.created_at < @period_11, soi.fk_sales_order, NULL)) 'delivered_orders_12',
            COUNT(DISTINCT IF(soish.created_at >= @period_11
                AND soish.created_at < @period_10, soi.fk_sales_order, NULL)) 'delivered_orders_11',
            COUNT(DISTINCT IF(soish.created_at >= @period_10
                AND soish.created_at < @period_9, soi.fk_sales_order, NULL)) 'delivered_orders_10',
            COUNT(DISTINCT IF(soish.created_at >= @period_9
                AND soish.created_at < @period_8, soi.fk_sales_order, NULL)) 'delivered_orders_09',
            COUNT(DISTINCT IF(soish.created_at >= @period_8
                AND soish.created_at < @period_7, soi.fk_sales_order, NULL)) 'delivered_orders_08',
            COUNT(DISTINCT IF(soish.created_at >= @period_7
                AND soish.created_at < @period_6, soi.fk_sales_order, NULL)) 'delivered_orders_07',
            COUNT(DISTINCT IF(soish.created_at >= @period_6
                AND soish.created_at < @period_5, soi.fk_sales_order, NULL)) 'delivered_orders_06',
            COUNT(DISTINCT IF(soish.created_at >= @period_5
                AND soish.created_at < @period_4, soi.fk_sales_order, NULL)) 'delivered_orders_05',
            COUNT(DISTINCT IF(soish.created_at >= @period_4
                AND soish.created_at < @period_3, soi.fk_sales_order, NULL)) 'delivered_orders_04',
            COUNT(DISTINCT IF(soish.created_at >= @period_3
                AND soish.created_at < @period_2, soi.fk_sales_order, NULL)) 'delivered_orders_03',
            COUNT(DISTINCT IF(soish.created_at >= @period_2
                AND soish.created_at < @period_1, soi.fk_sales_order, NULL)) 'delivered_orders_02',
            COUNT(DISTINCT IF(soish.created_at >= @period_1
                AND soish.created_at < @end_period, soi.fk_sales_order, NULL)) 'delivered_orders_01',
            SUM(IF(soish.created_at >= @period_12
                AND soish.created_at < @period_11, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_12',
            SUM(IF(soish.created_at >= @period_11
                AND soish.created_at < @period_10, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_11',
            SUM(IF(soish.created_at >= @period_10
                AND soish.created_at < @period_9, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_10',
            SUM(IF(soish.created_at >= @period_9
                AND soish.created_at < @period_8, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_09',
            SUM(IF(soish.created_at >= @period_8
                AND soish.created_at < @period_7, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_08',
            SUM(IF(soish.created_at >= @period_7
                AND soish.created_at < @period_6, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_07',
            SUM(IF(soish.created_at >= @period_6
                AND soish.created_at < @period_5, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_06',
            SUM(IF(soish.created_at >= @period_5
                AND soish.created_at < @period_4, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_05',
            SUM(IF(soish.created_at >= @period_4
                AND soish.created_at < @period_3, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_04',
            SUM(IF(soish.created_at >= @period_3
                AND soish.created_at < @period_2, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_03',
            SUM(IF(soish.created_at >= @period_2
                AND soish.created_at < @period_1, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_02',
            SUM(IF(soish.created_at >= @period_1
                AND soish.created_at < @end_period, IFNULL(soi.paid_price, 0), 0)) 'gross_sales_01',
            SUM(IF(soish.created_at >= @period_12
                AND soish.created_at < @period_11, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_12',
            SUM(IF(soish.created_at >= @period_11
                AND soish.created_at < @period_10, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_11',
            SUM(IF(soish.created_at >= @period_10
                AND soish.created_at < @period_9, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_10',
            SUM(IF(soish.created_at >= @period_9
                AND soish.created_at < @period_8, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_09',
            SUM(IF(soish.created_at >= @period_8
                AND soish.created_at < @period_7, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_08',
            SUM(IF(soish.created_at >= @period_7
                AND soish.created_at < @period_6, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_07',
            SUM(IF(soish.created_at >= @period_6
                AND soish.created_at < @period_5, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_06',
            SUM(IF(soish.created_at >= @period_5
                AND soish.created_at < @period_4, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_05',
            SUM(IF(soish.created_at >= @period_4
                AND soish.created_at < @period_3, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_04',
            SUM(IF(soish.created_at >= @period_3
                AND soish.created_at < @period_2, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_03',
            SUM(IF(soish.created_at >= @period_2
                AND soish.created_at < @period_1, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_02',
            SUM(IF(soish.created_at >= @period_1
                AND soish.created_at < @end_period, (IFNULL(soi.paid_price, 0) - IFNULL(soi.marketplace_commission_fee, 0) - IFNULL(CASE
                WHEN soi.fk_marketplace_merchant IS NULL THEN 0
                ELSE (CASE
                    WHEN result.tax_class = 0 THEN (0.013 * IFNULL(soi.unit_price, 0))
                    ELSE (0.020 * IFNULL(soi.unit_price, 0))
                END)
            END, 0)), 0)) 'net_sales_01'
    FROM
        (SELECT 
        result.*,
            GROUP_CONCAT(result.name_en
                SEPARATOR '; ') 'root_categories',
            COUNT(id_catalog_source) 'active_sku'
    FROM
        (SELECT 
        sel.id_seller,
            sel.src_id,
            sel.name 'shop_name',
            sel.short_code 'seller_center_id',
            sel.tax_class,
            SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'phone":"', - 1), '","', 1) 'phone_number',
            CONCAT(SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_address1":"', - 1), '","', 1), ', ', SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_city":"', - 1), '","', 1), ' ', SUBSTRING_INDEX(SUBSTRING_INDEX(sel.tmp_data, 'customercare_postcode":"', - 1), '","', 1)) 'address',
            sel.email 'email_address',
            cca_1.name_en,
            cso.id_catalog_source
    FROM
        asc_live.seller sel
    LEFT JOIN bob_live.supplier sup ON sel.src_id = sup.id_supplier
    LEFT JOIN bob_live.catalog_source cso ON sup.id_supplier = cso.fk_supplier
        AND cso.status_source = 'active'
    LEFT JOIN bob_live.catalog_simple cs ON cso.fk_catalog_simple = cs.id_catalog_simple
    LEFT JOIN bob_live.catalog_config cc ON cs.fk_catalog_config = cc.id_catalog_config
    LEFT JOIN bob_live.catalog_category cca ON cc.primary_category = cca.id_catalog_category
    LEFT JOIN bob_live.catalog_category cca_1 ON cca.lft >= cca_1.lft
        AND cca.rgt <= cca_1.rgt
        AND cca_1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            bob_live.catalog_category
        WHERE
            lft <= cca.lft AND rgt >= cca.rgt
                AND id_catalog_category <> 1
        ORDER BY id_catalog_category , lft , rgt
        LIMIT 0 , 1)
    WHERE
        FIND_IN_SET(sel.short_code, @scsellerid)
    GROUP BY sel.id_seller , cca_1.id_catalog_category) result
    GROUP BY result.id_seller) result
    LEFT JOIN oms_live.ims_sales_order_item soi ON result.src_id = soi.bob_id_supplier
    LEFT JOIN oms_live.ims_sales_order_item_status_history soish ON soi.id_sales_order_item = soish.fk_sales_order_item
        AND soish.fk_sales_order_item_status = 27
    GROUP BY result.id_seller) result
    LEFT JOIN asc_live.transaction_statement ts ON result.id_seller = ts.fk_seller
        AND ts.end_date >= @period_12
        AND ts.end_date < @end_period
    GROUP BY result.id_seller) result;