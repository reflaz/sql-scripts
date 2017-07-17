/*-----------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
Loan Application Data by Seller Center ID
 
Prepared by		: R Maliangkay
Modified by		: 
Version			: 1.0
Changes made	: 

Instructions	: - Go to your excel file
				  - Format the parameters in excel using this formula: ="'"&Column&"'," --> change Column accordingly
				  - Insert formatted parameters
                  - Delete the last comma (,)
                  - Run the query by pressing the execute button
                  - Wait until the query finished, then export the result
                  - Close the query WITHOUT SAVING ANY CHANGES
-------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------*/

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

SELECT '12' AS 'period', @period_12 AS 'beginning_date' 
UNION ALL SELECT '11' AS 'period', @period_11 
UNION ALL SELECT '10' AS 'period', @period_10 
UNION ALL SELECT '09' AS 'period', @period_9 
UNION ALL SELECT '08' AS 'period', @period_8 
UNION ALL SELECT '07' AS 'period', @period_7 
UNION ALL SELECT '06' AS 'period', @period_6 
UNION ALL SELECT '05' AS 'period', @period_5 
UNION ALL SELECT '04' AS 'period', @period_4 
UNION ALL SELECT '03' AS 'period', @period_3 
UNION ALL SELECT '02' AS 'period', @period_2 
UNION ALL SELECT '01' AS 'period', @period_1 
UNION ALL SELECT 'end_period' AS 'period', @end_period;

SELECT 
    *
FROM
    (SELECT 
        shop_name,
            root_categories,
            email_address,
            seller_center_id,
            joined_date_as_merchant,
            gross_sales_12,
            gross_sales_11,
            gross_sales_10,
            gross_sales_09,
            gross_sales_08,
            gross_sales_07,
            gross_sales_06,
            gross_sales_05,
            gross_sales_04,
            gross_sales_03,
            gross_sales_02,
            gross_sales_01,
            net_sales_12,
            net_sales_11,
            net_sales_10,
            net_sales_09,
            net_sales_08,
            net_sales_07,
            net_sales_06,
            net_sales_05,
            net_sales_04,
            net_sales_03,
            net_sales_02,
            net_sales_01,
            item_count_12,
            item_count_11,
            item_count_10,
            item_count_09,
            item_count_08,
            item_count_07,
            item_count_06,
            item_count_05,
            item_count_04,
            item_count_03,
            item_count_02,
            item_count_01,
            number_of_sku,
            delivered_orders_12,
            delivered_orders_11,
            delivered_orders_10,
            delivered_orders_09,
            delivered_orders_08,
            delivered_orders_07,
            delivered_orders_06,
            delivered_orders_05,
            delivered_orders_04,
            delivered_orders_03,
            delivered_orders_02,
            delivered_orders_01,
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
        id_seller,
            shop_name,
            root_categories,
            email_address,
            seller_center_id,
            joined_date_as_merchant,
            SUM(gross_sales_12) gross_sales_12,
            SUM(gross_sales_11) gross_sales_11,
            SUM(gross_sales_10) gross_sales_10,
            SUM(gross_sales_09) gross_sales_09,
            SUM(gross_sales_08) gross_sales_08,
            SUM(gross_sales_07) gross_sales_07,
            SUM(gross_sales_06) gross_sales_06,
            SUM(gross_sales_05) gross_sales_05,
            SUM(gross_sales_04) gross_sales_04,
            SUM(gross_sales_03) gross_sales_03,
            SUM(gross_sales_02) gross_sales_02,
            SUM(gross_sales_01) gross_sales_01,
            SUM(net_sales_12) net_sales_12,
            SUM(net_sales_11) net_sales_11,
            SUM(net_sales_10) net_sales_10,
            SUM(net_sales_09) net_sales_09,
            SUM(net_sales_08) net_sales_08,
            SUM(net_sales_07) net_sales_07,
            SUM(net_sales_06) net_sales_06,
            SUM(net_sales_05) net_sales_05,
            SUM(net_sales_04) net_sales_04,
            SUM(net_sales_03) net_sales_03,
            SUM(net_sales_02) net_sales_02,
            SUM(net_sales_01) net_sales_01,
            SUM(item_count_12) item_count_12,
            SUM(item_count_11) item_count_11,
            SUM(item_count_10) item_count_10,
            SUM(item_count_09) item_count_09,
            SUM(item_count_08) item_count_08,
            SUM(item_count_07) item_count_07,
            SUM(item_count_06) item_count_06,
            SUM(item_count_05) item_count_05,
            SUM(item_count_04) item_count_04,
            SUM(item_count_03) item_count_03,
            SUM(item_count_02) item_count_02,
            SUM(item_count_01) item_count_01,
            number_of_sku,
            SUM(delivered_orders_12) delivered_orders_12,
            SUM(delivered_orders_11) delivered_orders_11,
            SUM(delivered_orders_10) delivered_orders_10,
            SUM(delivered_orders_09) delivered_orders_09,
            SUM(delivered_orders_08) delivered_orders_08,
            SUM(delivered_orders_07) delivered_orders_07,
            SUM(delivered_orders_06) delivered_orders_06,
            SUM(delivered_orders_05) delivered_orders_05,
            SUM(delivered_orders_04) delivered_orders_04,
            SUM(delivered_orders_03) delivered_orders_03,
            SUM(delivered_orders_02) delivered_orders_02,
            SUM(delivered_orders_01) delivered_orders_01
    FROM
        (SELECT 
        result.id_seller,
            result.name 'shop_name',
            result.root_categories 'root_categories',
            result.email 'email_address',
            result.short_code 'seller_center_id',
            result.joined_date 'joined_date_as_merchant',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_01',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_01',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, tr.value, NULL), NULL)) 'item_count_12',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, tr.value, NULL), NULL)) 'item_count_11',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, tr.value, NULL), NULL)) 'item_count_10',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, tr.value, NULL), NULL)) 'item_count_09',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, tr.value, NULL), NULL)) 'item_count_08',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, tr.value, NULL), NULL)) 'item_count_07',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, tr.value, NULL), NULL)) 'item_count_06',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, tr.value, NULL), NULL)) 'item_count_05',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, tr.value, NULL), NULL)) 'item_count_04',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, tr.value, NULL), NULL)) 'item_count_03',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, tr.value, NULL), NULL)) 'item_count_02',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, tr.value, NULL), NULL)) 'item_count_01',
            result.number_of_sku 'number_of_sku',
            MAX(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_12',
            MAX(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_11',
            MAX(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_10',
            MAX(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_09',
            MAX(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_08',
            MAX(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_07',
            MAX(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_06',
            MAX(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_05',
            MAX(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_04',
            MAX(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_03',
            MAX(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_02',
            MAX(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_01'
    FROM
        (SELECT 
        result.*, MIN(soi.created_at) 'joined_date'
    FROM
        (SELECT 
        result.*,
            GROUP_CONCAT(result.name_en
                SEPARATOR '; ') 'root_categories'
    FROM
        (SELECT 
        sel.id_seller,
            sel.src_id,
            sel.name,
            sel.short_code,
            sel.email,
            cca_1.name_en,
            (SELECT 
                    COUNT(id_catalog_product)
                FROM
                    screport.seller sels
                LEFT JOIN screport.catalog_product cp ON cp.fk_seller = sels.id_seller
                LEFT JOIN screport.catalog_category cc ON cp.primary_category = cc.id_catalog_category
                WHERE
                    sels.id_seller = sel.id_seller
                        AND cp.status = 'active') 'number_of_sku'
    FROM
        screport.seller sel
    LEFT JOIN screport.catalog_product cp ON cp.fk_seller = sel.id_seller
        AND cp.status = 'active'
    LEFT JOIN screport.catalog_category cca ON cp.primary_category = cca.id_catalog_category
    LEFT JOIN screport.catalog_category cca_1 ON cca.lft >= cca_1.lft
        AND cca.rgt <= cca_1.rgt
        AND cca_1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cca.lft AND rgt >= cca.rgt
                AND id_catalog_category <> 1
        ORDER BY lft
        LIMIT 0 , 1)
    WHERE
        sel.short_code IN ()
    GROUP BY sel.id_seller , cca_1.id_catalog_category) result
    GROUP BY result.id_seller) result
    LEFT JOIN oms_live.ims_sales_order_item soi ON result.src_id = soi.bob_id_supplier
    GROUP BY result.id_seller) result
    LEFT JOIN screport.transaction tr ON result.id_seller = tr.fk_seller
    LEFT JOIN asc_live.transaction atr ON tr.number = atr.number
    LEFT JOIN screport.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    WHERE
        atr.id_transaction IS NULL
    GROUP BY result.id_seller , soi.fk_sales_order) result
    GROUP BY result.id_seller) result
    LEFT JOIN screport.transaction_statement ts ON result.id_seller = ts.fk_seller) lsc_data;
    
SELECT 
    *
FROM
    (SELECT 
        shop_name,
            root_categories,
            email_address,
            seller_center_id,
            joined_date_as_merchant,
            gross_sales_12,
            gross_sales_11,
            gross_sales_10,
            gross_sales_09,
            gross_sales_08,
            gross_sales_07,
            gross_sales_06,
            gross_sales_05,
            gross_sales_04,
            gross_sales_03,
            gross_sales_02,
            gross_sales_01,
            net_sales_12,
            net_sales_11,
            net_sales_10,
            net_sales_09,
            net_sales_08,
            net_sales_07,
            net_sales_06,
            net_sales_05,
            net_sales_04,
            net_sales_03,
            net_sales_02,
            net_sales_01,
            item_count_12,
            item_count_11,
            item_count_10,
            item_count_09,
            item_count_08,
            item_count_07,
            item_count_06,
            item_count_05,
            item_count_04,
            item_count_03,
            item_count_02,
            item_count_01,
            number_of_sku,
            delivered_orders_12,
            delivered_orders_11,
            delivered_orders_10,
            delivered_orders_09,
            delivered_orders_08,
            delivered_orders_07,
            delivered_orders_06,
            delivered_orders_05,
            delivered_orders_04,
            delivered_orders_03,
            delivered_orders_02,
            delivered_orders_01,
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
        id_seller,
            shop_name,
            root_categories,
            email_address,
            seller_center_id,
            joined_date_as_merchant,
            SUM(gross_sales_12) gross_sales_12,
            SUM(gross_sales_11) gross_sales_11,
            SUM(gross_sales_10) gross_sales_10,
            SUM(gross_sales_09) gross_sales_09,
            SUM(gross_sales_08) gross_sales_08,
            SUM(gross_sales_07) gross_sales_07,
            SUM(gross_sales_06) gross_sales_06,
            SUM(gross_sales_05) gross_sales_05,
            SUM(gross_sales_04) gross_sales_04,
            SUM(gross_sales_03) gross_sales_03,
            SUM(gross_sales_02) gross_sales_02,
            SUM(gross_sales_01) gross_sales_01,
            SUM(net_sales_12) net_sales_12,
            SUM(net_sales_11) net_sales_11,
            SUM(net_sales_10) net_sales_10,
            SUM(net_sales_09) net_sales_09,
            SUM(net_sales_08) net_sales_08,
            SUM(net_sales_07) net_sales_07,
            SUM(net_sales_06) net_sales_06,
            SUM(net_sales_05) net_sales_05,
            SUM(net_sales_04) net_sales_04,
            SUM(net_sales_03) net_sales_03,
            SUM(net_sales_02) net_sales_02,
            SUM(net_sales_01) net_sales_01,
            SUM(item_count_12) item_count_12,
            SUM(item_count_11) item_count_11,
            SUM(item_count_10) item_count_10,
            SUM(item_count_09) item_count_09,
            SUM(item_count_08) item_count_08,
            SUM(item_count_07) item_count_07,
            SUM(item_count_06) item_count_06,
            SUM(item_count_05) item_count_05,
            SUM(item_count_04) item_count_04,
            SUM(item_count_03) item_count_03,
            SUM(item_count_02) item_count_02,
            SUM(item_count_01) item_count_01,
            number_of_sku,
            SUM(delivered_orders_12) delivered_orders_12,
            SUM(delivered_orders_11) delivered_orders_11,
            SUM(delivered_orders_10) delivered_orders_10,
            SUM(delivered_orders_09) delivered_orders_09,
            SUM(delivered_orders_08) delivered_orders_08,
            SUM(delivered_orders_07) delivered_orders_07,
            SUM(delivered_orders_06) delivered_orders_06,
            SUM(delivered_orders_05) delivered_orders_05,
            SUM(delivered_orders_04) delivered_orders_04,
            SUM(delivered_orders_03) delivered_orders_03,
            SUM(delivered_orders_02) delivered_orders_02,
            SUM(delivered_orders_01) delivered_orders_01
    FROM
        (SELECT 
        result.id_seller,
            result.name 'shop_name',
            result.root_categories 'root_categories',
            result.email 'email_address',
            result.short_code 'seller_center_id',
            result.joined_date 'joined_date_as_merchant',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, tr.value, 0), 0)) 'gross_sales_01',
            SUM(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_12',
            SUM(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_11',
            SUM(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_10',
            SUM(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_09',
            SUM(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_08',
            SUM(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_07',
            SUM(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_06',
            SUM(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_05',
            SUM(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_04',
            SUM(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_03',
            SUM(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_02',
            SUM(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type IN (3 , 13, 16), tr.value, 0), 0)) 'net_sales_01',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, tr.value, NULL), NULL)) 'item_count_12',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, tr.value, NULL), NULL)) 'item_count_11',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, tr.value, NULL), NULL)) 'item_count_10',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, tr.value, NULL), NULL)) 'item_count_09',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, tr.value, NULL), NULL)) 'item_count_08',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, tr.value, NULL), NULL)) 'item_count_07',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, tr.value, NULL), NULL)) 'item_count_06',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, tr.value, NULL), NULL)) 'item_count_05',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, tr.value, NULL), NULL)) 'item_count_04',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, tr.value, NULL), NULL)) 'item_count_03',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, tr.value, NULL), NULL)) 'item_count_02',
            COUNT(IF(tr.fk_transaction_type = 13, IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, tr.value, NULL), NULL)) 'item_count_01',
            result.number_of_sku 'number_of_sku',
            MAX(IF(tr.created_at >= @period_12
                AND tr.created_at < @period_11, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_12',
            MAX(IF(tr.created_at >= @period_11
                AND tr.created_at < @period_10, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_11',
            MAX(IF(tr.created_at >= @period_10
                AND tr.created_at < @period_9, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_10',
            MAX(IF(tr.created_at >= @period_9
                AND tr.created_at < @period_8, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_09',
            MAX(IF(tr.created_at >= @period_8
                AND tr.created_at < @period_7, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_08',
            MAX(IF(tr.created_at >= @period_7
                AND tr.created_at < @period_6, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_07',
            MAX(IF(tr.created_at >= @period_6
                AND tr.created_at < @period_5, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_06',
            MAX(IF(tr.created_at >= @period_5
                AND tr.created_at < @period_4, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_05',
            MAX(IF(tr.created_at >= @period_4
                AND tr.created_at < @period_3, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_04',
            MAX(IF(tr.created_at >= @period_3
                AND tr.created_at < @period_2, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_03',
            MAX(IF(tr.created_at >= @period_2
                AND tr.created_at < @period_1, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_02',
            MAX(IF(tr.created_at >= @period_1
                AND tr.created_at < @end_period, IF(tr.fk_transaction_type = 13, 1, 0), 0)) 'delivered_orders_01'
    FROM
        (SELECT 
        result.*, MIN(soi.created_at) 'joined_date'
    FROM
        (SELECT 
        result.*,
            GROUP_CONCAT(result.name_en
                SEPARATOR '; ') 'root_categories'
    FROM
        (SELECT 
        sel.id_seller,
            sel.src_id,
            sel.name,
            sel.short_code,
            sel.email,
            cca_1.name_en,
            (SELECT 
                    COUNT(id_catalog_product)
                FROM
                    screport.seller sels
                LEFT JOIN screport.catalog_product cp ON cp.fk_seller = sels.id_seller
                LEFT JOIN screport.catalog_category cc ON cp.primary_category = cc.id_catalog_category
                WHERE
                    sels.id_seller = sel.id_seller
                        AND cp.status = 'active') 'number_of_sku'
    FROM
        screport.seller sel
    LEFT JOIN screport.catalog_product cp ON cp.fk_seller = sel.id_seller
        AND cp.status = 'active'
    LEFT JOIN screport.catalog_category cca ON cp.primary_category = cca.id_catalog_category
    LEFT JOIN screport.catalog_category cca_1 ON cca.lft >= cca_1.lft
        AND cca.rgt <= cca_1.rgt
        AND cca_1.id_catalog_category = (SELECT 
            id_catalog_category
        FROM
            screport.catalog_category
        WHERE
            lft <= cca.lft AND rgt >= cca.rgt
                AND id_catalog_category <> 1
        ORDER BY lft
        LIMIT 0 , 1)
    WHERE
        sel.short_code IN ()
    GROUP BY sel.id_seller , cca_1.id_catalog_category) result
    GROUP BY result.id_seller) result
    LEFT JOIN oms_live.ims_sales_order_item soi ON result.src_id = soi.bob_id_supplier
    GROUP BY result.id_seller) result
    LEFT JOIN asc_live.transaction tr ON result.id_seller = tr.fk_seller
    LEFT JOIN asc_live.sales_order_item soi ON tr.ref = soi.id_sales_order_item
    GROUP BY result.id_seller , soi.fk_sales_order) result
    GROUP BY result.id_seller) result
    LEFT JOIN screport.transaction_statement ts ON result.id_seller = ts.fk_seller) asc_data;